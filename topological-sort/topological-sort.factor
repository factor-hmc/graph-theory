USING: arrays graph-theory graph-theory.directed hash-sets io kernel locals math sequences sets ;
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
    ! graph rev-graph :> rev
    ! list of parentless vertices
    graph rev-graph get-start-nodes :> S
    ! L: sorted list of vertices (starts empty)
    { } :> L 

    S .
    S length .
    ! while S is not empty
    S [ length 0 > ] [
        ! put 1st element of S into L
        S first :> n
        L { n } append :> L

        ! for each of n's neighbors
        ! n graph get-neighbors [

        ! ] each

        ! END OF LOOP: remove 1st element from S
        rest S ! :> S
        ! swap 1 -
    ] while

    drop
    L
    ;

! how do while loops work i'm dying
: make-4 ( -- x )
   ! 0 :> i
    0 [ dup 4 < ]
    [ dup . 1 + ] while ;
