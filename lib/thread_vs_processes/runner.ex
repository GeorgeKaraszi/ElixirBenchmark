defmodule ThreadVsProcesses.Runner do
    @moduledoc false
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
      end

      def init(:no_args) do
        {:ok, %{}}
      end

    def start_benchmarks do
        GenServer.cast(__MODULE__, :benchmark)
    end

    def handle_cast(:benchmark, state) do

        Benchee.run(%{
            "Predefined Processes" => fn -> Process.Supervisor.start_benchmark end,
            "Dynamicly Created Processes" => fn -> DynamicProcess.Supervisor.start_benchmark end
        }, time: 20, print: [fast_warning: false],
        formatters: [
          &Benchee.Formatters.HTML.output/1,
          &Benchee.Formatters.Console.output/1
        ],
        formatter_options: [html: [file: "samples_output/my.html"]],)

        {:noreply, state}
    end
end
