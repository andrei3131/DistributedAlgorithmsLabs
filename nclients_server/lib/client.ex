
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Client do

def start do
  IO.puts ["      Client at ", DNS.my_ip_addr()]
  receive do
  { :bind, server } -> next(server)
  end
end

defp next(server) do
  if :rand.uniform() < 0.5 do
     send server, { :circle, 1.0, :pid, self()}
  else
     send server, { :square, 5.0, :pid, self()}
  end
  receive do
  { :result, area } ->
    IO.puts "Area is #{area}"
  end
  Process.sleep(DAC.random(3) * 1000)
  next(server)
end

end # module -----------------------
