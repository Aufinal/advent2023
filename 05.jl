const Map = Dict{UnitRange{Int},Int}
function get(m::Map, key::Int)
    for (source, dest) in m
        if key ∈ source
            return dest + key - source.start
        end
    end
    return key
end

function propagate(mv::Vector{Map}, key::Int)
    for m in mv
        key = get(m, key)
    end
    return key
end

function parse_map(m_str)
    m = Map()
    for line in split(m_str, "\n", keepempty=false)[2:end]
        (dest, source_start, source_len) = parse.(Int, split(line))
        m[source_start:source_start+source_len-1] = dest
    end
    return m
end

function parse_file(file_str)
    seed_str, map_strs... = split(file_str, "\n\n")
    seeds = parse.(Int, split(seed_str)[2:end])
    maps = parse_map.(map_strs)
    return seeds, maps
end

open(ARGS[1]) do file
    seeds, maps = parse_file(read(file, String))
    part1 = minimum(propagate(maps, seed) for seed in seeds)
    println(prod(length, maps))

    println("Part one : ", part1)
    # println("Part two : ", part2)
end
