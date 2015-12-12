defmodule Codelock.Auth do
  @code Application.get_env :codelock, :code, "0000"
  def authorize(@code), do: true
  def authorize(_), do: false
end

defmodule Codelock.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Ethernet, []),
      worker(Codelock.Router, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Codelock do
  use Application
  require Logger

  def start(_type, _args) do
    IO.puts "Hello Nerves"
    Codelock.Supervisor.start_link
  end
end
