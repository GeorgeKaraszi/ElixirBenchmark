defmodule DynamicProcess.Supervisor do
    @moduledoc false

    use Supervisor

    @registered_name __MODULE__
    @workers 100

    def start_link() do
        Supervisor.start_link(@registered_name, :no_args, [name: @registered_name])
    end


    def init(:no_args) do
        children = [worker(DynamicProcess.Benchmark, [], restart: :transient)]
        supervise(children, strategy: :simple_one_for_one)
    end


    def start_benchmark do
        all_names = for c <- 1..@workers, do: process_name(c)

        all_names
        |> Enum.map(fn name ->
            {:ok, pid} = Supervisor.start_child(DynamicProcess.Supervisor, [[name: name]])
            DynamicProcess.Benchmark.calculate(pid)
            pid
        end)
        |> Enum.map_reduce(0, fn (pid, acc) ->
            value = DynamicProcess.Benchmark.get_calculate(pid)
            Supervisor.terminate_child(DynamicProcess.Supervisor, pid)
            {value, acc + value}
        end)

        IO.puts "(DYNAMIC) DONE"
    end

    defp process_name(id) do
        String.to_atom("DynamicBench#{id}")
    end
end
