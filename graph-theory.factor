USING: ;

IN: graph-theory

MIXIN: graph

GENERIC: weight ( graph src dst -- weight ) flushable
GENERIC: neighbors ( graph vertex  -- neighbors ) flushable
