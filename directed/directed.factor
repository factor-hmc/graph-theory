USING: accessors assocs graph-theory hash-sets hashtables kernel
locals sequences sets vectors ;

IN: graph-theory.directed

! Define the properties of a directed graph
!  edges is a hashtable of hashtables of costs
TUPLE: directed-graph { edges hashtable } ;

! Constructors
: <directed-graph> ( -- graph ) H{ } clone directed-graph boa ;
:: >directed-graph ( edges -- graph )
    H{ } clone :> g
    edges
    [ [ third ] [ second ] [ first ] tri :> src :> dst :> wt
      src g at [ ] [ H{ } clone src g set-at src g at ] if*
      [ wt dst ] dip set-at
    ] each
    g directed-graph boa
    ; inline

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

M:: directed-graph add-vertex ( vertex graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Test whether or not the vertex is a source vertex in the graph
    vertex edges key?
    ! If not, add it as a source vertex
    [ H{ } clone vertex edges set-at ] unless ;

INSTANCE: directed-graph graph
