USING: arrays graph-theory graph-theory.directed hash-sets 
io kernel locals math sequences sets vectors ;
IN: graph-theory

! returns an array of nodes in graph with no neighbors 
! (pas rev-graph to get array of nodes w no incoming edges)
:: get-start-nodes ( graph -- seq )
    ! list that we will put the start nodes into
    { }
    ! for each vertex v
    graph get-vertices [
        :> v
        ! if v has no neighbors, append it to out
        v graph get-neighbors empty?
        [ { v } append ] when
    ] each ;

! creates a graph identical to graph but with the directions flipped
:: rev-graph ( graph -- graph' )
    graph get-vertices :> vertices
    <directed-graph> :> new

    ! for each vertex
    vertices [
        dup :> v
        ! for each neighbor
        graph get-neighbors [
            ! put edge from neighbor to v (setting weight to 1 bc idc)
            v 1 new add-edge 
        ] each
    ] each

    ! return the new graph
    new ;

! topological sort - returns vector of vertices in sorted order
! assumes a directed, acyclic graph
:: topological-sort ( graph -- {v1,...,vn} )
    ! reversed graph (can see number of inwards edges)
    graph rev-graph :> rev

    ! L: vector of sorted vertices (starts empty)
    V{ } clone
    ! S vector of parentless vertices
    graph rev-graph get-start-nodes >vector

    ! while S is not empty
    [ dup length 0 > ] [
        ! put 1st element of S into L (need to put L on top of stack)
        dup first :> n
        swap { n } append ! L on top of stack

        swap ! S on top of stack again
        ! for each of n's neighbors m
        n graph get-neighbors [
            :> m
            ! remove the edge from m -> n in rev
            m n rev remove-edge
            ! if m has no neighbors in rev: add to S
            m rev get-neighbors empty?
            [ { m } append ] when
        ] each
        ! remove n from S for next loop
        rest
    ] while 
    ! get rid of S, leaving just L
    drop ; 

