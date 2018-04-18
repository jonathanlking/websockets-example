# WebSockets Example

Super simple demo of a Haskell WebSocket + HTTP server application with a
PureScript front end. It uses the [`websockets` library](https://github.com/jaspervdj/websockets)
and [`wai-app-static`](https://hackage.haskell.org/package/wai-app-static) to
host the front end. The front end is the WebSockets example from [`purescript-halogen`](https://github.com/slamdata/purescript-halogen/tree/master/examples/driver-websockets) (under Apache-2.0
 license).

Everything runs inside a Docker container, which can be built (*it takes quite a
long time*) using:

`docker build -t websockets-example .`

You can then run it using:

`docker run -p 80:8080 -p 9160:9160 websockets-example`

You can now visit the page in your browser! (You can run `docker-machine ip` to
get the ip address).
