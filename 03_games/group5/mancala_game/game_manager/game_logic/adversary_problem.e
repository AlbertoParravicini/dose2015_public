note
	description: "The class contains methods used by the AI to play the game and evaluate a generic game state."
	author: "Alberto Parravicini"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_PROBLEM

inherit

	ADVERSARY_SEARCH_PROBLEM [ACTION_SELECT, ADVERSARY_STATE]
	DOUBLE_MATH

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
				Result := h1 (state) + h2 (state) + h3 (state) + h4 (state) + h5 (state) + h6 (state)
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

	box_muller_transform (mean: REAL; variance: REAL)
		local
			u1: REAL_64
			u2: REAL_64
			z1: REAL_64
			z2: REAL_64
			random_number_generator: RANDOM
				-- Random numbers generator to have a stochastic move choice, if the maximum depth is set to 0;
			time_seed_for_random_generator: TIME
				-- Time variable in order to get new random numbers from random numbers generator every time the program runs.

		do
			create time_seed_for_random_generator.make_now
				-- Initializes random generator using current time seed.
			create random_number_generator.set_seed (((time_seed_for_random_generator.hour * 60 + time_seed_for_random_generator.minute) * 60 + time_seed_for_random_generator.second) * 1000 + time_seed_for_random_generator.milli_second)
			random_number_generator.start

			u1 := random_number_generator.real_item
			random_number_generator.forth
			u2 := random_number_generator.real_item


			z1 := sqrt (-2 * log (u1)) * cosine (2 * pi * u2)
			z2 := sqrt (-2 * log (u1)) * sine (2 * pi * u2)


			z1 := z1 * sqrt (variance) + mean
			z2 := z2 * sqrt (variance) + mean
		end


feature -- Constant values

	min_value: INTEGER = -1000

	max_value: INTEGER = 1000

end
