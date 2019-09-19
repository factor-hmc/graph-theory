USING: list assocs hashtables

IN: graphs

TUPLE: graph
{ vertices array }
{ edges hashtable } ;

: <graph> ( n -- graph ) 0 <array> H{ } clone graph boa ; inline

: >graph ( assoc -- graph ) [ keys ] [ >hashtable ] bi graph boa ;

:: connected? ( graph -- ? )
  graph vertices>> :> verts
  graph edges      :> edges
  1 <hash-set>     :> seen
  verts empty? [ t ]
    [
      verts first >list
      [ dup empty? ] 
      [
        uncons swap dup seen in? not
        [
          dup seen adjoin
          edges at append
        ] when
      ] until
      drop seen cardinality verts length =
    ] if ;