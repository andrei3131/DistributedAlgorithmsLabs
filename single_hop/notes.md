Question. The algorithm you've written is once-only, you can't broadcast a second message to all peers. How would you fix this? You don't need to implement this.

No peer will listen to subsequent messages. Have a message list for each peer and
update it as new hello messages are sent. Can have a cache that can be cleared
and the subsequent broadcast messages will be taken into consideration.

Question. How can you reduce the number of messages a peer sends? Again, you don't need to
implement this.

The first node sends the broadcast packet to all other nodes only.
