defmodule Flooding do

def bind(peer_ids, peer, neighbours) do
    peer_id = Enum.at(peer_ids, peer)

    neighbour_ids = Enum.map(neighbours, fn(i) ->
                             Enum.at(peer_ids, i)
                             end)
    send peer_id, {:neighbours, neighbour_ids}
end

def start() do
  IO.puts ["Starting Flooding at", DNS.my_ip_addr()]
  peer_ids = Enum.map(0..9, fn(_) ->
           spawn(Peer, :start, []) end)
  IO.puts ["Process indices ", inspect(Enum.zip(0..9, peer_ids))]

  # Some random graph of peers
  bind(peer_ids, 0, [1, 6])
  bind(peer_ids, 1, [0, 2, 3])
  bind(peer_ids, 2, [1, 3, 4])
  bind(peer_ids, 3, [1, 2, 5])
  bind(peer_ids, 4, [2])
  bind(peer_ids, 5, [3])
  bind(peer_ids, 6, [0, 7])
  bind(peer_ids, 7, [6, 8, 9])
  bind(peer_ids, 8, [7, 9])
  bind(peer_ids, 9, [7, 8])

  # Pipeline of peers
  # bind(peer_ids, 0, [1])
  # bind(peer_ids, 1, [0, 2])
  # bind(peer_ids, 2, [1, 3])
  # bind(peer_ids, 3, [2, 4])
  # bind(peer_ids, 4, [3, 5])
  # bind(peer_ids, 5, [4, 6])
  # bind(peer_ids, 6, [5, 7])
  # bind(peer_ids, 7, [6, 8])
  # bind(peer_ids, 8, [7, 9])
  # bind(peer_ids, 9, [8])

   send Enum.at(peer_ids, 0), {:hello, self()}
end

def main() do
    start()
    :timer.sleep(100000)
end

end
