defmodule Process.Supervisor do
    @moduledoc false

    use Supervisor
    @registered_name __MODULE__
    @workers 100

    def start_link() do
        Supervisor.start_link(@registered_name, :no_args, [name: @registered_name])
    end


    def init(:no_args) do
        children = for c <- 1..@workers, do: worker(Process.Benchmark, [c], id: c)
        supervise(children, strategy: :one_for_one)
    end

    def start_benchmark do
        all_names = for c <- 1..@workers, do: process_name(c)

        all_names
        |> Enum.map(fn name ->
            pid = Process.whereis(name)
            Process.Benchmark.calculate(pid)
            pid
        end)
        |> Enum.map_reduce(0, fn (pid, acc) ->
            value = Process.Benchmark.get_calculate(pid)
            {value, acc + value}
        end)

        IO.puts "(STATIC) DONE"
    end

    defp process_name(id) do
        String.to_atom("Benchmark#{id}")
    end
end
