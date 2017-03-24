defmodule Ws.Application do
  use Application

  def start(_type, _args) do
    IO.puts "Running application"
    Ws.Supervisor.start_link
  end

end
