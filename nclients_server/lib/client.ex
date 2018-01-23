
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
  rand = :rand.uniform()
  cond do
     rand < 1/3 ->
        send server, { :circle, 1.0, :pid, self()}
     rand < 2/3 ->
        send server, { :square, 5.0, :pid, self()}
     rand <= 1  ->
        send server, { :a, 3.0, :b, 4.0, :c, 5.0, :pid, self()}
  end


  receive do
  { :result, area } ->
    IO.puts "Area is #{area}"
  { :triangleArea, triangleArea } ->
    IO.puts "Area of the triangle is #{triangleArea}"
  end
  Process.sleep(DAC.random(3) * 1000)
  next(server)
end

end # module -----------------------
