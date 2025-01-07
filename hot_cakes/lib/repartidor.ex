defmodule Repartidor do
  @moduledoc """
  Implementa un actor que representa un Repartidor.
  """

  @spec start_repartir() :: :ok
  def start_repartir do
    spawn(fn -> repartir_loop() end)
  end

  # Se gestiona la lógica del repartidor.
  # Mantiene el control sobre el estado implementando un receive el cual recibe y envia mensajes
  @spec repartir_loop() :: :ok
  defp repartir_loop do
    receive do
      {:entregar_orden, cliente, orden} ->
        IO.puts("[Repartidor]: Entregando #{orden} a #{inspect(cliente)}...")
        :timer.sleep(1000)  # Simula el tiempo de entrega
        send(cliente, {:orden_entregada, orden})
        repartir_loop()

      :cerrar ->
        IO.puts("[Repartidor]: Cerrando servicio de entrega.")

      _ ->
        IO.puts("[Repartidor]: Mensaje desconocido.")
        repartir_loop()
    end
  end
end
