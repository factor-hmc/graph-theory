USING: accessors assocs graph-theory hashtables kernel locals ;

IN: graph-theory.directed

! Define the properties of a directed graph
!  edges is a hashtable of hashtables of costs
TUPLE: directed-graph { edges hashtable } ;

! Constructors
: <directed-graph> ( -- graph ) H{ } clone directed-graph boa ;

! Create implementations of the methods of the graph class
M:: directed-graph get-weight ( src dst graph -- weight )
    ! Get the edges
    graph edges>>
    ! Get the vertices connected to the src vertex
    src swap at
    ! Get the weight for the given dst vertex
    dst swap at ;

M:: directed-graph get-neighbors ( vertex graph -- neighbors )
    ! Get the edges
    graph edges>>
    ! Get the verticies connected to the given vertex
    vertex swap at
    ! Get all neighbors
    keys ;

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

M:: directed-graph add-vertex ( vertex graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Test whether or not the vertex is a source vertex in the graph
    vertex edges at* nip
    ! If not, add it as a source vertex
    [ H{ } clone vertex edges set-at ] unless ;

INSTANCE: directed-graph graph
