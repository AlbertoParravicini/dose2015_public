note
	description: "[
		Bounded depth first search engine. This is a generic implementation of depth first search
		algorithm, to be applied to search problems. To use this engine, instantiate the class 
		providing search states, rules for search states, and a search problem involving the
		search states and rules.
		Bounded depth first search performs an uninformed, exhaustive depth-first search up to depth 
		maximum_depth.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	BOUNDED_DEPTH_FIRST_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- DEPTH_FIRST_SEARCH_ENGINE with a problem
		require
			make_parameter_error: other_problem /= Void
		do
			set_problem (other_problem)
			create stack.make
			stack.put (0, problem.initial_state)
			stack.compare_objects
			search_performed := false
			is_search_successful := false
			set_max_depth (0)
			nr_of_visited_states := 0

				-- Use this boolean to enable or disable cycle checking
			cycle_checking := false
		ensure
			make_parameter_value_error: problem = other_problem
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
			stack_value_error: stack /= void and then stack.count = 1
			max_depth_value_error: maximum_depth = 0
			nr_of_visited_states_value_error: nr_of_visited_states = 0
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a depth first search
			-- strategy. This search strategy is bounded.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			current_state: S
			current_depth: INTEGER
			current_successors: LINKED_LIST [S]
			current_tuple: TUPLE [depth: INTEGER; state: S]
			current_partial_path: LIST [S]
		do
			from
			until
				is_search_successful or stack.is_empty
			loop
					-- Remove last member of the stack
				current_tuple := stack.item
				current_state := current_tuple.state
				current_depth := current_tuple.depth
				create current_successors.make
				stack.remove
					-- Is it a successfull state?
				if (current_state /= void and then problem.is_successful (current_state)) then
					successful_state := current_state
					is_search_successful := true
					nr_of_visited_states := nr_of_visited_states + 1
				end
				if (not is_search_successful) then
						-- Have I reached max depth?
					if (not (current_depth >= maximum_depth)) then
							-- Get list of successors from current state
						current_successors.append (problem.get_successors (current_state))
							-- Set current state as visited
						nr_of_visited_states := nr_of_visited_states + 1
							-- Analyze all the successors of the current state
						from
							current_successors.start
						until
							current_successors.exhausted or is_search_successful
						loop
								-- If cycle_checking is enabled, the search will exclude successors
								-- that are equal to at least one of the ancestors of the current state
							if (cycle_checking) then
								current_partial_path := partial_path (current_state)
								current_partial_path.compare_objects
							end
								-- Exclude the current successors if cycle checking is enabled and the
								-- successor is one of the ancestors
							if ((cycle_checking and then (not current_partial_path.has (current_successors.item)))
								or (not cycle_checking)) then
									-- Check if the problem is solved with the current successor
								if (problem.is_successful (current_successors.item)) then
										-- If it is the desired state, increment the counter
										-- of the visited states and set the search successfull
									nr_of_visited_states := nr_of_visited_states + 1
									successful_state := current_successors.item
									is_search_successful := true
								else
										-- If current successor isn't a successful state,
										-- add the state to the stack to visit him later
									stack.put ([current_depth + 1, current_successors.item])
								end
							end
								-- Go to next successor
							current_successors.forth
						end
					end
					nr_of_visited_states := nr_of_visited_states + 1
				end
			end
			search_performed := true
		ensure then
			unsuccessful_state_with_non_empty_stack: (not is_search_successful) implies stack.is_empty
			no_visited_states: nr_of_visited_states > old nr_of_visited_states
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			create stack.make
			stack.put (0, problem.initial_state)
			search_performed := false
			is_search_successful := false
			set_max_depth (0)
			nr_of_visited_states := 0
			stack.compare_objects
		ensure then
			is_search_successful_value_error: not is_search_successful
			stack_value_error: stack /= void and then stack.count = 1
			max_depth_non_reset: maximum_depth = 0
			nr_of_visited_states_non_reset: nr_of_visited_states = 0
		end

feature -- Status setting

	set_max_depth (new_bound: INTEGER)
			-- Sets the max depth bound to new_bound
		require
			new_bound >= 0
		do
			maximum_depth := new_bound
		ensure
			maximum_depth = new_bound
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
			-- If there is no path, an empty list is returned
		local
			current_state: S
			path: LINKED_LIST [S]
		do
			from
				current_state := obtained_solution
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
				Result := successful_state
			end
		ensure then
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	maximum_depth: INTEGER
			-- Max depth employed for the bounded depth first search.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE}

	stack: LINKED_STACK [TUPLE [depth: INTEGER; state: S]]
			-- Where the states will be saved

	cycle_checking: BOOLEAN
			-- If true, the algorithm will avoid cycles

	successful_state: S
			-- Searched state

	partial_path (state: S): LIST [S]
			-- Returns the path to the solution obtained from performed search.
			-- If there is no path, an empty list is returned
		local
			current_state: S
			path: LINKED_LIST [S]
		do
			from
				current_state := state
				create path.make
			until
				current_state = void
			loop
				path.put_front (current_state)
				current_state := current_state.parent
			end
			Result := path
		end

invariant
	stack_is_void: stack /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
