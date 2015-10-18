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

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- A_STAR_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
		do
			set_problem (other_problem)
			reset_engine
		ensure
			problem_set: problem = other_problem
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
			current_tuple: TUPLE[state: S; cost: REAL]
			current_successors: LINKED_LIST[S]
			already_in_close: BOOLEAN
		do
			create current_successors.make
			current_state := problem.initial_state
			current_state_path_cost := path_cost (current_state)
			current_tuple := [current_state, current_state_path_cost + total_cost(current_state)]
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
				-- Sort the "open" list, so that the state with the lowest cost, the most promising, is first;
				sort_list_with_tuples (open)

				-- Get the first state (the most promising) from the "open" list;
				current_tuple := open.first
				current_state := current_tuple.state
					-- Calculate how far the current_state is from the start, optimization useful at a later stage;
				current_state_path_cost := path_cost(current_state)
				open.go_i_th (1)
				open.remove

				-- Add the current state to the list of visited states;
				closed.extend (current_tuple)
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
						already_in_close := false
						-- Check if the current successor was already visited with a higher cost:
						--		if so, replace it in the "closed" list;
						already_in_close := replace_list_state (closed, current_successors.item)
						if already_in_close = true then
							if problem.is_successful (current_successors.item) then
								is_search_successful := true
								successful_state := current_successors.item
							else
								-- Check if the current successor is already in the queue with a higher cost:
								--		if so, replace it in the "open" list; if it is not present, add it;

								already_in_close := false
								already_in_close := replace_list_state (open, current_successors.item)
								if already_in_close = true then
									open.extend ([current_successors.item, current_state_path_cost + total_cost(current_successors.item)])
								end

							end
						end
						current_successors.forth
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
			create open.make
			create closed.make
			open.compare_objects
			closed.compare_objects
			nr_of_visited_states := 0
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
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE} -- Implementation routines / procedures

	path_cost (a_state: S): REAL
			-- Calculate the cost of "a_state" from the starting state
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
		end

	total_cost (a_state: S): REAL
			-- Calculate the A* cost of a state,
			-- 		i.e. the path cost to "a_state" from the parent of "a_state"
			--			+ the heuristic cost from "a_state" to the goal;
		do
			Result := problem.cost (a_state) + problem.heuristic_value (a_state)
		end

	replace_list_state (list: LINKED_LIST[TUPLE[state: S; cost: REAL]]; a_state: S): BOOLEAN
			-- Check if a state is already present in closed with a lower cost, if so replace it;
		local
			state_substituted: BOOLEAN
			a_state_cost: REAL
			already_present: BOOLEAN
		do
			from
				state_substituted := false
				list.start
				a_state_cost := path_cost (a_state) + total_cost (a_state)
				already_present := false
			until
				list.exhausted or state_substituted = true
			loop
				if equal (list.item.state, a_state) then
					already_present := true
					if list.item.cost > a_state_cost then
						list.replace ([a_state, a_state_cost])
						state_substituted := true
					end
				end
				list.forth
			end
			Result := not already_present or state_substituted
		ensure
			list_size_not_changed: old list.count = list.count
		end


		sort_list_with_tuples (my_list: LIST [TUPLE [state: S; value: REAL]])
			-- Sorts the given list from the state with the lowest value to the one with the highest value
			-- insertion sort;
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
		end



feature {NONE} -- Implementation attributes

	open: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the frontier, the states that can be expanded and visited, with their costs;

	closed: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the states that have been already visited, and the minimum cost associated to them;

	successful_state: S
			-- The successful state, the result of the search;

end
