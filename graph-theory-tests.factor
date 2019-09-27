USING: graph-theory graph-theory.directed tools.test locals kernel hash-sets ;

! -> syntax tests
{ { "src" "dst" 7 } } [ "src" -> "dst" 7 ] unit-test

{ { "x" "y" 3 }
  { "z" "w" 4 }
}
[ "x" -> "y" 3
  "z" -> "w" 4
] unit-test

! empty constructor tests
{ { } } [ <directed-graph> get-vertices ] unit-test
{ { } } [ { } >directed-graph get-vertices ] unit-test
{ { } } [ DG{ } get-vertices ] unit-test

! empty constructor equivalence tests
{ t } [ <directed-graph> { } >directed-graph = ] unit-test
{ t } [ <directed-graph> DG{ } = ] unit-test

! no false equivalences
{ f } [ <directed-graph> { "x" -> "y" 1 } >directed-graph = ] unit-test
{ f } [ <directed-graph> DG{ "x" -> "y" 1 } = ] unit-test
{ f } [ { "x" -> "y" 2 } >directed-graph DG{ "x" -> "y" 1 } = ] unit-test

! constructor equivalences
{ t }
[ <directed-graph>
  [ [ "x" "y" 1 ] dip add-edge ] keep
  [ [ "y" "z" 2 ] dip add-edge ] keep
  [ [ "y" "w" 3 ] dip add-edge ] keep
  [ [ "z" "w" 4 ] dip add-edge ] keep
  [ [ "a" ] dip add-vertex ] keep
  DG{ "x" -> "y" 1
      "y" -> "z" 2
      "y" -> "w" 3
      "z" -> "w" 4
      "a"
  }
  =
] unit-test

{ t }
[ DG{ "x" -> "y" 1
      "y" -> "z" 2
      "y" -> "w" 3
      "z" -> "w" 4
      "a"
    }
  { { "x" "y" 1 }
    { "y" "z" 2 }
    { "y" "w" 3 }
    { "z" "w" 4 }
    "a"
  } >directed-graph
  =
] unit-test

! test order independence of constructors
{ t }
[ DG{ "x" -> "y" 1
      "y" -> "z" 2
      "a"
      "y" -> "w" 3
      "b"
      "z" -> "w" 4
    }
  DG{ "b"
      "y" -> "w" 3
      "a"
      "x" -> "y" 1
      "z" -> "w" 4
      "y" -> "z" 2
    }
  =
] unit-test

{ t }
[ <directed-graph>
  [ [ "x" "y" 1 ] dip add-edge ] keep
  [ [ "y" "z" 2 ] dip add-edge ] keep
  [ [ "y" "w" 3 ] dip add-edge ] keep
  [ [ "z" "w" 4 ] dip add-edge ] keep
  [ [ "a" ] dip add-vertex ] keep
  [ [ "b" ] dip add-vertex ] keep
  <directed-graph>
  [ [ "b" ] dip add-vertex ] keep
  [ [ "y" "z" 2 ] dip add-edge ] keep
  [ [ "a" ] dip add-vertex ] keep
  [ [ "x" "y" 1 ] dip add-edge ] keep
  [ [ "y" "w" 3 ] dip add-edge ] keep
  [ [ "z" "w" 4 ] dip add-edge ] keep
  =
] unit-test

! search tests
{ t t t t t t f f f f f f }
[ DG{ "x" -> "y" 1
      "y" -> "z" 2
      "y" -> "w" 3
      "z" -> "w" 4
      "b" -> "z" 5
      "a"
    }
  ! reachable
  [ "x" "x" reachable-bfs? ] keep
  [ "x" "y" reachable-bfs? ] keep
  [ "x" "z" reachable-bfs? ] keep
  [ "x" "w" reachable-bfs? ] keep
  [ "a" "a" reachable-bfs? ] keep
  [ "b" "w" reachable-bfs? ] keep
  ! unreachable
  [ "x" "a" reachable-bfs? ] keep
  [ "x" "b" reachable-bfs? ] keep
  [ "y" "x" reachable-bfs? ] keep
  [ "z" "x" reachable-bfs? ] keep
  [ "z" "b" reachable-bfs? ] keep
  [ "w" "x" reachable-bfs? ] keep
  drop
] unit-test

{ t t t t t t f f f f f f }
[ DG{ "x" -> "y" 1
      "y" -> "z" 2
      "y" -> "w" 3
      "z" -> "w" 4
      "b" -> "z" 5
      "a"
    }
  ! reachable
  [ "x" "x" reachable-dfs? ] keep
  [ "x" "y" reachable-dfs? ] keep
  [ "x" "z" reachable-dfs? ] keep
  [ "x" "w" reachable-dfs? ] keep
  [ "a" "a" reachable-dfs? ] keep
  [ "b" "w" reachable-dfs? ] keep
  ! unreachable
  [ "x" "a" reachable-dfs? ] keep
  [ "x" "b" reachable-dfs? ] keep
  [ "y" "x" reachable-dfs? ] keep
  [ "z" "x" reachable-dfs? ] keep
  [ "z" "b" reachable-dfs? ] keep
  [ "w" "x" reachable-dfs? ] keep
  drop
] unit-test
