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

		-- State with heuristic value better than its neighbors.
	maximum_state: S

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

				-- State with heuristic value better than its parents.
			current_state: S

				-- List of successors of the current state.
			neighbors_list: LIST [S]

				-- TRUE if the neighbors have heuristic value worse or equal than the current state.
			is_maximum_state_reached: BOOLEAN

		do
				-- Initialize local variables.
			is_maximum_state_reached := false

				-- Start search from initial state.
			current_state := problem.initial_state
			nr_of_visited_states := nr_of_visited_states + 1

				-- Main loop.
			from
			until
				is_maximum_state_reached
			loop
					-- Get successors of the current state.
				neighbors_list := problem.get_successors (current_state)

					-- Assume that there aren't neighbors with heuristic value better than the current state.
				is_maximum_state_reached := true


					-- Nested loop: for each successor compare the heuristic value to find the best one.
				from
					neighbors_list.start
				until
						-- Exit the nested loop as soon as found a neighbor with better heuristic value or when there aren't more neighbors.
					not is_maximum_state_reached or neighbors_list.exhausted
				loop
						-- If a successor has heuristic value better than the current state then update current state.
					if problem.heuristic_value (neighbors_list.item) < problem.heuristic_value (current_state) then
						current_state := neighbors_list.item
						is_maximum_state_reached := false
					end
					nr_of_visited_states := nr_of_visited_states + 1
					neighbors_list.forth
				end -- End nested loop.


					-- Now if is_maximum_state_reached is TRUE then current state is a global maximum or a local maximum or a "flat" local maximum or a shoulder.
				if is_maximum_state_reached then
					maximum_state := current_state;
				end

			end -- End main loop.

				-- End of the search.
			is_search_successful := true
			search_performed := true
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

						-- Initialize local variables.
					create list.make

						-- Get parent state for each state from maximum_state to initial state and put_front in the list.
					from
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
