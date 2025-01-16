defmodule PageConsumer do
  # Codigo refactorizdo para utilizar Task, en vez de GenStage

  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")

    Task.start_link(fn ->
      Scrapper.work()
    end)
  end

  # Ejemplo para usar PageConsumer con GenStage sin el uso de ConsumerSupervisor
  # use GenStage
  # require Logger

  # def start_link(_args) do
  #   initial_state = []
  #   GenStage.start_link(__MODULE__, initial_state)
  # end

  # def init(initial_state) do
  #   Logger.info("PageConsumer init")
  #   sub_opts = [
  #     {PageProducer, min_demand: 0, max_demand: 1}
  #   ]

  #   {:consumer, initial_state, subscribe_to: sub_opts}
  # end

  # def handle_events(events, _from, state) do
  #   Logger.info("PageConsumer received #{inspect(events)}")

  #   Enum.each(events, fn _page ->
  #     Scrapper.work
  #   end)

  #   {:noreply, [], state}
  # end
end
