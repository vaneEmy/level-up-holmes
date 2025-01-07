defmodule Mesero do
  @moduledoc """
  Implementa un actor que representa un Mesero.
  """

  @spec start_tomando_pedido() :: :ok
  def start_tomando_pedido do
    spawn(fn -> tomando_pedido_loop() end)
  end

  # Se gestiona la lógica del Mesero.
  # Mantiene el control sobre el estado implementando un receive el cual recibe y envia mensajes
  @spec tomando_pedido_loop() :: :ok
  defp tomando_pedido_loop do
    receive do
      {:nuevo_pedido, cliente, orden, cocinero} ->
        IO.puts("[Mesero]: Pedido recibido de #{inspect(cliente)}: #{orden}")
        send(cocinero, {:preparar_orden, cliente, orden})
        tomando_pedido_loop()

      :cerrar ->
        IO.puts("[Mesero]: Cerrando servicio.")

      _ ->
        IO.puts("[Mesero]: Mensaje desconocido.")
        tomando_pedido_loop()
    end
  end
end
