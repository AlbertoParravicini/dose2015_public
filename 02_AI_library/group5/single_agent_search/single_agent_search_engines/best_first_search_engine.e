note
	description: "[
		Best first search engine. This is a generic implementation of best first search, that
		can be applied to any heuristic search problem. The engine is parameterized with a heuristic
		search problem, the search state for the problem, and the rules associated with
		state change.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	BEST_FIRST_SEARCH_ENGINE [RULE -> ANY, reference S -> SEARCH_STATE [RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- BEST_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
			other_problem.initial_state /= Void
		do
			set_problem (other_problem)
			reset_engine
		ensure
			problem_set: problem /= void and then equal (problem, other_problem)
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
			successful_state_resetted: successful_state = void
			visited_states_reset: nr_of_visited_states = 0
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a best first search
			-- strategy.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			current_state: S
			open: LINKED_LIST [S]
			current_successors: LIST [S]
		do
			from
				create open.make
				open.compare_objects
				open.extend (problem.initial_state)
				open.start
			until
				is_search_successful or open.is_empty
			loop
				current_state := best_state (open)
				nr_of_visited_states := nr_of_visited_states + 1

				if problem.is_successful (current_state) then
					successful_state := current_state
					is_search_successful := True
				else
					open.start
					open.prune (current_state)
					current_successors := problem.get_successors (current_state)
					open.append (current_successors)
				end
			end
			search_performed := True
		ensure then
			no_visited_states: nr_of_visited_states >= old nr_of_visited_states
			search_successful_nec: is_search_successful implies problem.is_successful (successful_state)
			search_successful_suc: (search_performed = true and successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful
			routine_invariant: equal (problem, old problem)
		end

feature {NONE} -- Implementative features

	best_state (state_list: LINKED_LIST [S]): S
			-- Given a list of states, removes from the list the best item
			-- (i.e. the one with lowest heuristic value), and returns it;
		require
			state_list /= void
		do
			if not state_list.is_empty then
				from
					state_list.start
					Result := state_list.item
					state_list.forth
				until
					state_list.exhausted
				loop
					if problem.heuristic_value (Result) > problem.heuristic_value (state_list.item) then
						Result := state_list.item
					end
					state_list.forth
				end
			end
		ensure
			result_is_consistent: old state_list.count > 0 implies Result /= void
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
			successful_state := void
		ensure then
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
			visited_states_reset: nr_of_visited_states = 0
			routine_invariant: equal (problem, old problem)
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			list: LINKED_LIST [S]
		do
			create list.make
			if (is_search_successful) then
					-- Starting from the successful state, get the parent of each state
					-- by travelling backwards in the hierarchy, and add it to a list
				from
					current_state := obtained_solution
					list.put_front (current_state)
				until
					current_state.parent = void
				loop
					list.put_front (current_state.parent)
					current_state := current_state.parent
				end
			end
			Result := list
		ensure then
				--First member of the list is the starting state, ending position of the list is the searched state
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and equal (problem, old problem) and equal (successful_state, old successful_state)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if is_search_successful and search_performed then
				Result := successful_state
			end
		ensure then
			if_result_exists_not_void: (is_search_successful and search_performed) implies Result = successful_state
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and equal (problem, old problem) and equal (successful_state, old successful_state)
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE}

	successful_state: S
			-- Searched state

invariant
	is_search_successful implies search_performed
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
