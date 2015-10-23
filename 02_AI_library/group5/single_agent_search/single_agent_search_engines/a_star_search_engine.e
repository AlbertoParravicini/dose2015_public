note
	description: "[
		A* search engine. 
		This is a generic implementation of A* search algorithm, to be applied to search 
		problems. To use this engine, instantiate the class providing search states, rules
		for search states, and a search problem involving the search states and rules.
		A* performs a heuristic and cost-driven exhaustive search, where
		successor states are prioritized according both to cost and heuristic values.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	A_STAR_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> HEURISTIC_STATE_COST_SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature {NONE} -- Implementation attributes

	open: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the frontier, the states that can be expanded and visited, with their costs.
			-- The best item (i.e. the one of lowest cost) is removed at each iteration of the main loop, an evaluated;

	closed: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the states that have been already visited, and the cost associated to them.
			-- Optional data structure which is useful to not visit the same states twice, unless a
			-- better path to them is found; Re

	successful_state: S
			-- The successful state, the result of the search;

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- A_STAR_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
			other_problem.initial_state /= Void
		do
			set_problem (other_problem)
			mark_closed_states := false
			check_open_states := true
			reset_engine
		ensure
			problem_set: problem = other_problem
			closed_state_not_marked: mark_closed_states = false
			open_state_checked: check_open_states = true
			search_not_performed: not search_performed
		end

feature -- Search Execution

	perform_search
			-- Starts the search using an A*
			-- strategy. This search strategy prioritizes states according both to the cost
			-- of the path leading to them, and the heuristic values of states.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			current_state: S
			current_state_path_cost: REAL
			current_tuple: TUPLE [state: S; cost: REAL]
			current_successors: LINKED_LIST [S]
			useful_state: BOOLEAN
			best_index: INTEGER
		do
			create current_successors.make
			current_state := problem.initial_state
			current_state_path_cost := path_cost (current_state)
			current_tuple := [current_state, current_state_path_cost + total_cost (current_state)]
			open.extend (current_tuple)
			nr_of_visited_states := nr_of_visited_states + 1

				-- End if the first state is successful;
			if problem.is_successful (current_state) then
				is_search_successful := true
				successful_state := current_state
			end
			from
			until
				open.is_empty or is_search_successful = true
			loop
				current_successors.wipe_out


				-- Pick the most promising state (i.e the one with lowest cost) from the frontier
				-- and remove it from the "open" list;
				from
					best_index := 1
					open.start
					current_tuple := open.first
				until
					open.exhausted
				loop
					if open.item.cost < current_tuple.cost then
						current_tuple := open.item
						best_index := open.index
					end
					open.forth
				end
				current_state := current_tuple.state
				-- Calculate how far the current_state is from the start, optimization useful at a later stage;
				current_state_path_cost := path_cost (current_state)
				open.go_i_th (best_index)
				open.remove

					-- Add the current state to the list of visited states;
				if mark_closed_states = true then
					closed.extend (current_tuple)
				end
				nr_of_visited_states := nr_of_visited_states + 1

					-- End if the current state is successful;
				if problem.is_successful (current_state) then
					is_search_successful := true
					successful_state := current_state
				else
					current_successors.append (problem.get_successors (current_state))

						-- Examinate the successors of the current state;
					from
						current_successors.start
					until
						current_successors.exhausted or is_search_successful = true
					loop
						useful_state := false

						-- If "mark_closed_states" is set to true,
						-- check if the current successor was already visited with a higher cost:
						-- if so, replace it in the "closed" list; if the state was replaced,
						-- or if it is the first time it is visited,
						-- proceed to evaluate its presence in the "open" list;
						if mark_closed_states = true then
							useful_state := replace_list_state (closed, current_successors.item)
						end

						-- If "check_open_states" is set to true,
						-- check if the current successor is already in the queue (the "open" list) with a higher cost:
						-- if so, replace it in the "open" list; if it is not present, add it;
						if check_open_states = true then
							if mark_closed_states = false or (mark_closed_states = true and useful_state = true) then
								useful_state := replace_list_state (open, current_successors.item)
							end
						end

						-- Add the current successor to the open list, along with its cost;
						if (mark_closed_states = false or useful_state = true) and (check_open_states = false or useful_state = true) then
							open.extend ([current_successors.item, current_state_path_cost + total_cost (current_successors.item)])
						end
						current_successors.forth
					end -- End of loop on successors;


					-- If both the "closed" list and the "open" list are checked to see if the state was already present
					-- with higher cost, it is possible to test the successfulness of the current successors without losing the
					-- optimality of the solution;
--					if mark_closed_states = true and check_open_states = true then
--						across
--							current_successors as curr_succ
--						loop
--							if problem.is_successful (curr_succ.item) then
--								is_search_successful := true
--								successful_state := curr_succ.item
--							end
--						end
--					end
				end
			end -- End of the main loop;
			search_performed := true
		ensure then
			unsuccessful_state_with_non_empty_queue: (not is_search_successful) implies open.is_empty
			no_visited_states: nr_of_visited_states > old nr_of_visited_states
			at_least_one_state_visited: mark_closed_states = true implies (closed.count > old closed.count)
			search_successful_nec: is_search_successful implies problem.is_successful (successful_state)
			search_successful_suc: (search_performed = true and successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful
			routine_invariant: old check_open_states = check_open_states and old mark_closed_states = mark_closed_states
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := false
			is_search_successful := false
			create open.make
			create closed.make
			open.compare_objects
			closed.compare_objects
			nr_of_visited_states := 0
		ensure then
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
			open_reinitialized: open /= void and then open.count = 0
			closed_reinitialized: closed /= void and then closed.count = 0
			open_uses_equal: open.object_comparison = true
			closed_uses_equal: closed.object_comparison = true
			visited_states_reset: nr_of_visited_states = 0
			routine_invariant: old check_open_states = check_open_states and old mark_closed_states = mark_closed_states
		end

feature -- Status Setting

	set_mark_closed_state (a_choice: BOOLEAN)
			-- Set whether to memorize the visited states or not; when a new state is evaluated,
			-- it is checked if the state was already visited before at a higher cost: if so,
			-- the old state and its cost are replaced with the new one.
			-- It is recommended to have this setting activated if the state space cardinality is rather small;
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			mark_closed_states := a_choice
			if (closed /= void) then
				closed.wipe_out
			end
		ensure
			mark_closed_set: mark_closed_states = a_choice
			empty_closed_states: closed.count = 0
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old check_open_states = check_open_states
		end

	set_check_open_state (a_choice: BOOLEAN)
			-- Set whether to memorize the visited states or not; when a new state is evaluated,
			-- it is checked if the state was already put in the queue with a higher cost: if so,
			-- the old state and its cost are replaced with the new one.
			-- It is recommended to have this setting activated if the state space cardinality is rather small;
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			check_open_states := a_choice
		ensure
			check_open_states_set: check_open_states = a_choice
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_closed_states = mark_closed_states
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			list: LINKED_LIST [S]
		do
			if (is_search_successful) then
					-- Starting from the successful state, get the parent of each state
					--		by travelling backwards in the hierarchy, and add it to a list
				from
					current_state := obtained_solution
					create list.make
					list.put_front (current_state)
				until
					current_state.parent = void
				loop
					list.put_front (current_state.parent)
					current_state := current_state.parent
				end
				Result := list
			end
		ensure then
				--First member of the list is the starting state, ending position of the list is the searched state
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_closed_states = mark_closed_states and old check_open_states = check_open_states
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
			routine_invariant: old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_closed_states = mark_closed_states and old check_open_states = check_open_states
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

	mark_closed_states: BOOLEAN
			-- Memorize the visited states in a list, then when a new state is generated, check if it was already visited:
			-- if it was visited at a higher cost, replace it with the new state and the new cost;

	check_open_states: BOOLEAN
			-- When a new state is generated, check if it is already in the queue:
			-- if it is present with an higher cost, replace it with the new state and the new cost;

feature {NONE} -- Implementation routines / procedures

	path_cost (a_state: S): REAL
			-- Calculate the cost of "a_state" from the starting state;
		require
			a_state_not_null: a_state /= void
		local
			current_cost: REAL
			current_state: S
			first_state_found: BOOLEAN
		do
			from
				current_cost := 0
				current_state := a_state
			until
				first_state_found = true
			loop
				Result := Result + problem.cost (current_state)
				if current_state.parent = void then
					first_state_found := true
				else
					current_state := current_state.parent
				end
			end
		ensure
			Result >= 0
		end

	total_cost (a_state: S): REAL
			-- Calculate the A* cost of a state as f(n) = d(n) + h(n),
			--  i.e. the path cost to "a_state" from the parent of "a_state"
			--	+ the heuristic cost from "a_state" to the goal;
		require
			a_state_not_null: a_state /= void
		do
			Result := problem.cost (a_state) + problem.heuristic_value (a_state)
		ensure
			correct_result: Result = problem.cost (a_state) + problem.heuristic_value (a_state)
			result_non_negative: Result >= 0
		end

	replace_list_state (a_list: LINKED_LIST [TUPLE [state: S; cost: REAL]]; a_state: S): BOOLEAN
			-- Check if a state is already present in closed with a lower cost, if so replace it;
			-- Returns true if the state was substituted or if the state wasn't found;
		require
			a_list /= void
			a_state /= void
		local
			state_substituted: BOOLEAN
			a_state_cost: REAL
			already_present: BOOLEAN
		do
			from
				state_substituted := false
				a_list.start
				a_state_cost := path_cost (a_state) + total_cost (a_state)
				already_present := false
				a_list.compare_objects
			until
				a_list.exhausted or state_substituted = true
			loop
				if equal (a_list.item.state, a_state) then
					already_present := true
					if a_list.item.cost > a_state_cost then
						a_list.replace ([a_state, a_state_cost])
						state_substituted := true
					end
				end
				a_list.forth
			end
			Result := not already_present or state_substituted
		ensure
			a_list_size_not_changed: old a_list.count = a_list.count
			state_already_present_with_higher_cost: Result = false implies across a_list as a_tuple some equal (a_tuple.item.state, a_state) end
		end

invariant
	open_is_void: open /= void
	closed_is_void: closed /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
