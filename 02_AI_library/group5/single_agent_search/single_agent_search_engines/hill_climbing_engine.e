note
	description: "[
		Hill climbing engine. This is a generic implementation of hill climbing, that
		can be applied to any heuristic search problem. The engine is parameterized with a heuristic
		search problem, the search state corresponding to the problem, and the rules associated with
		state change.
		]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"


class
	HILL_CLIMBING_ENGINE[RULE -> ANY, S -> SEARCH_STATE[RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]


inherit
	SEARCH_ENGINE [RULE, S, P]


create
	make


feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- HILL_CLIMBING_ENGINE with a problem

		require

			valid_problem: other_problem /= Void and other_problem.initial_state /= Void

		do

			set_problem (other_problem)

			set_max_number_of_sideways_moves (10)
				-- Default value of maximum number of sideways moves.

			set_best_heuristic_partial_solution_allowed (false)
				-- Search engine can't return best heuristic partial solution by default.

			reset_engine

		ensure

			setting_done: problem = other_problem and max_number_of_sideways_moves = 10 and not best_heuristic_partial_solution_allowed

			ready_to_search: not search_performed
		end


feature {NONE} -- Implementation

	current_maximum_state: S
		-- State with heuristic value better than its neighbors.


	update_current_maximum_state_from_neighbors (current_best_heuristic_value: REAL neighbors_list: LIST [S]): BOOLEAN
		-- For each successor compare the current best heuristic value to find a state better than current_maximum_state.
		-- Return true if current_maximum_state was updated.

		local

			is_current_maximum_state_updated: BOOLEAN
				-- True if current_maximum_state was updated.

		do

			is_current_maximum_state_updated := false
				-- Initializes local variable.


			from -- Neighbors loop.
				neighbors_list.start
			until
				is_current_maximum_state_updated or neighbors_list.exhausted
					-- Exits the loop as soon as found a neighbor with better heuristic value or when there aren't more neighbors.
			loop

				if problem.heuristic_value (neighbors_list.item) < current_best_heuristic_value then
					-- If a successor has heuristic value better than the current maximum state then update current maximum state.

					current_maximum_state := neighbors_list.item

					is_current_maximum_state_updated := true

				end

				nr_of_visited_states := nr_of_visited_states + 1
				neighbors_list.forth

			end -- End neighbors loop.

			Result := is_current_maximum_state_updated

		end


feature -- Search Execution

	perform_search
			-- Starts the search using a hill climbing
			-- strategy. This search strategy is non exhaustive.
			-- The result of the search is indicated in
			-- is_search_successful.

		local

			current_best_heuristic_value: REAL
				-- Saves the best heuristic value reached.

			neighbors_list: LIST [S]
				-- List of successors of the current maximum state.

			is_maximum_state_reached: BOOLEAN
				-- TRUE if the neighbors have heuristic value worse or equal than the current maximum state.

			number_of_done_sideways_moves: INTEGER
				-- Counter of done sideways moves.

			stochastic_selection_of_sideways_move: RANDOM
				-- Random numbers generator to have a stochastic choice of sideways move.

			time_seed_for_random_generator: TIME
				-- Time variable in order to get new random numbers from random numbers generator every time the program runs.

		do

			is_maximum_state_reached := false
			number_of_done_sideways_moves := 0
				-- Initializes local variables.


			create time_seed_for_random_generator.make_now
			create stochastic_selection_of_sideways_move.set_seed (
				((time_seed_for_random_generator.hour
					* 60 + time_seed_for_random_generator.minute)
						* 60 + time_seed_for_random_generator.second)
							* 1000 + time_seed_for_random_generator.milli_second)
			stochastic_selection_of_sideways_move.start
				-- Initializes random generator using current time seed.


			current_maximum_state := problem.initial_state
			current_best_heuristic_value := problem.heuristic_value (current_maximum_state)
			nr_of_visited_states := nr_of_visited_states + 1
				-- Starts search from initial state.


			from -- Main loop.
			until
				is_maximum_state_reached
			loop
				neighbors_list := problem.get_successors (current_maximum_state)
					-- Gets successors of the current maximum state.

				is_maximum_state_reached := true
					-- Assumes that there aren't neighbors with heuristic value better than the current maximum state.



				if problem.is_successful (current_maximum_state) then
					-- If current maximum state is a successful state (it is a global maximum) then search is successful
					-- and ends the main loop.

					is_search_successful := true

				else

					if update_current_maximum_state_from_neighbors (current_best_heuristic_value, neighbors_list) then
						-- If current maximum state is not the solution and was updated because it was found a neighbor better.

						current_best_heuristic_value := problem.heuristic_value (current_maximum_state)
							-- Updates current best heuristic value.

						is_maximum_state_reached := false
							-- Now it may be a new neighbor better than the new current maximum state.

						number_of_done_sideways_moves := 0
							-- Resets counter of sideways moves in order to analize new heuristic value.
					end


					-- "ESCAPING SHOULDERS: SIDEWAYS MOVE" optimization.

					if is_maximum_state_reached then
						-- Now if is_maximum_state_reached is TRUE then current maximum state is:
						-- a local maximum or
						-- a "flat" local maximum or
						-- a shoulder.


						from -- Shoulder loop: for each successor compares the heuristic value to remove the worst.
							neighbors_list.start
						until
							neighbors_list.exhausted
						loop

							if problem.heuristic_value (neighbors_list.item) > current_best_heuristic_value then
								-- If a successor has heuristic value worse than the current maximum state then removes
								-- it from neighbors_list, in order to obtain a neighbors_list with heuristic value equal
								-- to the current maximum state, so it is possible to optimize search with a sideways move.

								neighbors_list.remove

							else
								neighbors_list.forth
							end

						end -- End Shoulder loop.


						-- Now in neighbors_list there are only neighbors with the same heuristic value of the current maximum state.


						if neighbors_list.count = 0 or number_of_done_sideways_moves >= max_number_of_sideways_moves then
							-- If current maximum state has not neighbors with the same heuristic value then it is:
							-- a local maximum
							-- (or if it exceeds maximum number of sideways moves)


							if best_heuristic_partial_solution_allowed then
								-- If best heuristic partial solution is allowed then search is successful.

								is_search_successful := true

							end


						else
							-- else current maximum state could be a shoulder, then do a sideways move.


							-- SIDEWAYS MOVE implementation.

							current_maximum_state := neighbors_list.i_th ((stochastic_selection_of_sideways_move.item \\ neighbors_list.count) + 1)
								-- Now neighbors_list has only states with the same heuristic value than the current maximum state,
								-- so it can pick one randomly to do a sideways move.

							number_of_done_sideways_moves := number_of_done_sideways_moves + 1
							stochastic_selection_of_sideways_move.forth
							is_maximum_state_reached := false

						end

					end -- End "ESCAPING SHOULDERS: SIDEWAYS MOVE" optimization.

				end

			end -- End main loop.

			search_performed := true
				-- End of the search.


		ensure then

			positive_visited_states: nr_of_visited_states > 0

			valid_result: current_maximum_state /= Void

			routine_invariant: max_number_of_sideways_moves = old max_number_of_sideways_moves
								and best_heuristic_partial_solution_allowed = old best_heuristic_partial_solution_allowed

			no_better_neighbor: across problem.get_successors (current_maximum_state) as current_successor all
									problem.heuristic_value (current_maximum_state) <= problem.heuristic_value (current_successor.item)
								end
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0

		ensure then

			setting_done:  search_performed = false and is_search_successful = false and nr_of_visited_states = 0

			routine_invariant: max_number_of_sideways_moves = old max_number_of_sideways_moves and
								best_heuristic_partial_solution_allowed = old best_heuristic_partial_solution_allowed

		end



	set_max_number_of_sideways_moves(n: INTEGER)
		-- Sets maximum number of sideways moves to do to try solving "shoulder problem".
		-- Set to 0 if sideways moves aren't allowed.
		require

			non_negative_number: n >= 0

		do
			max_number_of_sideways_moves := n

		ensure

			setting_done: max_number_of_sideways_moves = n

			routine_invariant: best_heuristic_partial_solution_allowed = old best_heuristic_partial_solution_allowed and
								search_performed = old search_performed and
								is_search_successful = old is_search_successful and
								nr_of_visited_states = old nr_of_visited_states

		end



	set_best_heuristic_partial_solution_allowed(b: BOOLEAN)
		-- Set to TRUE if search engine can return best heuristic partial solution when it hasn't found the correct one.

		do

			best_heuristic_partial_solution_allowed := b

		ensure

			setting_done: best_heuristic_partial_solution_allowed = b

			routine_invariant: max_number_of_sideways_moves = old max_number_of_sideways_moves and
								search_performed = old search_performed and
								is_search_successful = old is_search_successful and
								nr_of_visited_states = old nr_of_visited_states and
								current_maximum_state = old current_maximum_state

		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
				current_state: S
				list: LINKED_LIST [S]
			do
				create list.make
					-- Initialize local variables.

				if search_performed and is_search_successful then

					from
						-- Get parent state for each state from maximum_state to initial state and put_front in the list.
						current_state := current_maximum_state
					until
						current_state = void
					loop
						list.put_front (current_state)
						current_state := current_state.parent
					end

				end

				Result := list

			ensure then

				valid_result: Result /= Void

				function_invariant: max_number_of_sideways_moves = old max_number_of_sideways_moves and
									best_heuristic_partial_solution_allowed = old best_heuristic_partial_solution_allowed and
									search_performed = old search_performed and
									is_search_successful = old is_search_successful and
									nr_of_visited_states = old nr_of_visited_states and
									current_maximum_state = old current_maximum_state

				first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)

				last_state_is_consistent: Result.is_empty or else equal (Result.last, current_maximum_state)

				unsuccessful_search: Result.is_empty implies not is_search_successful

				empty_list_is_consistent: not is_search_successful implies Result.is_empty

			end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if search_performed and is_search_successful then
				Result := current_maximum_state
			end

		ensure then

			function_invariant: max_number_of_sideways_moves = old max_number_of_sideways_moves and
								best_heuristic_partial_solution_allowed = old best_heuristic_partial_solution_allowed and
								search_performed = old search_performed and
								is_search_successful = old is_search_successful and
								nr_of_visited_states = old nr_of_visited_states and
								current_maximum_state = old current_maximum_state


			valid_result: is_search_successful and search_performed implies Result = current_maximum_state

			unsuccessful_search: not is_search_successful implies Result = Void

		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

	max_number_of_sideways_moves: INTEGER
		-- Maximum number of sideways moves to do to try solving "shoulder problem".
		-- If there is not this limit and the current maximum state is a "flat" local maximum
		-- then the algorithm starts an infinite loop.
		-- Set to 0 if sideways moves aren't allowed.

	best_heuristic_partial_solution_allowed: BOOLEAN
		-- TRUE if search engine can return best heuristic partial solution when it hasn't found the correct one.


invariant

	non_negative_variables: nr_of_visited_states >= 0 and max_number_of_sideways_moves >= 0

	valid_current_maximum_state: search_performed implies current_maximum_state /= Void

	correct_solution_found: not best_heuristic_partial_solution_allowed and search_performed and is_search_successful implies problem.is_successful (current_maximum_state)

end
