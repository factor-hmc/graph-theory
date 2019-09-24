USING: ;

IN: graph-theory

MIXIN: graph

! Given a source and destination verticies, get the corresponding weight
GENERIC: get-weight ( src dst graph -- weight ) flushable

! Get all edges reachable in one step from vertex
GENERIC: get-neighbors ( vertex graph -- neighbors ) flushable

! Get an array of all vertices
GENERIC: get-vertices ( graph -- vertices ) flushable

! Add a vertex if it does not already exist
GENERIC: add-vertex ( vertex graph -- )

! Add an edge if it does not already exist
GENERIC: add-edge ( src dst weight graph -- )
