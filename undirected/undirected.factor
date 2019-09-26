USING: accessors assocs graph-theory graph-theory.directed
hash-sets hashtables kernel locals random sequences sets vectors ;
IN: graph-theory.undirected

! Define the properties of a undirected graph
!  edges is a hashtable of hashtables of costs
TUPLE: undirected-graph < directed-graph ;

! Constructors
: <undirected-graph> ( -- graph ) H{ } clone undirected-graph boa ;
: >undirected-graph ( assoc -- graph ) >hashtable undirected-graph boa ;

M:: undirected-graph add-edge ( src dst weight graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! First make sure that both the src and dst verticies are in the graph
    src graph add-vertex
    dst graph add-vertex
    ! Get the hashtable of the vertices connected to src vertex
    src edges at :> dsts
    ! Add the new weight to the hashtable
    weight dst dsts set-at
    ! Now add it in the other direction
    ! Get the hashtable of the vertices connected to dst vertex
    dst edges at :> srcs
    ! Add the new weight to the hashtable
    weight src srcs set-at ;

M:: undirected-graph remove-edge ( src dst graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Get the vertices connected to the source vertex
    src edges at :> dsts
    ! Remove the edge
    dst dsts delete-at
    ! Now repeat for dst->src
    dst edges at :> srcs
    src srcs delete-at
    ;
