defmodule DynamicProcess.Benchmark do
    use GenServer

    def start_link(opts) do
        GenServer.start_link(__MODULE__, [], opts)
    end

    def init(state) do
        {:ok, state}
    end

    def calculate(pid) do
        GenServer.cast(pid, :calculate)
    end

    def get_calculate(pid) do
        GenServer.call(pid, :get_calculate, 10_000)
    end


    # Callbacks

    def handle_cast(:calculate, _state) do
        result =
        Enum.to_list(1..1_000_000)
        |> Enum.reduce(fn(x, acc) -> acc + x end)
        # IO.puts "(Dynamic Process)DONE= #{inspect self()} RESULT= #{inspect result}"
        {:noreply, [result]}
    end

    def handle_call(:get_calculate, _from, state) do
        [number] = state
        {:reply, number, state}
    end
end
