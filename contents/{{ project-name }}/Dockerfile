FROM p6m.jfrog.io/p6m-archetypes-docker/applications/p6m-router:latest
COPY config/ .

EXPOSE 8080/tcp
EXPOSE 8081/tcp

ENTRYPOINT ["/usr/local/bin/p6m-router", "-c", "router.yaml", "-s", "supergraph.graphql"]

