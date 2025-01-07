defmodule Cocinero do
  @moduledoc """
  Implementa un actor que representa un Cocinero.
  """

  @spec start_cocinero() :: :ok
  def start_cocinero do
    spawn(fn -> cocinero_loop() end)
  end

  @spec cocinero_loop() :: :ok
  def cocinero_loop() do
      receive do
      {:preparar_orden, cliente, orden} ->
        IO.puts("[Cocinero]: Preparando #{orden} de hot cakes para #{inspect(cliente)}...")
        :timer.sleep(2000)  # Simula el tiempo de preparación
        send(self(), {:orden_lista, cliente, orden})  # Enviar a sí mismo como ejemplo de uso de mailbox

        cocinero_loop()

      {:orden_lista, cliente, orden} ->
        IO.puts("[Cocinero]: Orden lista: #{orden} para #{inspect(cliente)}. Enviando al mesero.")
        send(cliente, {:orden_entregada, orden})  # El cliente es también un actor
        cocinero_loop()

      :cerrar ->
        IO.puts("[Cocinero]: Cerrando cocina.")
    end
  end
end
