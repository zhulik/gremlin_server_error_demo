# gremlin_server_error_demo

A simple script that reproduces https://issues.apache.org/jira/browse/TINKERPOP-1923

# Requirements
- docker-compose

## How to run

- `docker-compose up -d gremlin_server` to start the server

- `docker-compose run demo` to break it. On my machine it takes about 5 seconds to start erroring.
