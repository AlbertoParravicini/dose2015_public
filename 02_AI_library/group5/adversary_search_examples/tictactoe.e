note
	description: "Summary description for {TICTACTOE}."
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	TICTACTOE

inherit
	ADVERSARY_SEARCH_PROBLEM[STRING,TICTACTOE_STATE]

create
	make

feature -- Initialisation

	make
		do

		end

feature -- State space

	initial_state: TICTACTOE_STATE

	get_successors (state: TICTACTOE_STATE): LIST[TICTACTOE_STATE]
		local
			i, j: INTEGER
			successors: LINKED_LIST[TICTACTOE_STATE]
			succ: TICTACTOE_STATE
		do
			create successors.make
			if not (state.has_cross_won or state.has_circle_won) then
			from
				i := 1
			until
				i>3
			loop
				from
					j := 1
				until
					j>3
				loop
					if state.board[i,j] = state.None then
						create succ.make_with_parent (state)
						if state.cross_turn then
							succ.board[i,j] := state.Cross
						else
							succ.board[i,j] := state.Circle
						end
						successors.extend (succ.twin)
					end
					j := j+1
				end
				i := i+1
			end
			end
			Result := successors
		end

	is_end (state: TICTACTOE_STATE): BOOLEAN
		local
			i, j: INTEGER
			none_found: BOOLEAN
		do
			Result := state.has_cross_won or state.has_circle_won
			if not Result then
				from
					i := 1
				until
					i > 3 or none_found
				loop
					from
						j := 1
					until
						j > 3 or none_found
					loop
						if state.board[i,j] = state.None then
							none_found := True
						end
						j := j+1
					end
					i := i+1
				end
				Result := not none_found
			end
		end

	value (state: TICTACTOE_STATE): INTEGER
            -- A sequence of size 1 gives score 1 (resp. -1)
            -- A sequence of size 2 gives score 10 (resp. -10)
            -- A sequence of size 3 gives score 100 (resp. -100)
        local
            score: INTEGER
        do
            if state.has_cross_won then
                score := max_value
            else
                if state.has_circle_won then
                    score := min_value
                else
                    if state.has_double_cross then
                        score := score + 10
                    else
                        if state.has_cross then
                            score  := score + 1
                        end
                    end
            	end
               	if state.has_double_circle then
                    	score := score - 10
                else
                    if state.has_circle then
                        score  := score - 1
                    end
                end
            end
            Result := score
        end

	min_value: INTEGER = -1000

	max_value: INTEGER = 1000


end
