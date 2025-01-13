defmodule Scrapper do
  @moduledoc """
  Documentation for `Scrapper`.
  """

  def online?(_url) do
    # Simulamos si el servicio esta en linea o no
    work()

    Enum.random([false, true, true])
  end

  def work do
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
