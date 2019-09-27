USING: accessors assocs graph-theory hash-sets hashtables kernel
locals math math.order parser sequences sets vectors ;

IN: graph-theory.directed

! Define the properties of a directed graph
!  edges is a hashtable of hashtables of costs
TUPLE: directed-graph { edges hashtable } ;

! Constructors
: <directed-graph> ( -- graph ) H{ } clone directed-graph boa ;

! takes in a list of edges and outputs a weighted digraph; each edge
! is of the format `{ src dst wt }`
: >directed-graph ( edges -- graph )
    [ <directed-graph> dup ] dip add-edges
    ; inline

! defines syntax for digraphs, via `DG{ ...edges }`
SYNTAX: DG{ \ } [ >directed-graph ] parse-literal ;

! Create implementations of the methods of the graph class
M:: directed-graph get-weight ( src dst graph -- weight )
    ! Get the edges
    graph edges>>
    ! Get the vertices connected to the src vertex
    src swap at
    ! Get the weight for the given dst vertex
    dst swap at ;

M: directed-graph get-neighbors ( vertex graph -- neighbors )
    ! Get the edges
    edges>>
    ! Get the vertices connected to the given vertex
    at
    ! Get all neighbors
    keys ;

M: directed-graph get-vertices ( graph -- vertices )
    edges>> keys ;

M:: directed-graph has-edge ( src dst graph -- ? )
    ! Does the graph have the source edge?
    src graph edges>> at*
    ! If so, is it connected to the destination edge?
    [ [ dst ] dip key? ] when ;

M:: directed-graph add-edge ( src dst weight graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! First make sure that both the src and dst vertices are in the graph
    src graph add-vertex
    dst graph add-vertex
    ! Get the hashtable of the vertices connected to src vertex
    src edges at :> dsts
    ! Add the new weight to the hashtable
    weight dst dsts set-at ;

M:: directed-graph remove-edge ( src dst graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Get the vertices connected to the source vertex
    src edges at :> dsts
    ! Remove the edge
    dst dsts delete-at ;


M:: directed-graph add-vertex ( vertex graph -- )
    ! Get the edges
    graph edges>> :> edges
    ! Test whether or not the vertex is a source vertex in the graph
    vertex edges key?
    ! If not, add it as a source vertex
    [ H{ } clone vertex edges set-at ] unless ;


M:: directed-graph remove-vertex ( vertex graph -- )
    ! Delete the vertex from the hashset
    vertex graph edges>> delete-at
    ! Get the list of vertices
    graph get-vertices
    ! Iterate through all other source edges and delete the vertex if it is
    ! a destination
    [ :> src
    ! If the edge exists
    src vertex graph has-edge
    ! Remove the edge
    [ src vertex graph remove-edge ] when ]
    each ;

<PRIVATE
:: strongconnect ( vertex ccs stack index lowlink onstack graph -- )
    ! if the vertex already has an index, we've seen it before - ignore it
    vertex index key? not
    [
        ! variable updates
        "i" index at :> i
        i vertex index set-at
        i vertex lowlink set-at
        ! update i for the next vertex
        i 1 + "i" index set-at
        vertex stack push
        t vertex onstack set-at
        ! for each neighbor
        vertex graph get-neighbors
        [
            ! store the neighbor in a local
            :> neighbor
            ! if the neighbor is also uninitialized (there is a redundant check
            ! here, since strongconnect also checks, we can move things around
            ! later...)
            neighbor index key? not
            ! then
            [
                ! recurse
                neighbor ccs stack index lowlink onstack graph strongconnect
                ! the minimum of its lowlink and its neighbor's _lowlink_
                vertex lowlink at neighbor lowlink at min :> m
                ! update the lowlink of 'vertex' to this value
                m vertex lowlink set-at
            ]
            ! else
            [
                ! when the neighbor is on the stack
                neighbor onstack at
                [
                    ! the minimum of its lowlink and its neighbor's _index_
                    vertex lowlink at neighbor index at min :> m
                    ! update the lowlink of 'vertex' to this value
                    m vertex lowlink set-at
                ] when
            ] if
        ] each
        ! if the vertex's lowlink is its own index (if it's a root of a scc)
        vertex lowlink at vertex index at =
        [
            ! make a new cc set
            HS{ } clone :> cc
            [
                ! pop 'v' from the stack
                stack pop :> v
                f v onstack set-at
                ! add 'v' to the cc
                v cc adjoin
                ! stop after we reach 'v'
                v vertex = not
            ] loop
            cc ccs push
        ] when
    ] when ;
PRIVATE>

! why does it work? i just spent a few hours reading another tarjan paper, give
! me a few more days... this is transliterated from wikipedia.
M:: directed-graph connected-components ( graph -- ccs )
    V{ } clone :> ccs
    V{ } clone :> stack
    ! maps a vertex to the order in which it was visited
    H{ } clone :> index
    ! the special "i" key represents the next index on the stack
    0 "i" index set-at
    ! maps a vertex to the smallest index of a node reachable from it
    H{ } clone :> lowlink
    ! is the vertex on the stack?
    H{ } clone :> onstack
    graph get-vertices [ ccs stack index lowlink onstack graph strongconnect ] each
    ccs ;

INSTANCE: directed-graph graph
