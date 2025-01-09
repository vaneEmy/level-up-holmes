defmodule NotificationsPipeline do
  use Broadway

  alias Broadway.Message

  @producer BroadwayRabbitMQ.Producer
  @producer_config [
    queue: "notifications_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue,
    qos: [prefetch_count: 100]
  ]

  def start_link(_args) do
    options = [
      name: NotificationsPipeline,
      producer: [module: {@producer, @producer_config}],
      processors: [
        default: []
      ],
      batchers: [
        email: [concurrency: 5, batch_timeout: 10_000]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  @impl true
  @spec prepare_messages([Message.t()], any()) :: [Message.t()]
  def prepare_messages(messages, _context) do
    Enum.map(messages, fn message ->
      Message.update_data(message, fn data ->
        [type, recipient] = String.split(data, ",")
        %{type: type, recipient: recipient}
      end)
    end)
  end

  @impl true
  @spec handle_message(atom(), Message.t(), any()) :: Message.t()
  def handle_message(_processor, message, _context) do
    message
    |> Message.put_batcher(:email)
    |> Message.put_batch_key(message.data.recipient)
  end

  @impl true
  def handle_batch(_batcher, messages, batch_info, _context) do
    IO.puts("#{inspect(self())} Batch #{batch_info.batcher} #{batch_info.batch_key}")

    # Envia un email al usuario con toda la información

    messages
  end
end
