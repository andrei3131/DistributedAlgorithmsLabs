# distributed algorithms, n.dulay, 4 jan 18
# simple client-server, v1

defmodule NclientsServer do

def start() do
  IO.puts ["NClientsServer at ", DNS.my_ip_addr()]

  server = spawn(Server, :start, [])

  # {intVal, _} = Integer.parse(args)
  Enum.map(1..5, fn(_) ->
      client = spawn(Client, :start, [])
      send client, { :bind, server }
      send server, { :bind, client } end)
end

def main() do
  start()
  :timer.sleep(100000)
end

end # module -----------------------
