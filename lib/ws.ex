defmodule Ws do
  use Application

  def start(_type, _args) do
    IO.puts "started"
    Ws.Supervisor.start_link
  end
end
