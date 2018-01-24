defmodule Peer do

def start() do
    IO.puts ["        Peer at ", DNS.my_ip_addr()]
    receive do
    { :hello, neighbours} ->
      IO.puts ["Peer ", inspect(self()), " forwards first :hello to neighbours ", inspect(neighbours)]
      Enum.map(neighbours, fn(n) ->
               send n, {:hello, neighbours, :parent, self()} end)
      receiveMembership(neighbours, 1)
    end
end

defp receiveMembership(neighbours, countHello) do
  receive do
      {:hello, _, :parent, parent_id} ->
          Process.sleep(DAC.random(3) * 1000)
          IO.puts ["Peer ", inspect(self()), " Parent ", inspect(parent_id), " Messages seen = ", inspect(countHello)]
          receiveMembership(neighbours, countHello + 1)
  after
      1000 -> IO.puts ["Peer ", inspect(self()), " Messages seen = ", inspect(countHello)]
  end
  Process.sleep(DAC.random(3) * 1000)
  receiveMembership(neighbours, countHello + 1)
end

end  #module ------------
