defmodule Peer do

def start() do
    IO.puts ["        Peer at ", DNS.my_ip_addr()]
    receive do
         {:neighbours, neighbour_ids} ->
            IO.puts ["Registering neighbours for node ", inspect(self()), ": ", inspect(neighbour_ids)]
            registerNeighbours(neighbour_ids, MapSet.new())
    end
end

defp registerNeighbours(neighbours, children) do
    receive do
        {:iamyourchild, _} ->
            # Do nothing
            registerNeighbours(neighbours, children)
        {:hello, parent} ->
            IO.puts ["Node ", inspect(self()), " has parent = ", inspect(parent)]
            send parent, {:iamyourchild, self()}
            Enum.map(neighbours, fn(n) ->
                                 send n, {:hello, self()} end)
            receiveMembership(parent, neighbours, children, 1)
    end
end

defp receiveMembership(parent, neighbours, children, countHello) do
  receive do
      {:iamyourchild, child} ->
        receiveMembership(parent, neighbours, MapSet.put(children, child), countHello)
      {:hello, _} ->
         IO.puts ["Peer ", inspect(self()), " Parent ", inspect(parent), " Messages seen = ", inspect(countHello + 1)]
         receiveMembership(parent, neighbours, children, countHello + 1)
  after
      1000 -> IO.puts ["Peer ", inspect(self()), " Children = ", inspect(children)]
  end
  Process.sleep(DAC.random(3) * 1000)
  receiveMembership(parent, neighbours, children, countHello)
end

end  #module ------------
