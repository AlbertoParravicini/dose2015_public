note
	description: "The class contains methods used by the AI to play the game and evaluate a generic game state."
	author: "Alberto Parravicini"
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
			-- The weights in the heuristic will all have value equal to 1;
		local
			i: INTEGER
		do
			create weights.make({HEURISTIC_FUNCTIONS_SUPPORT}.num_of_weights)
			from
				i := 1
			until
				i > {HEURISTIC_FUNCTIONS_SUPPORT}.num_of_weights
			loop
				weights.extend (1.0)
				i := i + 1
			end
		end

feature

	initial_state: ADVERSARY_STATE
			-- The initial state of the problem;

	weights: ARRAYED_LIST[REAL_64]
			-- List of the weights used in the heuristic function;

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
				Result := (h1 (state) * weights.i_th (1)
					 + h2 (state) * weights.i_th (2)
					 + h3 (state) * weights.i_th (3)
					 + h4 (state) * weights.i_th (4)
					 + h5 (state) * weights.i_th (5)
					 + h6 (state) * weights.i_th (6)).floor
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

	set_weights (a_weights: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]])
			-- Set the weights used by the heuristic functions given a weights list as input;
			-- The variances should be set to 0 if no breeding has to be performed;
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > {HEURISTIC_FUNCTIONS_SUPPORT}.num_of_weights
			loop
				weights.i_th (i) := a_weights.i_th (i).weight
				i := i + 1
			end
		end

feature {NONE} -- Heuristic functions

	h1 (state: ADVERSARY_STATE): INTEGER
			--  How far ahead of my opponent I am. (my score - the opponent's score);
		require
			non_game_over_state: not state.is_game_over
		do
			Result := state.players.at (1).score - state.players.at (2).score
		end

	h2 (state: ADVERSARY_STATE): INTEGER
			-- How close I am to winning (my score > half of the max score).
			-- The idea is to maximize my score;
		require
			non_game_over_state: not state.is_game_over
		do
			Result := {GAME_CONSTANTS}.num_of_stones - ((({GAME_CONSTANTS}.num_of_stones // 2) + 1) - state.players.at (1).score)
		end

	h3 (state: ADVERSARY_STATE): INTEGER
			-- How far the opponent is to winning (opponent's score > half of the max score).
			-- The idea is to minimize the score gained by the opponent;
		require
			non_game_over_state: not state.is_game_over
		do
			Result := ({GAME_CONSTANTS}.num_of_stones // 2) + 1 - state.players.at (2).score
		end

	h4 (state: ADVERSARY_STATE): INTEGER
			-- The number of stones close to the current player store (counting the closest 1/3 holes to the store);
		require
			non_game_over_state: not state.is_game_over
		local
			i: INTEGER
			sum: INTEGER
		do
			from
				i := {GAME_CONSTANTS}.num_of_holes // (1 + (state.is_min.to_integer))
			until
				i <= (({GAME_CONSTANTS}.num_of_holes // 2) * (2 / 3)).ceiling + (({GAME_CONSTANTS}.num_of_holes // 2) * (state.is_max.to_integer))
			loop
				sum := sum + state.map.get_hole_value (i)
				i := i - 1
			end
			Result := (sum * (-1).power (state.is_max.to_integer)).floor
		end

	h5 (state: ADVERSARY_STATE): INTEGER
			-- The number of stones in the middle of the map on the current player's side (counting the mid 1/3 holes);
		require
			non_game_over_state: not state.is_game_over
		local
			i: INTEGER
			sum: INTEGER
		do
			from
				i := 1 + (({GAME_CONSTANTS}.num_of_holes // 2) * (1 / 3)).ceiling + ({GAME_CONSTANTS}.num_of_holes // 2) * ((state.is_max).to_integer)
			until
				i >= (({GAME_CONSTANTS}.num_of_holes // 2) * (2 / 3)).ceiling + ({GAME_CONSTANTS}.num_of_holes // 2) * ((state.is_max).to_integer)
			loop
				sum := sum + state.map.get_hole_value (i)
				i := i + 1
			end
			Result := (sum * (-1).power (state.is_max.to_integer)).floor
		end

	h6 (state: ADVERSARY_STATE): INTEGER
			-- The number of stones far away from the current player's store (counting the farthest 1/3 holes);
		require
			non_game_over_state: not state.is_game_over
		local
			i: INTEGER
			sum: INTEGER
		do
			from
				i := 1 + (({GAME_CONSTANTS}.num_of_holes // 2) * (state.is_max.to_integer))
			until
				i > (({GAME_CONSTANTS}.num_of_holes // 2) * 1 / 3).floor + (({GAME_CONSTANTS}.num_of_holes // 2) * (state.is_max.to_integer))
			loop
				sum := sum + state.map.get_hole_value (i)
				i := i + 1
			end
			Result := (sum * (-1).power (state.is_max.to_integer)).floor
		end


feature -- Constant values

	min_value: INTEGER = -1000

	max_value: INTEGER = 1000

invariant
	weights_consistent: across weights as curr_weight all (curr_weight.item >= 0 and curr_weight.item <= 1) end
end
