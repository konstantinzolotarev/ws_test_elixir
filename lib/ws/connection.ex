defmodule Ws.Connection do
  use GenServer
  @socketUrl "echo.websocket.org"

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    socket = connect()
    listenerPid = Ws.Listener.start_link(self(), socket)
    IO.inspect listenerPid
    {:ok, %{socket: socket, listener: listenerPid}}
  end

  def connect do
    Socket.Web.connect! @socketUrl
  end

  def send_text(pid) do
    GenServer.cast(pid, :send_something)
  end

  def ws_send(socket, msg) do
    socket |> Socket.Web.send!(msg)
  end

  def handle_call(:close, _from, %{listener: pid} = state) do
    Process.exit(pid, :kill)
    {:reply, {}, %{state | listener: nil}}
  end

  def handle_cast(:send_something, %{socket: socket} = state) do
    IO.puts "send something"
    text = "Something"
    socket 
    |> ws_send({:text, text})
    {:noreply, state}
  end

  def handle_info(:pong, %{socket: socket} = state) do
    IO.puts "pong"
    socket |> ws_send({:pong, ""})
    {:noreply, state}
  end
end
