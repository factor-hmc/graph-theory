USING: hash-sets kernel locals random sequences sets vectors fry parser arrays dlists deques prettyprint io ;

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

! allows definition of edge via `src -> dst wt` (becomes { src dst wt })
SYNTAX: -> dup pop scan-object scan-number 3array suffix! ;

! Extends a graph by a list of edges and vertices.  Each item in
! verts/edges is interpreted as follows:
!
! - if it is an array, it is interpreted as an edge.  It must be of
!   the form { src dst wt } (using the arrow syntax, one could write
!     src -> dst wt
!   )
!
! - otherwise, it is interpreted as a vertex and added directly as a
!   vertex.
: extend-graph ( graph verts/edges -- )
    [ 2dup array?
      [ ! parse as edge: { src dst wt }
          [ [ first ] [ second ] [ third ] tri ] dip add-edge
      ]
      [ ! parse as vertex
          add-vertex
      ]
      if
    ]
    each drop
    ;

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

<PRIVATE

:: reachable-search? ( graph src dst push pop -- ? )
    HS{ src } clone :> seen
    DL{ src } clone :> frontier
    f :> found!
    src dst =
    [ t ]
    [ [ frontier deque-empty? found or ]
      [ frontier pop call( deque -- elt )
        graph get-neighbors
        [ dup seen in?
          [ drop ]
          [ dup dst =
            [ drop t found! ]
            [ [ seen adjoin ]
              [ frontier push call( elt deque -- ) ]
              bi
            ] if
          ] if
        ] each
      ] until
      found
    ] if
    ;

PRIVATE>

: reachable-bfs? ( graph src dst -- ? )
    [ push-back ] [ pop-front ] reachable-search?
    ;

: reachable-dfs? ( graph src dst -- ? )
    [ push-back ] [ pop-back ] reachable-search?
    ;
