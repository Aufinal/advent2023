parse_pattern(pattern) = hcat(collect.(split(pattern))...)
bounds(pattern, mirror, dim) = min(size(pattern, dim) - mirror, mirror)
is_sym_horiz(pattern, mirror) =
    open(ARGS[1]) do file
        patterns = parse_pattern.(split(read(file, String), "\n\n"))
        # println("Part 1 : $part1")
        # println("Part 2 : $part2")
    end