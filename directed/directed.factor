USING: hashtables ;

IN: graph-theory.directed

! Define the properties of a directed graph
! verticies is an array of vertices and edges is a hashtable of hashtables of costs
TUPLE: directed-graph { vertices array } { edges hashtable } ;

! Constructors
: <directed-graph> ( n -- graph ) 0 <array> H{ } clone directed-graph boa ; inline
: >directed-graph ( assoc -- graph ) [ keys ] [ >hashtable ] bi directed-graph boa ;

! Create implementations of the methods of the graph class
M: directed-graph cost get-cost ;
M: directed-graph neighbors get-neighbors ;

<PRIVATE

! Helper functions to actually implement the methods of the graph class
:: get-cost ( src dst directed -- cost )
    edges>> src at
    dst at ;

:: get-neighbors ( vertex directed -- neighbors )
    edges>> vertex at
    keys ;

PRIVATE>

INSTANCE: directed-weighted-graph graph