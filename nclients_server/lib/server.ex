
# distributed algorithms, n.dulay, 4 jan 18
# simple client-server, v1

defmodule Server do

def start do
  IO.puts ["      Server at ", DNS.my_ip_addr()]
  receive do
  { :bind, client } -> next()
  end
end # start

def next() do
  # We remove the client parameter from the function so that the client
  # that makes the request (and that sends its id as the payload)
  # will be notified back by the server.
  receive do
  { :circle, radius, :pid, client_id } ->
    send client_id, { :result, 3.14159 * radius * radius }
    IO.puts ["Received message from ", inspect(client_id)]
  { :square, side, :pid, client_id } ->
    send client_id, { :result, side * side }
    IO.puts ["Received message from ", inspect(client_id)]
  end
  next()
end # next

end # module -----------------------
