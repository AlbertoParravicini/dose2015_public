note
	description: "[
		Heuristic depth first search engine. This is a generic implementation of heuristic depth
		first search, that can be applied to any heuristic search problem. The engine is 
		parameterized with a heuristic search problem, the search state for the problem, and the 
		rules associated with state change.
		This engine performs a depth first search, but in each step prioritizes the successors to visit
		by their heuristic value.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE with a problem
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
			cycle_checking := false
		ensure
			problem_is_not_void: problem = other_problem
			search_performed_is_false: not search_performed
			is_search_successful_is_false: not is_search_successful
			stack_is_not_void_and_with_1_element: stack /= void and then (stack.count = 1 and equal (stack.item, problem.initial_state))
			nr_of_visited_states_is_zero: nr_of_visited_states = 0
			cycle_checking_is_false: cycle_checking = false
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a heuristic depth first search
			-- strategy.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
				-- Local variables
			current_state: S
			current_depth: INTEGER
			current_successors: LINKED_LIST [S]
			current_partial_path: LIST [S]
			current_successors_with_heuristic_value: LINKED_LIST [TUPLE [state: S; value: REAL]]
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

						-- Fill current_successors_with_heuristic_value according to their heuristic value
					create current_successors_with_heuristic_value.make
					from
						current_successors.start
					until
						current_successors.exhausted
					loop
						current_successors_with_heuristic_value.extend ([current_successors.item, problem.heuristic_value (current_successors.item)])
						current_successors.forth
					end

						-- Reorder current_successors_with_heuristic_value from lower to higher heuristic value

					sort_list_with_tuples (current_successors_with_heuristic_value)

						-- Perform real search

					from
						current_successors_with_heuristic_value.finish
					until
						current_successors_with_heuristic_value.exhausted
					loop
							-- For each state:
							-- 1) check if already visited
							-- 2) check if successful
							-- 3) if successful, set the result
						if (cycle_checking) then
							current_partial_path := partial_path (current_state)
							current_partial_path.compare_objects
						end
						if ((cycle_checking and then (not current_partial_path.has (current_successors_with_heuristic_value.item.state))) or (not cycle_checking)) then
								-- The state hasn't been visited
							if (problem.is_successful (current_successors_with_heuristic_value.item.state)) then
									-- If it is a successful state
								nr_of_visited_states := nr_of_visited_states + 1
								successful_state := current_successors_with_heuristic_value.item.state
								is_search_successful := true
							else
									-- Add the state to the stack, in order to visit it later

								stack.put (current_successors_with_heuristic_value.item.state)
							end
						end
						current_successors_with_heuristic_value.back
					end
				end
			end
			search_performed := true
		ensure then
			unsuccessful_search_has_empty_stack: (not is_search_successful) implies stack.is_empty
			at_least_the_initial_state_has_been_visited: nr_of_visited_states > old nr_of_visited_states
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			create stack.make
			stack.put (problem.initial_state)
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			cycle_checking := false
		ensure then
			search_performed_is_false: not search_performed
			is_search_successful_is_false: not is_search_successful
			stack_is_not_void_and_with_1_element: stack /= void and then (stack.count = 1 and equal (stack.item, problem.initial_state))
			nr_of_visited_states_is_zero: nr_of_visited_states = 0
			cycle_checking_is_false: cycle_checking = false
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
			-- If there is no path, an empty list is returned
		do
			Result:=partial_path(successful_state)
		ensure then
				-- First member of the list is the starting state,
				-- ending position of the list is the searched state
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
				-- Variables that must not change
			problem_invariant: equal (problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal (stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			cycle_checking_invariant: cycle_checking = old cycle_checking
			successful_state_invariant: equal (successful_state, old successful_state)
			-- Check that the path is valid
		path_is_valid: across generate_list_of_integers(Result.count-1) as i all equal(Result.i_th(i.item), Result.i_th (i.item + 1).parent) end

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
			problem_invariant: equal (problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal (stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			cycle_checking_invariant: cycle_checking = old cycle_checking
			successful_state_invariant: equal (successful_state, old successful_state)
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

	cycle_checking: BOOLEAN
			-- If true, the algorithm will avoid cycles

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
			first_element_is_initial_state: equal (Result.first, problem.initial_state)
			last_element_is_given_state: equal (Result.last, state)
				-- Variables that must not change
			problem_invariant: equal (problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal (stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			cycle_checking_invariant: cycle_checking = old cycle_checking
			successful_state_invariant: equal (successful_state, old successful_state)
			-- Check that the path is valid
		path_is_valid: across generate_list_of_integers(Result.count-1) as i all equal(Result.i_th(i.item), Result.i_th (i.item + 1).parent) end

		end

	sort_list_with_tuples (my_list: LIST [TUPLE [state: S; value: REAL]])
			-- sorts the given list from the state with the highest value to the one with the lowest value
			-- insertion sort
		local
			i, j: INTEGER
			temp_tuple: TUPLE [state: S; value: REAL]
			temp_tuple2: TUPLE [state: S; value: REAL]
		do
			from
				i := 2
			until
				i = my_list.count + 1
			loop
				temp_tuple := my_list.i_th (i)
				j := i - 1
				from
				until
					j < 1 or my_list.i_th (j).value <= temp_tuple.value
				loop
					temp_tuple2 := my_list.i_th (j)
					my_list.i_th (j + 1) := temp_tuple2
					j := j - 1
				end
				my_list.i_th (j + 1) := temp_tuple
				i := i + 1
			end
		ensure
			my_list_contains_only_previous_elements: across my_list as element all (old my_list).has (element.item) end
			my_list_contains_all_previous_elements: across (old my_list) as element all my_list.has (element.item) end
			my_list_has_the_correct_length: my_list.count = (old my_list.count)
		end

	generate_list_of_integers (int: INTEGER): LIST [INTEGER]
			-- Auxiliary function that generates a list of integers from 1 to int, used in some postconditions
		require
			int > 0
		local
			my_list: LINKED_LIST [INTEGER]
			current_int: INTEGER
		do
			from
				create my_list.make
				current_int := 1
			until
				current_int = int + 1
			loop
				my_list.extend (current_int)
				current_int := current_int + 1
			end
			Result := my_list
		ensure
			result_contains_integers_from_1_to_int: across Result as i all Result.i_th (i.item) = i.item end and Result.count = int
		end

feature
	-- Custom features to enable / disable cycle checking

	enable_cycle_checking
			-- Enables cycle checking
		do
			cycle_checking := true
		ensure
			cycle_checking_is_true: cycle_checking = true
				-- Variables that must not change
			problem_invariant: equal (problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal (stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			successful_state_invariant: equal (successful_state, old successful_state)
		end

	disable_cycle_checking
			-- Disables cycle checking
		do
			cycle_checking := false
		ensure
			cycle_checking_is_false: cycle_checking = false
				-- Variables that must not change
			problem_invariant: equal (problem, old problem)
			search_performed_invariant: search_performed = old search_performed
			is_search_successful_invariant: is_search_successful = old is_search_successful
			stack_invariant: equal (stack, old stack)
			nr_of_visited_states_invariant: nr_of_visited_states = old nr_of_visited_states
			successful_state_invariant: equal (successful_state, old successful_state)
		end

invariant
		-- List of all class invariants
	stack_is_void: stack /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
