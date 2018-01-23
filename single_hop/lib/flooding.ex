defmodule Flooding do

def start() do
  IO.puts ["Starting Flooding at", DNS.my_ip_addr()]
  peer_ids = Enum.map(1..10, fn(_) ->
           spawn(Peer, :start, []) end)
 send Enum.at(peer_ids, 0), {:hello, peer_ids}
end

def main() do
    start()
    :timer.sleep(100000)
end

end
