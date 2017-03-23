defmodule Ws.Listener do
  use GenServer

  def start_link(sender, socket) do
    GenServer.start_link(__MODULE__, %{sender: sender, socket: socket})
  end

  def init(%{sender: sender, socket: socket} = state) do
    send self(), :listen
    {:ok, state}
  end

  def listen(sender, socket) do
    case socket |> Socket.Web.recv! do
      {:ping, _} -> 
        IO.puts "Ping"
        send sender, :pong

      {:text, msg} ->
        IO.inspect msg

      {:close, _, _} ->
        IO.puts "closed"
      _ -> 
        IO.puts "something wered"
    end
    listen(sender, socket)
  end

  def handle_info(:listen, %{sender: sender, socket: socket} = state) do
    listen(sender, socket)
    {:noreply, state}
  end
end 
