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

	maximum_state: S
		-- State with heuristic value better than its neighbors.

	maximum_number_of_sideways_moves: INTEGER = 50
		-- Maximum number of sideways moves to do to try solving "shoulder problem".
		-- Set to 0 if sideways moves aren't allowed.


feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- HILL_CLIMBING_ENGINE with a problem
		require
			other_problem /= Void
		do
			set_problem (other_problem)
			reset_engine
		ensure
			problem = other_problem
			not search_performed
		end


feature -- Search Execution

	perform_search
			-- Starts the search using a hill climbing
			-- strategy. This search strategy is non exhaustive.
			-- The result of the search is indicated in
			-- is_search_successful.

		local

			current_state: S
				-- State with heuristic value better than its parents.

			current_best_heuristic_value: REAL
				-- Save the best heuristic value reached in each iteration.

			neighbors_list: LIST [S]
				-- List of successors of the current state.

			is_maximum_state_reached: BOOLEAN
				-- TRUE if the neighbors have heuristic value worse or equal than the current state.

			useless_state_found: BOOLEAN
				-- TRUE if a useless state has been removed from neighbors list.
				-- Useless state: a state equal to parent of current state or
				-- with an heuristic value worse than the current state.

			number_of_done_sideways_moves: INTEGER
				-- Counter of done sideways moves.

		do

			is_maximum_state_reached := false
			number_of_done_sideways_moves := 0
				-- Initialize local variables.


			current_state := problem.initial_state
			current_best_heuristic_value := problem.heuristic_value (current_state)
			nr_of_visited_states := nr_of_visited_states + 1
				-- Start search from initial state.


			from -- Main loop.
			until
				is_maximum_state_reached
			loop
				neighbors_list := problem.get_successors (current_state)
					-- Get successors of the current state.

				is_maximum_state_reached := true
					-- Assume that there aren't neighbors with heuristic value better than the current state.



				from -- Nested loop: for each successor compare the heuristic value to find the best one.
					neighbors_list.start
				until
					not is_maximum_state_reached or neighbors_list.exhausted
						-- Exit the nested loop as soon as found a neighbor with better heuristic value or when there aren't more neighbors.
				loop
					useless_state_found := false

					if problem.heuristic_value (neighbors_list.item) < current_best_heuristic_value then
						-- If a successor has heuristic value better than the current state then update current state.

						current_state := neighbors_list.item
						current_best_heuristic_value := problem.heuristic_value (current_state)
						is_maximum_state_reached := false
						number_of_done_sideways_moves := 0


					else

						if equal (neighbors_list.item, current_state.parent) or problem.heuristic_value (neighbors_list.item) > current_best_heuristic_value then
							-- If a successor is equal to the parent of current state or has heuristic value
							-- worse than the current state then remove it from neighbors_list, in order to
							-- obtain a neighbors_list with heuristic value equal to the current state, so it
							-- is possible to optimize search with "Escaping Shoulders: Sideways Move" process.

							neighbors_list.remove
							useless_state_found := true

						end

					end

					nr_of_visited_states := nr_of_visited_states + 1

					if not useless_state_found then
						-- If no state has been removed from neighbors_list then go to the next neighbor.

						neighbors_list.forth

					end

				end -- End nested loop.


				-- "Escaping Shoulders: Sideways Move"

				if is_maximum_state_reached then
					-- Now if is_maximum_state_reached is TRUE then current state is:
					-- a global maximum or
					-- a local maximum or
					-- a "flat" local maximum or
					-- a shoulder.

					if problem.is_successful (current_state) or neighbors_list.count = 0 or number_of_done_sideways_moves >= maximum_number_of_sideways_moves then
						-- If current state is a successful state or has not neighbors with the same heuristic value then is respectively:
						-- a global maximum or
						-- a local maximum;

						maximum_state := current_state;

					else
						-- else current state could be a shoulder, then do a sideways move.

						print (number_of_done_sideways_moves.out + ":%N")

							-- Execution of sideways move.	
						from
							neighbors_list.start
						until
							neighbors_list.exhausted
						loop
							print (neighbors_list.item.out + "%N")
							neighbors_list.forth
						end

						current_state := neighbors_list.i_th (1)
						is_maximum_state_reached := false

						number_of_done_sideways_moves := number_of_done_sideways_moves + 1

					end

				end

			end -- End main loop.

			is_search_successful := true
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
						current_state := maximum_state
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
				Result := maximum_state
			end
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

end
