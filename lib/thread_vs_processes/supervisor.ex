defmodule ThreadVsProcesses.Supervisor do
    @moduledoc false

    use Supervisor
    @name __MODULE__

    def start_link() do
        children = [
            supervisor(Process.Supervisor, []),
            supervisor(DynamicProcess.Supervisor, []),
            worker(ThreadVsProcesses.Runner, [])
        ]
        opts = [strategy: :one_for_one, name: Plover.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
