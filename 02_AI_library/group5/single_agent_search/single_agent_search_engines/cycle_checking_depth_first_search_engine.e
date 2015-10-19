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
			make_parameter_error: other_problem /= Void
		do
			set_problem(other_problem)
			create stack.make
			create visited_states.make
			stack.put( problem.initial_state)
			search_performed:=false
			is_search_successful:=false
			nr_of_visited_states:=0
			stack.compare_objects
			visited_states.compare_objects
		ensure
			make_parameter_value_error: problem = other_problem
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
			stack_value_error: stack /= void and then stack.count = 1
			visited_states_value_error: visited_states /= void and then visited_states.count = 0
			nr_of_visited_states_value_error: nr_of_visited_states = 0
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
			current_successors: LINKED_LIST[S]
			current_partial_path: LIST[S]
		do
			from

			until
				is_search_successful or stack.is_empty
			loop

				current_state:= stack.item
				create current_successors.make
				stack.remove
				-- is it a successful state?
				if (current_state /= void and then problem.is_successful(current_state)) then
					successful_state:= current_state
					is_search_successful:=true
					visited_states.extend (current_state)
					nr_of_visited_states := nr_of_visited_states + 1
				end
				if (not is_search_successful) then
					-- No constraints on maximum depth
					current_successors.append(problem.get_successors(current_state))
					-- Set initial state as visited
					visited_states.extend(current_state)
					nr_of_visited_states:= nr_of_visited_states+1
					from
						current_successors.start
					until
						current_successors.exhausted
					loop
						-- For each state:
						-- 1) check if already visited
						-- 2) check if successful
						-- 3) if successful, set the result
						current_partial_path:=partial_path (current_state)
						current_partial_path.compare_objects
						if (not current_partial_path.has (current_successors.item)) then
							-- The state hasn't been visited
							if (problem.is_successful(current_successors.item)) then
								-- If it is a successful state
								visited_states.extend (current_successors.item)
								nr_of_visited_states := nr_of_visited_states +1
								successful_state := current_successors.item
								is_search_successful:=true
							else
								-- Add the state to the stack, in order to visit it later, if it isn't already in stack
								--if (not stack.has (current_successors.item)) then
									stack.put(current_successors.item)
								--else
									-- DEBUG
									--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Cycle found.%N")
								--end
								-- Debug
								--print("stack: "+stack.count.out+" nr_of_visited_states: "+nr_of_visited_states.out+"%N")
							end
						else
							--Debug
							--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Cycle found.%N")
						end
						current_successors.forth
					end
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
			create visited_states.make
			stack.put (problem.initial_state)
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
		ensure then
			is_search_successful_value_error: not is_search_successful
			stack_value_error: stack /= void and then stack.count = 1
			visited_states_value_error: visited_states /= void and then visited_states.count = 0
			nr_of_visited_states_non_reset: nr_of_visited_states = 0
		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
			-- If there is no path, an empty list is returned
		local
			current_state: S
			path: LINKED_LIST[S]
		do
			from
				current_state:=obtained_solution
				create path.make
			until
				current_state=void
			loop
				path.put_front(current_state)
				current_state:=current_state.parent
			end
			Result:=path
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
				Result:=successful_state
			end
		ensure then
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature {NONE}
	-- Local variables
	stack: LINKED_STACK [S]
		-- Stack of the states that will be visited, LIFO
	visited_states: LINKED_LIST[S]
		-- List of all the states that have been visited
	successful_state: S
		-- Searched state
	partial_path(state: S): LIST [S]
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
	-- List of all class invariants
	stack_is_void: stack /= void
	visited_states_is_void: visited_states /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)
	successful_state_not_belonging_to_visited_states: is_search_successful implies visited_states.has (successful_state)

end
