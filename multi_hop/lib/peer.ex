defmodule Peer do

def start() do
    IO.puts ["        Peer at ", DNS.my_ip_addr()]
    receive do
    { :hello, neighbours} ->
        IO.puts ["Peer ", inspect(self()), " forwards first :hello to neighbours ", inspect(neighbours)]
        Enum.map(neighbours, fn(n) ->
                 send n, {:hello, neighbours} end)
        forwardMembership(neighbours, 1)
    end
end

defp forwardMembership(neighbours, countHello) do
  receive do
      {:hello, _} ->
          Process.sleep(DAC.random(3) * 1000)
          forwardMembership(neighbours, countHello + 1)
  after
      1000 -> IO.puts ["Peer ", inspect(self()), " Messages seen = ", inspect(countHello)]
  end
  Process.sleep(DAC.random(3) * 1000)
  forwardMembership(neighbours, countHello + 1)
end

end  #module ------------
