USING: accessors arrays assocs graph-theory hashtables kernel locals ;

IN: graph-theory.directed

<PRIVATE

! Helper functions to actually implement the methods of the graph class
:: get-weight ( src dst directed -- weight )
    edges>> src at
    dst at ;

:: get-neighbors ( vertex directed -- neighbors )
    edges>> vertex at
    keys ;

PRIVATE>

! Define the properties of a directed graph
! verticies is an array of vertices and edges is a hashtable of hashtables of costs
TUPLE: directed-graph { vertices array } { edges hashtable } ;

! Constructors
: <directed-graph> ( -- graph ) 0 <array> H{ } clone directed-graph boa ; inline
: >directed-graph ( assoc -- graph ) [ keys ] [ >hashtable ] bi directed-graph boa ;

! Create implementations of the methods of the graph class
M: directed-graph weight get-weight ;
M: directed-graph neighbors get-neighbors ;

INSTANCE: directed-graph graph