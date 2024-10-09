# {{ org-venture-title }} GraphQL Federated Gateway

The Graphql Federated Gateway leverages a modified Apollo Federated Gateway Docker image to streamline some of the
configuration.

## Service Setup
1. Update your `registry.yaml` to replace `default-domain-gateway` with the name of your service.
    1. Update the `routing_url` to match domain gateway's the service name in kubernetes
        1. This is generally `http://{service-name}.{service-name}:8080/graphql`
    2. Update the `automation` section to match your organization and repository name.
    3. Update the `file` to match the name of your subgraph file.
2. [Optional] Enable Auth0 JWT authorization
   1. Uncomment the Auth0 section in the `config/router.yaml` file
   2. Fill in your Auth0 endpoint

## Supergraph Generation

### Pipeline

The Supergraph leveraged by the gateway is created & maintained through automation, fill out
the [`registry.yaml`](./registry.yaml) file to make sure all of your subgraphs are included in the composition.

```yaml
federation_version: 2                       # Apollo Graphql Federation version (Used directly in the config) 
subgraphs:                                  # Map of the subgraphs to be used in the composition 
  default-domain-gateway:                   # Repository name for service
    routing_url: http://default-domain-gateway.domain-gateway:8080/graphql # Kubernetes Service address for deployed service
    automation:
      org: default                          # Github organization name for 'domain-gateway' repository 
      branch: main                          # Branch to pull from
      file: default-domain-gateway.graphql  # File name / path for subgraph
```

### Manually

1. Start relevant Graphql service (domain gateway) and
   use [rover's introspect command](https://www.apollographql.com/docs/rover/commands/subgraphs#subgraph-introspect)
   to create the subgraph file.
  1. `rover subgraph introspect http://localhost:[LOCAL_PORT]/graphql/ > your-domain-gateway.graphql`
  2. Repeat for each subgraph in the composition. If there are services that utilize the same port do not worry, you
     can generate the subgraphs one at a time.
2. Create your supergraph configuration file (`supergraph.yaml`).
  1. Based on the `default-domain-gateway` above we'd have the following. _This is file is created during the
     pipeline for the compose command as well, but is not committed back to the repository to prevent confusion._
     ```yaml
     federation_version: 2
     subgraphs:
       default-domain-gateway:
           routing_url: http://default-domain-gateway.domain-gateway:8080/graphql
           schema:
             file: ./default-domain-gateway.graphql
     ```
3. Run [rover's compose command](https://www.apollographql.com/docs/rover/commands/supergraphs#supergraph-compose)
  1. `rover supergraph compose --elv2-license accept --config ./supergraph.yaml --output supergraph.graphql`
