defmodule SendServer do
  use GenServer

  def init(args) do
    IO.puts("Received arguments: #{inspect(args)}")
    max_retries = Keyword.get(args, :max_retries, 5)
    Process.send_after(self(), :retry, 5000)
    state = %{emails: [], max_retries: max_retries}
    {:ok, state, {:continue, :fetch_from_database}}
  end

  # handle_continue/2: Maneja la carga de usuarios desde la base de datos
  def handle_continue(:fetch_from_database, state) do
    # Simulación de una operación costosa
    users = fetch_users_from_database()

    # Actualiza el estado con los usuarios cargados
    {:noreply, Map.put(state, :users, users)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:send, email}, state) do
    status =
      case Sender.send_email(email) do
        {:ok, "email_sent"} -> "sent"
        :error -> "failed"
      end

    emails = [%{email: email, status: status, retries: 00}] ++ state.emails

    {:noreply, %{state | emails: emails}}
  end

  def handle_info(:retry, state) do
    {failed, done} =
      Enum.split_with(state.emails, fn item ->
        item.status == "failed" && item.retries < state.max_retries
      end)

    retried =
      Enum.map(failed, fn item ->
        IO.puts("Retrying email #{item.email}...")

        new_status =
          case Sender.send_email(item.email) do
            {:ok, "email_sent"} -> "sent"
            :error -> "failed"
          end

        %{email: item.email, status: new_status, retries: item.retries + 1}
      end)

    # Programar otro reintento después de 5 segundos
    Process.send_after(self(), :retry, 5000)

    # Actualizar el estado del proceso
    {:noreply, %{state | emails: retried ++ done}}
  end

  def terminate(reason, _state) do
    IO.puts("Terminating with reason #{reason}")
  end

  # Simulación de una función que consulta la base de datos
  defp fetch_users_from_database do
    Process.sleep(2000) # Simula un retraso
    [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
  end
end
