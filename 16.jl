struct Beam
    pos::Tuple{Int,Int}
    dir::Tuple{Int,Int}
end

function turn_split(b::Beam, c::Char)
    if c == '-' && b.dir[2] == 0
        return [Beam(b.pos, (0, 1)), Beam(b.pos, (0, -1))]
    elseif c == '|' && b.dir[1] == 0
        return [Beam(b.pos, (1, 0)), Beam(b.pos, (-1, 0))]
    elseif c == '/'
        return [Beam(b.pos, (-b.dir[2], -b.dir[1]))]
    elseif c == '\\'
        [Beam(b.pos, (b.dir[2], b.dir[1]))]
    else
        return [b]
    end
end

turn_split(b::Beam, field::AbstractMatrix{Char}) = turn_split(b, field[b.pos...])
advance(b::Beam) = Beam(b.pos .+ b.dir, b.dir)
is_inbounds(b::Beam, field::AbstractMatrix{Char}) = checkbounds(Bool, field, b.pos...)
function one_step(beam::Beam, field::AbstractMatrix{Char})
    new_beams = turn_split(beam, field)
    return filter(b -> is_inbounds(b, field), advance.(new_beams))
end

function mem_simulate!(mem, beam::Beam, field::AbstractMatrix{Char})
    function mem2_simulate!(mem, cur_path, beam, field)
        get!(mem, beam) do
            idx = findfirst(isequal(beam), cur_path)
            if !isnothing(idx)
                return Set(b.pos for b in cur_path[idx:end])
            end
            all_visited = (mem2_simulate!(mem, [cur_path; beam], new_beam, field) for new_beam in one_step(beam, field))
            return union(Set([beam.pos]), all_visited...)
        end
    end
    mem2_simulate!(mem, [], beam, field)
end

function select_dim(field, dir, dim)
    n = size(field, dim)
    if dir[dim] == 0
        return 1:n
    else
        return [dir[dim] == 1 ? 1 : n]
    end
end
select_side(field, dir) = Iterators.product(select_dim(field, dir, 1), select_dim(field, dir, 2))
starting_beams(field) = [Beam(pos, dir) for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] for pos in select_side(field, dir)]

open(ARGS[1]) do file
    field = vcat(reshape.(collect.(eachline(file)), 1, :)...)
    mem = Dict{Beam,Set{Tuple{Int,Int}}}()
    start_beams = starting_beams(field)
    foreach(b -> mem_simulate!(mem, b, field), start_beams)
    println(map(b -> length(mem[b]), start_beams))
    part1 = length(mem[Beam((1, 1), (0, 1))])
    part2 = maximum(b -> length(mem[b]), start_beams)
    println("Part 1 : $part1")
    println("Part 2 : $part2")
end
