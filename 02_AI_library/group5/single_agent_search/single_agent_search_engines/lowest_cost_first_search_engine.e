note
	description: "[
		Lowest cost first search engine. 
		This is a generic implementation of lowest cost first search
		algorithm, to be applied to search problems. To use this engine, instantiate the class 
		providing search states, rules for search states, and a search problem involving the
		search states and rules.
		Lowest cost first search performs an uninformed, exhaustive search, where
		successor states are prioritized according to the cost of the path leading to them.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	LOWEST_COST_FIRST_SEARCH_ENGINE [RULE -> ANY, reference S -> SEARCH_STATE [RULE], P -> STATE_COST_SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- LOWEST_COST_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
			other_problem.initial_state /= Void
		do
			set_problem (other_problem)
			mark_explored_states := false
			reset_engine
		ensure
			problem_set: problem /= void and then equal(problem, other_problem)
			explored_state_not_marked: mark_explored_states = false
			search_not_performed: not search_performed
			explored_reinitialized: explored /= void and then explored.count = 0
			successful_state_resetted: successful_state = void
		    explored_uses_equal: explored.object_comparison = true
			visited_states_reset: nr_of_visited_states = 0
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a lowest-cost first search
			-- strategy. This search strategy prioritizes states according to the cost
			-- of the path leading to them, attempting to produce minimum-cost solutions.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			current_state: S
			current_state_path_cost: REAL_32
			current_successors: LINKED_LIST [S]
			current_tuple: TUPLE [state: S; cost: REAL]
			current_child: S
			current_path_child: REAL_32
			useful_state: BOOLEAN
		do
			create current_successors.make
			current_state := problem.initial_state
			current_state_path_cost := problem.cost (current_state)
			current_tuple := [current_state, current_state_path_cost]
			frontier.extend (current_tuple)

			if problem.is_successful (current_state) then
				is_search_successful := true
				successful_state := current_state
				nr_of_visited_states := nr_of_visited_states + 1
			end

			from
			until
				frontier.is_empty or is_search_successful = true
			loop
				current_successors.wipe_out
					-- Pick the most promising state (i.e the one with lowest cost) from the frontier
					-- and remove it from the "frontier" list;
				current_tuple := remove_best_item (frontier)
				current_state := current_tuple.state
					-- Calculate how far the current_state is from the start.
				current_state_path_cost := current_tuple.cost

				explored.extend (current_tuple)

				nr_of_visited_states := nr_of_visited_states + 1
				if problem.is_successful (current_state) then
					is_search_successful := true
					successful_state := current_state
				end
				current_successors.append (problem.get_successors (current_state))
					-- For each successor "n" of the current state which is being expanded;
				across
					current_successors as curr_successor
				loop
					useful_state := false
					current_child := curr_successor.item
					current_path_child := current_state_path_cost + problem.cost (current_child)

					if (mark_explored_states = true) then
						if not (state_in_list (current_child, explored)) then
							useful_state := true
						elseif
							cost_in_list (current_child, explored) > (current_path_child)
						then
							explored := replace_in_list ([current_child, current_state_path_cost], explored)
							useful_state := true
						end
					end

						--if n is not in explored and n is not in frontier
					if ((mark_explored_states = false or (mark_explored_states = true and useful_state = true)) and not (state_in_list (current_child, frontier))) then
						frontier.extend ([current_child, current_path_child])
					else
							-- If current_child is already in the frontier, but with an higher cost,
							-- replace the existing state with current_child and its cost;
						if (state_in_list (current_child, frontier) and cost_in_list (current_child, frontier) > (current_path_child)) then
							frontier := replace_in_list ([current_child, current_state_path_cost], frontier)
						end
					end
				end
			end
			search_performed := true
		ensure then
			no_visited_states: nr_of_visited_states > old nr_of_visited_states
			at_least_one_state_visited: mark_explored_states = true implies (explored.count > old explored.count)
			search_successful_nec: is_search_successful implies problem.is_successful (successful_state)
			search_successful_suc: (search_performed = true and successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful
			routine_invariant: old mark_explored_states = mark_explored_states and equal(problem, old problem)
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			create frontier.make
			create explored.make
			is_search_successful := false
			nr_of_visited_states := 0
			frontier.compare_objects
			explored.compare_objects
			successful_state := void
		ensure then
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
			closed_reinitialized: explored /= void and then explored.count = 0
			successful_state_resetted: successful_state = void
			explored_uses_equal: explored.object_comparison = true
			visited_states_reset: nr_of_visited_states = 0
			routine_invariant: old mark_explored_states = mark_explored_states and equal(problem, old problem)
		end

feature -- Status Report

	path_to_obtained_solution: LINKED_LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			list: LINKED_LIST [S]
		do
			create list.make
			if (is_search_successful) then
					-- Starting from the successful state, get the parent of each state
					-- by travelling backwards in the hierarchy, and add it to a list;
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
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_explored_states = mark_explored_states and equal(problem, old problem) and equal(explored, old explored) and equal(successful_state, old successful_state)
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
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_explored_states = mark_explored_states and equal(problem, old problem) and equal(explored, old explored) and equal(successful_state, old successful_state)
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

	mark_explored_states: BOOLEAN
			-- Memorize the visited states in a list, then when a new state is generated, check if it was already visited:
			-- if it was visited at a higher cost, replace it with the new state and the new cost;


feature -- Status setting

	set_mark_explored_states (a_choice: BOOLEAN)
			-- Set whether to memorize the visited states or not; when a new state is evaluated,
			-- it is checked if the state was already visited before at a higher cost: if so,
			-- the old state and its cost are replaced with the new one.
			-- It is recommended to have this setting activated if the state space cardinality is rather small;
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			mark_explored_states := a_choice
			if (explored /= void) then
				explored.wipe_out
			end
		ensure
			mark_closed_set: mark_explored_states = a_choice
			empty_closed_states: explored.count = 0
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and equal(problem, old problem) and equal(successful_state, old successful_state)
		end

feature {NONE}

	cost_in_list (current_s: S; state_list: LINKED_LIST [TUPLE [state: S; cost: REAL_32]]): REAL_32
			-- Return the cost of a given state contained in the given list;
		require
			current_s /= void
			state_list /= void
		local
			found: BOOLEAN
		do
			found := false
			from
				state_list.start
			until
				(found or state_list.exhausted)
			loop
				if (current_s.is_equal (state_list.item.state)) then
					found := true
					Result := state_list.item.cost
				else
					state_list.forth
				end
			end
		ensure
			result_is_positive: Result >= 0
		end

	remove_best_item (a_list: LINKED_LIST [TUPLE [state: S; cost: REAL]]): TUPLE [state: S; cost: REAL]
			-- Remove the best item, i.e. the one with lowest cost, from the given list "a_list";
		require
			a_list /= void
		local
			best_item_index: INTEGER
		do
			from
				best_item_index := 1
				a_list.start
				Result := a_list.first
			until
				a_list.exhausted
			loop
				if a_list.item.cost < Result.cost then
					Result := a_list.item
					best_item_index := a_list.index
				end
				a_list.forth
			end
			if a_list.count > 0 then
				a_list.go_i_th (best_item_index)
				a_list.remove
			end
		ensure
			result_is_consistent: old a_list.count > 0 implies Result /= void
		end

	state_in_list(current_s: S; state_list: LINKED_LIST [TUPLE [state: S; cost: REAL]]): BOOLEAN
			-- Is the state contained in the given list?
		require
			current_s /= void
			state_list /= void
		local
			found: BOOLEAN
		do
			found := false
			from
				state_list.start
			until
				(found or state_list.exhausted)
			loop
				if (current_s.is_equal (state_list.item.state)) then
					found := true
				end
				state_list.forth
			end
			Result := found
		ensure
			result_consistent_nec: Result = true implies across state_list as curr_state some equal(curr_state.item.state, current_s) end
			result_consistent_suf: across state_list as curr_state some equal(curr_state.item.state, current_s) end implies Result = true
		end

	replace_in_list (current_s: TUPLE [state: S; cost: REAL_32]; state_list: LINKED_LIST [TUPLE [state: S; cost: REAL_32]]): LINKED_LIST [TUPLE [state: S; cost: REAL_32]]
			-- Replaces a state contained in the given list;
		require
			current_s /= void
			state_list /= void
		local
			replaced: BOOLEAN
		do
			replaced := false
			from
				state_list.start
			until
				(replaced or state_list.exhausted)
			loop
				if (current_s.state.is_equal (state_list.item.state)) then
					state_list.replace (current_s)
					replaced := true
				else
					state_list.forth
				end
			end
			Result := state_list
		ensure
			result_not_void: Result /= void
			result_contains_given_state: across Result as curr_item some equal(curr_item.item.state, current_s) and curr_item.item.cost = current_s.cost end
		end

	frontier: LINKED_LIST [TUPLE [state: S; cost: REAL_32]]
			-- Priority queue contatining states

	explored: LINKED_LIST [TUPLE [state: S; cost: REAL_32]]
			-- List of the states that have been already visited, and the cost associated to them.
			-- Optional data structure which is useful to not visit the same states twice, unless a
			-- better path to them is found;

	successful_state: S
			-- Successful state

invariant
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	is_search_successful implies search_performed
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
