function parse_line(line)
    node, left, right = String.(match(r"(\w+) = \((\w+), (\w+)\)", line))
    return node => (left, right)
end

next(tree, pos, c) = pos = c == 'L' ? tree[pos][1] : tree[pos][2]

function tree_find(tree, path, start, condition)
    cur_pos = start
    n_steps = 0
    for c in Iterators.cycle(path)
        n_steps += 1
        cur_pos .= next.(Ref(tree), cur_pos, c)
        all(condition, cur_pos) && break
    end

    return n_steps
end

open(ARGS[1]) do file
    path = readuntil(file, "\n\n")
    tree = Dict(parse_line.(eachline(file)))

    part1 = tree_find(tree, path, ["AAA"], isequal("ZZZ"))
    println("Part one : ", part1)

    start_nodes = filter(endswith('A'), collect(keys(tree)))
    part2 = tree_find(tree, path, start_nodes, endswith('Z'))
    println("Part two : ", part2)
end