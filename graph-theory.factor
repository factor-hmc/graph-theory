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

! Add a vertex if it does not already exist
GENERIC: add-vertex ( vertex graph -- )

! Add an edge if it does not already exist
GENERIC: add-edge ( src dst weight graph -- )

:: reachables ( vertex graph -- hash-set )
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

! this should be only defined for undirected graphs
:: connected-components ( graph -- ccs )
    ! ccs = connected components
    V{ } clone :> ccs
    ! start with a set of all vertices
    graph get-vertices >hash-set
    ! until this set is null
    [ dup null? ]
    [
      ! take an arbitrary element and find the reachable vertices
      ! this forms a connected component (cc)
      dup random graph reachables :> cc
      ! add cc to ccs
      cc ccs push
      ! remove all of cc from the set of vertices
      cc diff
    ] until
    ! remove the now empty set
    drop
    ! return the connected components
    ccs ;

! alternate implementation for undirected graphs:
! :: connected? ( graph -- ? )
!     graph get-vertices :> verts
!     verts length       :> size
!     verts [ graph reachables cardinality size = ] all?
!
! although perhaps the better thing to do is implement an algorithm for finding
! strongly connected components for directed graphs and then using the same
! definition for connected? used by undirected graphs.
: connected? ( graph -- ? )
    connected-components length 1 = ;
