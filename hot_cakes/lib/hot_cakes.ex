defmodule HotCakes do
  @moduledoc """
  Implementa un ejemplo de modelo de actores de un Restaurante llamado hot cakes
  """

  alias Cocinero
  alias Mesero
  alias Cliente
  alias Repartidor

  @spec start() :: :ok
  def start() do
    # Crea a los actores
    cliente = Cliente.start_cliente("Emy")
    repartidor = Repartidor.start_repartir()
    cocinero = Cocinero.start_cocinero(repartidor)
    mesero = Mesero.start_tomando_pedido()

    send(mesero, {:nuevo_pedido, cliente, "3 Hot cakes de Chocolate", cocinero})
  end
end
