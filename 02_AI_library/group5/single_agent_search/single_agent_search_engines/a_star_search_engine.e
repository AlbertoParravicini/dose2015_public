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
		do
				-- TODO: add your code here
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
			-- Calculate the cost of state s from the starting state
		local
			current_cost: REAL
			current_state: S
		do
			from
				current_cost := 0
				current_state := a_state
			until
				a_state = void
			loop
				Result := Result + problem.cost (current_state)
				current_state := current_state.parent
			end
		end

	total_cost (a_state: S): REAL
			-- Calculate the A* cost of a state,
			-- 		i.e. the path cost to "state" + the heuristic cost from "state" to the goal
		do
			Result := path_cost (a_state) + problem.heuristic_value (a_state)
		end

	--TODO: order the open list

	already_seen_with_lower_cost (a_state: S): BOOLEAN
		-- Check if a state is already present in closed with a lower cost, if so replace it
		local
			state_substituted: BOOLEAN
		do
			state_substituted := false

			from
				closed.start
			until
				closed.exhausted or state_substituted = true
			loop
				if (equal (closed.item.state, a_state) and (closed.item.cost > total_cost(a_state))) then
					closed.replace ([a_state, total_cost (a_state)])
				end
			end
		ensure
			closed_size_not_changed: closed.count = old closed.count
		end

feature {NONE} -- Implementation attributes

	open: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the frontier, the states that can be expanded and visited, with their costs

	closed: LINKED_LIST [TUPLE [state: S; cost: REAL]]
			-- List of the states that have been already visited, and the minimum cost associated to them

	successful_state: S
			-- the successful state, the result of the search

end
