note
	description: "[
		Iterative deepening search engine. This is a generic implementation of iterative deepening
		algorithm, to be applied to search problems. To use this engine, instantiate the class 
		providing search states, rules for search states, and a search problem involving the
		search states and rules.
		Iterative deepening performs an unbounded search, based on iterating bounded depth first 
		searches with increasingly deeper maximum depths.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	ITERATIVE_DEEPENING_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- ITERATIVE_DEEPENING_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
		do
			set_problem (other_problem)
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			set_step (1)
			current_depth := 0
			cycle_checking := false
		ensure
			make_parameter_value_error: problem = other_problem
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
			nr_of_visited_states_value_error: nr_of_visited_states = 0
			step_set_error: step = 1
			current_depth_error: current_depth = 0
			cycle_checking_error: cycle_checking = false
		end

feature -- Search Execution

	perform_search
			-- Starts the search using iterative deepening
			-- strategy. This search strategy is unbounded.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			engine: BOUNDED_DEPTH_FIRST_SEARCH_ENGINE [RULE, S, P]
		do
			-- Create Bounded DFS engine
			create engine.make (problem)
			-- Set cycle checking
			if(cycle_checking) then
				engine.enable_cycle_checking
			else
				engine.disable_cycle_checking
			end
			-- Begin search loop
			engine.set_max_depth (current_depth)
			from
			until
				is_search_successful
			loop
				engine.perform_search
				-- Increase visited states counter
				nr_of_visited_states := nr_of_visited_states + engine.nr_of_visited_states
				if (engine.is_search_successful) then
						-- Set search successfull and assign solution
					is_search_successful := true
					solution := engine.obtained_solution
				else
						-- Reset the Bounded DFS engine for a new iteration of the search
					engine.reset_engine
					engine.set_problem (problem)
					go_deeper
					engine.set_max_depth (current_depth)
					if(cycle_checking) then
						engine.enable_cycle_checking
					else
						engine.disable_cycle_checking
					end
				end
			end
			search_performed := true
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			set_step (1)
			current_depth := 0
			cycle_checking := false
		ensure then
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
			nr_of_visited_states_value_error: nr_of_visited_states = 0
			step_set_error: step /= 1
			current_depth_error: current_depth /= 0
			cycle_checking_error: cycle_checking = false
		end

feature -- Status setting

	set_step (new_step: INTEGER)
			-- Sets the step used to increase the depth in each iteration of
			-- bounded depth first search
		require
			new_step >= 1
		do
			step := new_step
		ensure
			step = new_step
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			path: LINKED_LIST [S]
		do
			from
				current_state := solution
				create path.make
			until
				current_state = void
			loop
				path.put_front (current_state)
				current_state := current_state.parent
			end
			Result := path
		ensure then
				-- First member of the list is the starting state,
				-- ending position of the list is the searched state
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if (is_search_successful) then
				Result := solution
			end
		ensure then
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	step: INTEGER
			-- Step used to increase max. depth in subsequent bounded dfs searches.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE}

	current_depth: INTEGER
			-- current depth

	solution: S
			-- solution state

	cycle_checking: BOOLEAN
			-- If true, the algorithm will avoid cycles

	go_deeper
			-- increases current depth according to step
		do
			current_depth := current_depth + step
		ensure
			correct_depth_increase: current_depth = step + old current_depth
		end

feature
		-- Custom features to enable / disable cycle checking
	enable_cycle_checking
			-- Enables cycle checking
		do
			cycle_checking := true
		ensure
			cycle_checking = true
		end

	disable_cycle_checking
			-- Disables cycle checking
		do
			cycle_checking := false
		ensure
			cycle_checking = false
		end

end
