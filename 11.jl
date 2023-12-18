line_to_vec(line) = collect(line) .== '#'
offset((x, y), x_off, y_off) = x + x_off[x], y + y_off[y]

open(ARGS[1]) do file
    universe = hcat(line_to_vec.(eachline(file))...)
    m, n = size(universe)
    row_offsets = (1:m) - cumsum(vec(any(universe, dims=1)))
    col_offsets = (1:n) - cumsum(vec(any(universe, dims=2)))
    galaxies = offset.(Tuple.(findall(universe)), Ref(row_offsets), Ref(col_offsets))

    # println("Part 1 : $part1")
    # println("Part 2 : $part2")
end