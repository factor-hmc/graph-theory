USING: arrays graph-theory graph-theory.directed hash-sets 
io kernel locals math sequences sets vectors ;
IN: graph-theory

! graph contains "edges" hashtable with:
!     key: source
!     value: hashtable with:
!         key: destination
!         value: cost

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

    new ;

! topological sort - returns list of vertices in sorted order
! returns empty list if the graph has cycles
:: topological-sort ( graph -- {v1,...,vn} )
    ! reversed graph (can see number of inwards edges)
    graph rev-graph :> rev
    ! vector of parentless vertices
    graph rev-graph get-start-nodes >vector :> S
    ! L: vector of sorted vertices (starts empty)
    V{ } clone

    ! while S is not empty
    S [ dup length 0 > ] [
        ! put 1st element of S into L (need to put L on top of stack)
        S first :> n
        swap { n } append ! L on top of stack

        ! for each of n's neighbors m
        n graph get-neighbors [
            :> m
            ! remove the edge from m -> n in rev
            m n rev remove-edge
            ! if m has no neighbors in rev: add to S
            m rev get-neighbors empty?
            [ { m } S append :> S ] when
            ! m . ! just printing them for now :o
        ] each
        ! drop
        ! END OF LOOP: remove 1st element from S
        rest S :> S
    ] while

    drop ; ! get rid of S, leaving just L

! how do while loops work i'm dying
: make-4 ( -- x )
   ! 0 :> i
    0 [ dup 4 < ]
    [ 1 + ] while ;
