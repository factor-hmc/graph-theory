USING: arrays graph-theory graph-theory.directed hash-sets io kernel locals math sequences sets ;
IN: graph-theory

! graph contains "edges" hashtable with:
!     key: source
!     value: hashtable with:
!         key: destination
!         value: cost


! returns an array of nodes with no incoming edges
:: get-start-nodes-old ( graph -- {v1,..vm} )
    ! start w all of the vertices
    graph get-vertices >hash-set :> start-nodes ! hashset for diff ease
    graph get-vertices :> vertices ! all vertices stored in this array

    ! for each vertex
    vertices [
        ! get all the neighbors for that vertex
        graph get-neighbors >hash-set
        ! remove any of those neighbors from start-nodes
        start-nodes swap diff! :> start-nodes
    ] each 
    start-nodes members ; ! switch back to array to return

! returns an array of nodes in graph with no neighbors 
! (pas rev-graph to get array of nodes w no incoming edges)
:: get-start-nodes ( graph -- seq )
    graph get-vertices :> vertices
    { } :> out

    ! for each vertex v
    vertices [
        dup :> v
        ! if v has no neighbors, append it to out
        v get-neighbors empty?
        [ out { v } append :> out ] [ ] if
    ] each

    out ;

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
    ! L: sorted list of vertices (starts empty)
    { } :> L 

    L
    ;

! how do while loops work i'm dying
:: make-4 ( -- x )
   ! 0 :> i

    0 [ dup 4 < ]
    [ 1 + ] while
    
;
