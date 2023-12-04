parse_numbers(numbers) = parse.(Int, split(numbers))
parse_card(card) = split(chopprefix(card, r"Card\s+\d+:"), "|") .|> parse_numbers
score(n::Int) = iszero(n) ? 0 : 2^(n - 1)
score(card::String) = ∩(parse_card(card)...) |> length |> score

open(ARGS[1]) do file
    cards = readlines(file)
    part1 = sum(score, cards)

    println("Part one : ", part1)
    # println("Part two : ", part2)
end