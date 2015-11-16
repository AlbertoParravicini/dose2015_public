note
	description: "Summary description for {ADVERSARY_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_PROBLEM


	make
			-- Default constructor, it generates a initial state;
		do
			create initial_state.make
		end

	make_with_initial_state (new_state: SOLITAIRE_STATE)
			-- Initializes the problem with the provided initial state;
		do
			initial_state := new_state
		end

feature

	initial_state: SOLITAIRE_STATE
			-- The initial state of the problem;

get_successors (a_state: SOLITAIRE_STATE): LIST [SOLITAIRE_STATE]
		do

		end

	is_successful (state: SOLITAIRE_STATE): BOOLEAN


feature
	-- Heuristic search related routines

	value (state: SOLITAIRE_STATE): INTEGER
			-- Return the remaining number of stones in the game;
		do
			if state.current_player.is_equal (state.player_1) then
				Result := state.player_1.score - state.player_2.score
			else
				Result := state.player_2.score - state.player_1.score
			end
		end
end
