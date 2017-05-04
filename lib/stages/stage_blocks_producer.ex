defmodule Golos.Stage.Block.Producer do
  use GenStage

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state)  do
    :timer.send_interval(1_000, :tick)
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info(:tick, state) do
    {:ok, %{"head_block_number" => height}} = Golos.get_dynamic_global_properties()
    if height === state[:previous_height] do
      {:noreply, [], state}
    else
      {:ok, block} = Golos.get_block(height)
      {:noreply, [block], put_in(state, [:previous_height], height)}
    end
  end
end