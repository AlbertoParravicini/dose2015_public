note
	description: "Summary description for {ADVERSARY_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_PROBLEM

inherit

	ADVERSARY_SEARCH_PROBLEM [ACTION_SELECT, ADVERSARY_STATE]

create
	make

feature

	make
			-- Default constructor, it generates a initial state;
		do
			--create initial_state.make
		end

feature

	initial_state: ADVERSARY_STATE
			-- The initial state of the problem;

	get_successors (a_state: ADVERSARY_STATE): LIST [ADVERSARY_STATE]
		do
		end

	is_end (state: ADVERSARY_STATE): BOOLEAN
		do
			Result := state.is_game_over
		end

feature
	-- Heuristic search related routines

	value (state: ADVERSARY_STATE): INTEGER
			-- Return the difference between the maximizing player' score and the minimizing player' score;
		do
			if state.index_of_current_player = 1 then
				Result := state.players.at (1).score - state.players.at (2).score
			else
				Result := state.players.at (2).score - state.players.at (1).score
			end
		end

	min_value: INTEGER = -1000

	max_value: INTEGER = 1000

end
