line_to_vec(line) = collect(line) .== '#'
offset((x, y), x_off, y_off; multiplier=1) = x + multiplier * x_off[x], y + multiplier * y_off[y]
manhattan(x, y) = sum(abs, x .- y)
sum_dist(galaxies) = sum(manhattan(x, y) for x in galaxies for y in galaxies) ÷ 2

function sum_expand(base_galaxies, row_offsets, col_offsets, multiplier)
    expanded = offset.(base_galaxies, Ref(col_offsets), Ref(row_offsets), multiplier=multiplier)
    return sum_dist(expanded)
end

open(ARGS[1]) do file
    universe = hcat(line_to_vec.(eachline(file))...)
    m, n = size(universe)
    row_offsets = (1:m) - cumsum(vec(any(universe, dims=1)))
    col_offsets = (1:n) - cumsum(vec(any(universe, dims=2)))
    base_galaxies = Tuple.(findall(universe))
    part1 = sum_expand(base_galaxies, row_offsets, col_offsets, 1)
    part2 = sum_expand(base_galaxies, row_offsets, col_offsets, 10^6-1)
    println("Part 1 : $part1")
    println("Part 2 : $part2")
end