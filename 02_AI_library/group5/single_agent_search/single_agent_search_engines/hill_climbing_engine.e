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

		-- State with heuristic value higher than its neightbors.
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

				-- State with heuristic value higher than its parents.
			current_state: S

				-- List of successors of the current state.
			neightbors_list: LIST [S]

				-- TRUE if the neightbors have heuristic value less or equal to the current state.
			is_maximum_state_reached: BOOLEAN

		do
				-- Initialize local variables.
			--create current_state.make
			--create neightbors_list.make
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
				neightbors_list := problem.get_successors (current_state)

					-- Assume that there aren't neightbors with heuristic value higher than the current state.
				is_maximum_state_reached := true

					-- Nested loop: for each successor compare the heuristic value to find the highest one.
				from
					neightbors_list.start
				until
					neightbors_list.exhausted
				loop
						-- If a successor has heuristic value higher than the current state then update current state.
					if problem.heuristic_value (neightbors_list.item) > problem.heuristic_value (current_state) then
						current_state := neightbors_list.item
						is_maximum_state_reached := false
					end
					nr_of_visited_states := nr_of_visited_states + 1
					neightbors_list.forth
				end

			end

				-- Now current state is a local maximum or a "flat" local maximum or a shoulder.
			maximum_state := current_state;

				-- If maximum state is a successful state then it is also the global maximum and the search is successful.
			if problem.is_successful (maximum_state) then
				is_search_successful := true
			end

				-- End of the search.
			search_performed := true
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			--create maximum_state.make
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
					--create current_state.make
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
