defmodule BookingsPipeline do
  use Broadway

  alias Broadway.Message
  alias Tickets

  @producer BroadwayRabbitMQ.Producer
  @producer_config [
    queue: "bookings_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue
  ]

  def start_link(_args) do
    options = [
      name: BookingsPipeline,
      producer: [
        module: {@producer, @producer_config},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: System.schedulers_online() * 2
        ]
      ],
      batchers: [
        cinema: [],
        musical: [],
        default: []
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  @impl true
  @spec prepare_messages([Message.t()], any()) :: [Message.t()]
  def prepare_messages(messages, _context) do
    # Parse los datos para convertirlos a un mapa.
    messages =
      Enum.map(messages, fn message ->
        Message.update_data(message, fn data ->
          [event, user_id] = String.split(data, ",")
          %{event: event, user_id: user_id}
        end)
      end)

    users = Tickets.users_by_ids(Enum.map(messages, & &1.data.user_id))

    # Agregamos los users en mensajes
    Enum.map(messages, fn message ->
      Message.update_data(message, fn data ->
        user = Enum.find(users, & &1.id == data.user_id)
        Map.put(data, :user, user)
      end)
    end)
  end

  @impl true
  @spec handle_message(atom(), Message.t(), any()) :: Message.t()
  def handle_message(_processor, message, _context) do
    # Agregamos nuestra logica del negocio aqui.

    %{data: %{event: event, user: user}} = message

    # Checamos por disponibilidad de tickets
    if Tickets.tickets_available?(event) do
      case message do
        %{data: %{event: "cinema"}} = message ->
          Message.put_batcher(message, :cinema)

        %{data: %{event: "musical"}} = message ->
          Message.put_batcher(message, :musical)

        message ->
          message
      end
    else
      Message.failed(message, "bookings-closed")
    end
  end

  @impl true
  @spec handle_failed([Message.t()], any()) :: :ok
  def handle_failed(messages, _context) do
    IO.inspect(messages, label: "Failed messages")

    Enum.map(messages, fn
      %{status: {:failed, "bookings-closed"}} = message ->
        Message.configure_ack(message, on_failure: :reject)

      message -> message
    end)
  end

  def handle_batch(_batcher, messages, batch_info, _context) do
    IO.puts("#{inspect(self())} Batch #{batch_info.batcher} #{batch_info.batch_key}")

    messages
    |> Tickets.insert_all_tickets()
    |> Enum.each(fn %{data: %{user: user}} ->
      Tickets.send_email(user)
    end)

    messages
  end
end
