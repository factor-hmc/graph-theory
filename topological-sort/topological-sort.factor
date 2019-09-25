USING: arrays graph-theory hash-sets io kernel locals sets sequences ;
IN: graph-theory

! graph contains "edges" hashtable with:
!     key: source
!     value: hashtable with:
!         key: destination
!         value: cost


! returns an array of nodes with no incoming edges
:: get-start-nodes ( graph -- {v1,..vm} )
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
    start-nodes >array ; ! switch back to array to return

! topological sort - returns list of vertices in sorted order
! returns empty list if the graph has cycles
: topological-sort ( graph -- {v1,...,vn} ) [let
    ! S: nodes with no incoming edges
    get-start-nodes :> S
    ! L: sorted list of vertices (starts empty)
    { } :> L 
    L
    ] ;
