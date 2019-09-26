USING: accessors assocs graph-theory graph-theory.directed hash-sets
hashtables kernel locals sequences sets vectors ;

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

M:: connected-components ( graph -- ccs )
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
