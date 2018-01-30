defmodule Peer do

def start() do
    IO.puts ["        Peer at ", DNS.my_ip_addr()]
    receive do
         {:neighbours, neighbour_ids} ->
            IO.puts ["Registering neighbours for node ", inspect(self()), ": ", inspect(neighbour_ids)]
            registerNeighbours(neighbour_ids)
    end
end

defp registerNeighbours(neighbours) do
    receive do
        {:hello, parent} ->
            IO.puts ["Node ", inspect(self()), " has parent = ", inspect(parent)]
            Enum.map(neighbours, fn(n) ->
                                 send n, {:hello, self()} end)
            receiveMembership(parent, neighbours, 1)
    end
end

defp receiveMembership(parent, neighbours, countHello) do
  receive do
      {:hello, _} ->
         IO.puts ["Peer ", inspect(self()), " Parent ", inspect(parent), " Messages seen = ", inspect(countHello + 1)]
         receiveMembership(parent, neighbours, countHello + 1)
  after
      1000 -> IO.puts ["Peer ", inspect(self()), " Messages seen = ", inspect(countHello)]
  end
  Process.sleep(DAC.random(3) * 1000)
  receiveMembership(parent, neighbours, countHello)
end

end  #module ------------
