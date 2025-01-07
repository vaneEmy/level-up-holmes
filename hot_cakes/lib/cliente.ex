defmodule Cliente do
  @moduledoc """
  Implementa un actor que representa un Cliente.
  """

  @spec start_cliente(String.t()) :: :ok
  def start_cliente(nombre) do
    spawn(fn -> cliente_loop(nombre) end)
  end

  # Se gestiona la lógica del cliente.
  # Mantiene el control sobre el estado implementando un `receive` el cual recibe y envia mensajes
  @spec cliente_loop(String.t()) :: :ok
  defp cliente_loop(nombre) do
    receive do
      {:orden_entregada, orden} ->
        IO.puts("[Cliente #{nombre}]: ¡Gracias! Recibí mi #{orden}.")
        cliente_loop(nombre)

      _ ->
        IO.puts("[Cliente #{nombre}]: Mensaje desconocido.")
        cliente_loop(nombre)
    end
  end
end
