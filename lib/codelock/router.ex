defmodule Codelock.Router do
  use Plug.Router
  use Plug.Debugger

  plug Plug.Logger
  plug Corsica, origins: "*", allow_headers: ["accept", "content-type"]
  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :dispatch
  # XXX make a plug that does auth for us

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http Codelock.Router, []
  end

  post "/digital_write/:gpio_out/:value" do
    gpio_out |> String.to_integer |> digital_write(String.to_integer(value))
    send_resp(conn, 200, "{}")
  end

  post "/digital_read/:gpio_in" do
    value = gpio_in |> String.to_integer |> digital_read
    send_resp(conn, 200, Poison.encode!(%{ value: value }))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp digital_write(pin, value) do
    {:ok, pid} = Gpio.start_link(pin, :output)
    Gpio.write(pid, value)
    IO.puts "Wrote #{value} to pin #{pin}"
    Process.exit(pid, :normal)
    value
  end

  defp digital_read(pin) do
    {:ok, pid} = Gpio.start_link(pin, :input)
    value = Gpio.read(pid)
    IO.puts "Read #{value} from pin #{pin}"
    Process.exit(pid, :normal)
    value
  end
end
