## v1.0.2

- Fix repository from gitee to gitcode in oh-packaage.json5

## v1.0.2-rc.0

- Fixed the issue where the dependent c++ static library caused conflicts with the dynamic libraries of other modules, leading to program crashes

## v1.0.1

- Optimized the memory problem in the emit message processing process.
- Added fixed events "ping_pong" and "disconnect" to listen for heartbeat and disconnection events.
- Added an interface "get_current_state" to get the current state.
- Simple packaging of demo to match new features and interfaces.
- Modified the readme file to add descriptions of new interfaces and features.

## v1.0.1-rc.0

- Fixed the issue of duplicate emit messages.

## v1.0.0

The following functions are supported:

- Only https connections are supported.

- Support subscribing/sending custom event messages.

- Supports setting the request header.

- Supports setting request parameters.

- Supports socketio connection/disconnection listening.

- Supports active disconnection of socketio.
