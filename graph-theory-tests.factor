USING: graph-theory graph-theory.directed tools.test locals kernel ;

! empty constructor tests
{ { } } [ <directed-graph> get-vertices ] unit-test
{ { } } [ { } >directed-graph get-vertices ] unit-test
{ { } } [ DG{ } get-vertices ] unit-test

! empty constructor equivalence tests
{ t } [ <directed-graph> { } >directed-graph = ] unit-test
{ t } [ <directed-graph> DG{ } = ] unit-test

! -> syntax tests
{ { "src" "dst" 7 } } [ "src" -> "dst" 7 ] unit-test

{ { "x" "y" 3 }
  { "z" "w" 4 }
}
[ "x" -> "y" 3
  "z" -> "w" 4
] unit-test

{ t } [ <directed-graph> DG{ } = ] unit-test

{ { "x" } } [ "x" <directed-graph> [ add-vertex ] keep get-vertices ] unit-test

{ { "x" "y" "z" } }
[ DG{ "x" -> "y" 3
      "y" -> "z" 4
  }
  get-vertices
] unit-test
