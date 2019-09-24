USING: ;

IN: graph-theory

MIXIN: graph

GENERIC: cost ( src dst graph -- cost ) flushable
GENERIC: neighbors ( vertex graph -- neighbors ) flushable
