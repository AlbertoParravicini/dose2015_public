note
	description: "[
		Unbounded depth first search engine, with cycle checking. 
		This is a generic implementation of depth first search
		algorithm, to be applied to search problems. To use this engine, instantiate the class 
		providing search states, rules for search states, and a search problem involving the
		search states and rules.
		Unbounded depth first search with cycle checking performs an uninformed, 
		exhaustive depth-first search, and whenever visits a node that is already present
		in the path from the root, it prunes the search (i.e., produces no new successors from
		that state).
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	CYCLE_CHECKING_DEPTH_FIRST_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- CYCLE_CHECKING_DEPTH_FIRST_SEARCH_ENGINE with a problem
		require
			valid_problem: other_problem /= Void
		do
			set_problem (other_problem)
			create stack.make
			stack.put (problem.initial_state)
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			stack.compare_objects
		ensure
		problem_is_not_void: problem /= void and then equal(problem, other_problem)
		search_performed_is_false: not search_performed
		is_search_successful_is_false: not is_search_successful
		stack_is_not_void_and_with_1_element: stack /= void and then (stack.count = 1 and equal(stack.item, problem.initial_state))
		nr_of_visited_states_is_zero: nr_of_visited_states = 0
	end

feature -- Search Execution

	perform_search
			-- Starts the search using a depth first search
			-- strategy. This search strategy performs cycle checking.
			-- When a cycle is detected, the search is forced to backtrack.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
				-- Local variables
			current_state: S
			current_depth: INTEGER
			current_successors: LINKED_LIST [S]
			current_partial_path: LIST [S]
		do
			from
			until
				is_search_successful or stack.is_empty
			loop
				current_state := stack.item
				create current_successors.make
				stack.remove
					-- is it a successful state?
				if (current_state /= void and then problem.is_successful (current_state)) then
					successful_state := current_state
					is_search_successful := true
					nr_of_visited_states := nr_of_visited_states + 1
				end
				if (not is_search_successful) then
						-- No constraints on maximum depth
					current_successors.append (problem.get_successors (current_state))
						-- Set initial state as visited
					nr_of_visited_states := nr_of_visited_states + 1
					from
						current_successors.start
					until
						current_successors.exhausted
					loop
							-- For each state:
							-- 1) check if already visited
							-- 2) check if successful
							-- 3) if successful, set the result
						current_partial_path := partial_path (current_state)
						current_partial_path.compare_objects
						if (not current_partial_path.has (current_successors.item)) then
								-- The state hasn't been visited
							if (problem.is_successful (current_successors.item)) then
									-- If it is a successful state
								nr_of_visited_states := nr_of_visited_states + 1
								successful_state := current_successors.item
								is_search_successful := true
							else
									-- Add the state to the stack, in order to visit it later
								stack.put (current_successors.item)
							end
						end
						current_successors.forth
					end
				end
			end
			search_performed := true
		ensure then
			unsuccessful_search_has_empty_stack: (not is_search_successful) implies stack.is_empty
			at_least_the_initial_state_has_been_visited: nr_of_visited_states > old nr_of_visited_states
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			create stack.make
			stack.put (problem.initial_state)
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			stack.compare_objects
		ensure then
			search_performed_is_false: not search_performed
			is_search_successful_is_false: not is_search_successful
			stack_is_not_void_and_with_1_element: stack /= void and then (stack.count = 1 and equal(stack.item, problem.initial_state))
			nr_of_visited_states_is_zero: nr_of_visited_states = 0
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
				-- Variables that must not change
			problem_invariant: equal(problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal(stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			successful_state_invariant: equal(successful_state, old successful_state)

		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if (is_search_successful) then
				Result := successful_state
			end
		ensure then
			successful_search_has_a_valid_result: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search_has_void_result: (not is_search_successful) implies Result = void
				-- Variables that must not change
			problem_invariant: equal(problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal(stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			successful_state_invariant: equal(successful_state, old successful_state)

		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE}
	-- Local variables

	stack: LINKED_STACK [S]
			-- Stack of the states that will be visited, LIFO

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
		ensure
			first_element_is_initial_state: equal(Result.first, problem.initial_state)
			last_element_is_given_state: equal(Result.last, state)
				-- Variables that must not change
			problem_invariant: equal(problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal(stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			successful_state_invariant: equal(successful_state, old successful_state)
		end

invariant
		-- List of all class invariants
	stack_is_void: stack /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
