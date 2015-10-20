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


feature {NONE} -- Implementation

	current_maximum_state: S
		-- State with heuristic value better than its neighbors.

	max_number_of_sideways_moves: INTEGER
		-- Maximum number of sideways moves to do to try solving "shoulder problem".
		-- Set to 0 if sideways moves aren't allowed.

	best_heuristic_partial_solution_allowed: BOOLEAN
		-- TRUE if search engine can return best heuristic partial solution when it hasn't found the correct one.


feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- HILL_CLIMBING_ENGINE with a problem
		require
			valid_problem: other_problem /= Void
		do

			set_problem (other_problem)

			set_max_number_of_sideways_moves (20)
				-- Default value of maximum number of sideways moves.

			allow_best_heuristic_partial_solution (true)
				-- Search engine can return best heuristic partial solution by default.

			reset_engine

		ensure
			setting_done: problem = other_problem and max_number_of_sideways_moves = 20 and best_heuristic_partial_solution_allowed
			ready_search: not search_performed
		end


feature -- Search Execution

	perform_search
			-- Starts the search using a hill climbing
			-- strategy. This search strategy is non exhaustive.
			-- The result of the search is indicated in
			-- is_search_successful.

		local

			current_best_heuristic_value: REAL
				-- Saves the best heuristic value reached in each iteration.

			neighbors_list: LIST [S]
				-- List of successors of the current maximum state.

			is_maximum_state_reached: BOOLEAN
				-- TRUE if the neighbors have heuristic value worse or equal than the current maximum state.

			number_of_done_sideways_moves: INTEGER
				-- Counter of done sideways moves.

			stochastic_selection_of_sideways_move: RANDOM
				-- Random numbers generator to have a stochastic choice of sideways move.

		do

			is_maximum_state_reached := false
			number_of_done_sideways_moves := 0
			create stochastic_selection_of_sideways_move.make
			stochastic_selection_of_sideways_move.start
				-- Initializes local variables.


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



				from -- Nested loop: for each successor compare the heuristic value to find the best one.
					neighbors_list.start
				until
					not is_maximum_state_reached or neighbors_list.exhausted
						-- Exits the nested loop as soon as found a neighbor with better heuristic value or when there aren't more neighbors.
				loop

					if problem.heuristic_value (neighbors_list.item) < current_best_heuristic_value then
						-- If a successor has heuristic value better than the current maximum state then update current maximum state.

						current_maximum_state := neighbors_list.item
						current_best_heuristic_value := problem.heuristic_value (current_maximum_state)
						is_maximum_state_reached := false
						number_of_done_sideways_moves := 0

					end

					nr_of_visited_states := nr_of_visited_states + 1
					neighbors_list.forth

				end -- End nested loop.



				-- "ESCAPING SHOULDERS: SIDEWAYS MOVE" optimization.

				if is_maximum_state_reached then
					-- Now if is_maximum_state_reached is TRUE then current maximum state is:
					-- a global maximum or
					-- a local maximum or
					-- a "flat" local maximum or
					-- a shoulder.


					from -- Shoulder loop: for each successor compares the heuristic value to remove the worst.
						neighbors_list.start
					until
						neighbors_list.exhausted
					loop

						if equal (neighbors_list.item, current_maximum_state.parent) or problem.heuristic_value (neighbors_list.item) > current_best_heuristic_value then
							-- If a successor is equal to the parent of current maximum state or has heuristic value
							-- worse than the current maximum state then removes it from neighbors_list, in order to
							-- obtain a neighbors_list with heuristic value equal to the current maximum state, so it
							-- is possible to optimize search with a sideways move.

							neighbors_list.remove

						else
							neighbors_list.forth
						end

					end -- End Shoulder loop.



					if neighbors_list.count = 0 or number_of_done_sideways_moves >= max_number_of_sideways_moves then
						-- If current maximum state has not neighbors with the same heuristic value then it is:
						-- a global maximum or
						-- a local maximum
						-- (or if it exceeds maximum number of sideways moves)


						if problem.is_successful (current_maximum_state) or best_heuristic_partial_solution_allowed then
							-- If current maximum state is a successful state (it is a global maximum) or a best heuristic partial solution is allowed
							-- then search is successful

							is_search_successful := true

						end


					else
						-- else current maximum state could be a shoulder, then do a sideways move.

						-- SIDEWAYS MOVE implementation.
						print (((stochastic_selection_of_sideways_move.item \\ neighbors_list.count) + 1).out + ":%N")

						current_maximum_state := neighbors_list.i_th ((stochastic_selection_of_sideways_move.item \\ neighbors_list.count) + 1)
						stochastic_selection_of_sideways_move.forth
						is_maximum_state_reached := false

						number_of_done_sideways_moves := number_of_done_sideways_moves + 1

					end

				end

			end -- End main loop.

			search_performed := true
				-- End of the search.

		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
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
		end



	allow_best_heuristic_partial_solution(b: BOOLEAN)
		-- Set to TRUE if search engine can return best heuristic partial solution when it hasn't found the correct one.
		do
			best_heuristic_partial_solution_allowed := b
		ensure
			setting_done: best_heuristic_partial_solution_allowed = b
		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
				current_state: S
				list: LINKED_LIST [S]
			do
				if search_performed and is_search_successful then

					create list.make
						-- Initialize local variables.

					from
						-- Get parent state for each state from maximum_state to initial state and put_front in the list.
						current_state := current_maximum_state
					until
						current_state = void
					loop
						list.put_front (current_state)
						current_state := current_state.parent
					end

					Result := list
				end
			end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if search_performed and is_search_successful then
				Result := current_maximum_state
			end
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

end
