defmodule Mesero do
  @moduledoc """
  Implementa un actor que representa un Mesero.
  """

  @spec start_tomador() :: :ok
  def start_tomador do
    spawn(fn -> tomador_loop() end)
  end

  # Se gestiona la lógica del Mesero.
  # Mantiene el control sobre el estado implementando un receive el cual recibe y envia mensajes
  @spec tomador_loop() :: :ok
  defp tomador_loop do
    receive do
      {:nuevo_pedido, cliente, orden, cocinero} ->
        IO.puts("[Tomador]: Pedido recibido de #{inspect(cliente)}: #{orden}")
        send(cocinero, {:preparar_orden, cliente, orden})
        tomador_loop()

      :cerrar ->
        IO.puts("[Tomador]: Cerrando servicio.")

      _ ->
        IO.puts("[Tomador]: Mensaje desconocido.")
        tomador_loop()
    end
  end
end
