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
        {:iamyourchild, _ } ->
            # Do nothing
            registerNeighbours(neighbours, children)
        {:myValue, _} ->
            registerNeighbours(neighbours, children)
        {:hello, parent} ->
            IO.puts ["Node ", inspect(self()), " has parent = ", inspect(parent)]
            value = 1
            send parent, {:iamyourchild, self()}
            Enum.map(neighbours, fn(n) ->
                                 send n, {:hello, self()} end)
            receiveMembership(parent, neighbours, children, 1, value)
    end
end

defp receiveMembership(parent, neighbours, children, countHello, myValue) do
  if MapSet.size(children) == 0 do
     send parent, {:myValue, myValue}
  end
  receive do
      {:myValue, val} ->
        IO.puts ["Peer ", inspect(self()), " value", inspect(myValue + val)]
        receiveMembership(parent, neighbours, children, countHello, myValue + val)
      {:iamyourchild, child} ->
        receiveMembership(parent, neighbours, MapSet.put(children, child), countHello, myValue)
      {:hello, _} ->
         IO.puts ["Peer ", inspect(self()), " Parent ", inspect(parent), " Messages seen = ", inspect(countHello + 1)]
         receiveMembership(parent, neighbours, children, countHello + 1, myValue)
  after
      1000 -> IO.puts ["Peer ", inspect(self()), " Children = ", inspect(children)]
  end
  if MapSet.size(children) == 0 do
    # Leaf node
    send parent, {:childValue, myValue}
  end
  Process.sleep(DAC.random(3) * 1000)
  receiveMembership(parent, neighbours, children, countHello, myValue)
end

end  #module ------------
