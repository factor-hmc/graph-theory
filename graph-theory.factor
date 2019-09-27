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

:: reachables ( vertex graph -- vertices )
    HS{ } clone   :> seen
    ! if the vertex is in the graph
    vertex graph get-vertices in?
    [
        ! the frontier starts with one vertex
        vertex 1vector
        ! iterate until the frontier is empty
        [ dup empty? ]
        ! bind the head of the list to 'vert', keeping the tail on the stack
        [ unclip :> vert
          ! if the vertex hasn't been visited yet
          vert seen in? not
          [
              ! add it to the set of visited vertices
              vert seen adjoin
              ! add its neighbors to the frontier
              vert graph get-neighbors append
          ] when
        ] until
        ! remove the (now empty) frontier from the stack
        drop
    ] when
    seen ;

: connected? ( graph -- ? )
    connected-components length 1 = ;
