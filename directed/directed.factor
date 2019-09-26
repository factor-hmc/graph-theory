USING: accessors assocs graph-theory hash-sets hashtables kernel
locals sequences sets vectors ;

IN: graph-theory.directed

! Define the properties of a directed graph
!  edges is a hashtable of hashtables of costs
TUPLE: directed-graph { edges hashtable } ;

! Constructors
: <directed-graph> ( -- graph ) H{ } clone directed-graph boa ;
: >directed-graph ( assoc -- graph ) >hashtable directed-graph boa ;

! Create implementations of the methods of the graph class
M:: directed-graph get-weight ( src dst graph -- weight )
    ! Get the edges
    graph edges>>
    ! Get the vertices connected to the src vertex
    src swap at
    ! Get the weight for the given dst vertex
    dst swap at ;

M: directed-graph get-neighbors ( vertex graph -- neighbors )
    ! Get the edges
    edges>>
    ! Get the vertices connected to the given vertex
    at
    ! Get all neighbors
    keys ;

M: directed-graph get-vertices ( graph -- vertices )
    edges>> keys ;

M:: directed-graph has-edge ( src dst graph -- ? )
    ! Does the graph have the source edge?
    src graph edges>> at*
    ! If so, is it connected to the destination edge?
    [ [ dst ] dip key? ] when ;

M:: directed-graph add-edge ( src dst weight graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! First make sure that both the src and dst verticies are in the graph
    src graph add-vertex
    dst graph add-vertex
    ! Get the hashtable of the vertices connected to src vertex
    src edges at :> dsts
    ! Add the new weight to the hashtable
    weight dst dsts set-at ;

M:: directed-graph remove-edge ( src dst graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Get the vertices connected to the source vertex
    src edges at :> dsts
    ! Remove the edge
    dst dsts delete-at ;


M:: directed-graph add-vertex ( vertex graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Test whether or not the vertex is a source vertex in the graph
    vertex edges key?
    ! If not, add it as a source vertex
    [ H{ } clone vertex edges set-at ] unless ;


M:: directed-graph remove-vertex ( vertex graph -- )
    ! Delete the vertex from the hashset
    vertex graph edges>> delete-at
    ! Get the list of vertices
    graph get-vertices
    ! Iterate through all other source edges and delete the vertex if it is
    ! a destination
    [ :> src
    ! If the edge exists
    src vertex graph has-edge
    ! Remove the edge
    [ src vertex graph remove-edge ] when ]
    each ;

M:: directed-graph connected-components ( graph -- ccs )
    H{ } clone :> ccs
    ! UNIMPLEMENTED
    ccs ;

M:: directed-graph reachables ( vertex graph -- vertices )
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

M: directed-graph connected? ( graph -- ? )
    connected-components length 1 = ;

INSTANCE: directed-graph graph
