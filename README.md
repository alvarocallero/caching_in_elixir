# Distributed Elixir app

This Elixir app is built using Phoenix with GraphQL to get and store data.
The GraphQL queries are cached using Redix and Poolboy.
We can start several nodes through LibCluster, and we can share state between the nodes through DeltaCRDT, as a cache.
