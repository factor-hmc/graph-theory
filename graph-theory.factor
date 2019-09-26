USING: hash-sets kernel locals random sequences sets vectors ;

IN: graph-theory

MIXIN: graph

! Given a source and destination verticies, get the corresponding weight
GENERIC: get-weight ( src dst graph -- weight ) flushable

! Get all edges reachable in one step from vertex
GENERIC: get-neighbors ( vertex graph -- neighbors ) flushable

! Get an array of all vertices
GENERIC: get-vertices ( graph -- vertices ) flushable

! Check if an edge with the given source and destination exists
GENERIC: has-edge ( src dst graph -- ? ) flushable

! Add an edge if it does not already exist
GENERIC: add-edge ( src dst weight graph -- )

! Remove an edge from the graph
GENERIC: remove-edge ( src dst graph -- )

! Add a vertex if it does not already exist
GENERIC: add-vertex ( vertex graph -- )

! Remove a vertex, and all edges connected to it
GENERIC: remove-vertex ( vertex graph -- )

! Get the connected components of the graph
GENERIC: connected-components ( graph -- ccs ) flushable

! Vertices reachable from 'vertex'
GENERIC: reachables? ( vertex graph -- vertices )

