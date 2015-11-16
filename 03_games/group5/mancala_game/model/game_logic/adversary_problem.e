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
		local
			successors: LINKED_LIST[ADVERSARY_STATE]
			current_successor: ADVERSARY_STATE
			i: INTEGER
		do
			create successors.make

			if not a_state.is_game_over then
					-- The maximizing player is identified with player_1;
				if a_state.is_max then
					from
						i := 1
					until
						i > {GAME_CONSTANTS}.num_of_holes // 2
					loop
							-- If the current hole is empty no move can be performed from it;
						if a_state.map.get_hole_value (i) > 0 then
							create current_successor.make_from_parent_and_rule (a_state, create {ACTION_SELECT}.make (i))
							current_successor.move (i)
						end
						i := i + 1
					end

					-- The minimizing player is identified with player_2;
				else
					from
						i := ({GAME_CONSTANTS}.num_of_holes // 2) + 1
					until
						i > {GAME_CONSTANTS}.num_of_holes
					loop
							-- If the current hole is empty no move can be performed from it;
						if a_state.map.get_hole_value (i) > 0 then
							create current_successor.make_from_parent_and_rule (a_state, create {ACTION_SELECT}.make (i))
							current_successor.move (i)
						end
						i := i + 1
					end
				end
			end

			Result := successors
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
