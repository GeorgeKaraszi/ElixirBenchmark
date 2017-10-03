defmodule ThreadsVsProcesses do
  @moduledoc false

  use Application


  def start(_type, _args) do
    :observer.start
    ThreadVsProcesses.Supervisor.start_link()
  end
end
