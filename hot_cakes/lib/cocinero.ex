defmodule Cocinero do
  @moduledoc """
  Implementa un actor que representa un Cocinero.
  """

  @spec start_cocinero(pid()) :: :ok
  def start_cocinero(repartidor) do
    spawn(fn -> cocinero_loop(repartidor) end)
  end

  @spec cocinero_loop(pid()) :: :ok
  def cocinero_loop(repartidor) do
      receive do
      {:preparar_orden, cliente, orden} ->
        IO.puts("[Cocinero]: Preparando #{orden} de hot cakes para #{inspect(cliente)}...")
        :timer.sleep(2000)  # Simula el tiempo de preparación
        send(self(), {:orden_lista, cliente, orden})  # Enviar a sí mismo como ejemplo de uso de mailbox

        cocinero_loop(repartidor)

      {:orden_lista, cliente, orden} ->
        IO.puts("[Cocinero]: Orden lista: #{orden} para #{inspect(cliente)}. Enviando al mesero.")
        send(repartidor, {:entregar_orden, cliente, orden})  # El repartidor es también un actor
        cocinero_loop(repartidor)

      :cerrar ->
        IO.puts("[Cocinero]: Cerrando cocina.")
    end
  end
end
