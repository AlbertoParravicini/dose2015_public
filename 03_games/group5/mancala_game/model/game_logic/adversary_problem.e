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
			-- Default constructor, it generates an adversary problem;
		do
		end

feature

	initial_state: ADVERSARY_STATE
			-- The initial state of the problem;

	get_successors (a_state: ADVERSARY_STATE): LIST [ADVERSARY_STATE]
		local
			successors: LINKED_LIST [ADVERSARY_STATE]
			current_successor: ADVERSARY_STATE
			i: INTEGER
			selected_move: INTEGER
		do
			create successors.make
			if not a_state.is_game_over then
				from
					i := 1
				until
					i > {GAME_CONSTANTS}.num_of_holes // 2
				loop
						-- If the player is 1, then selected_move = i, else if player is 2, selected_move = i + offset
					selected_move := i + ({GAME_CONSTANTS}.num_of_holes // 2) * (a_state.index_of_current_player - 1)

						-- If the current hole is empty no move can be performed from it;
					if a_state.map.get_hole_value (selected_move) > 0 then
						create current_successor.make_from_parent_and_rule (a_state, create {ACTION_SELECT}.make (selected_move))
						successors.extend (current_successor)
					end
					i := i + 1
				end
			end
			Result := successors
		ensure then
			at_most_tot_successors: Result.count <= {GAME_CONSTANTS}.num_of_holes // 2
		end

	is_end (state: ADVERSARY_STATE): BOOLEAN
		do
			Result := state.is_game_over
		ensure then
			result_consistent: (Result = true implies state.is_game_over) and (state.is_game_over implies Result = true)
		end

feature
	-- Heuristic search related routines

	value (state: ADVERSARY_STATE): INTEGER
			-- Return the difference between the maximizing player' score and the minimizing player' score;
		do
			if not state.is_game_over then
				Result := state.players.at (1).score - state.players.at (2).score
			elseif state.players.at (1).score > state.players.at (2).score then
				Result := max_value - 1
			elseif state.players.at (1).score < state.players.at (2).score then
				Result := min_value + 1
			else
				Result := 0
			end
		ensure then
			result_is_consistent: Result >= min_value and Result <= max_value
		end

	min_value: INTEGER = -1000

	max_value: INTEGER = 1000

end
