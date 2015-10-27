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
	BEST_FIRST_SEARCH_ENGINE[RULE -> ANY, S -> SEARCH_STATE[RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]

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
		do
			set_problem (other_problem)
			search_performed := false
			is_search_successful := false
		ensure

			make_parameter_value_error: problem = other_problem
			search_performed_value_error: not search_performed
			is_search_successful_value_error: not is_search_successful
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a best first search
			-- strategy.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
				current_state: S
				open: LINKED_LIST[S]
		do
			create open.make
			open.extend(problem.initial_state)
			from
				open.start
			until
				is_search_successful or open.is_empty
			loop
				current_state := best_state(open)
				if problem.is_successful(current_state) then
					successful_state := current_state
					is_search_successful := True
				else
					open.start
					open.prune (current_state)
					open.append (problem.get_successors (current_state))
				end
			end
			search_performed := True
		end

feature -- add functionality necessary

	best_state(state_list : LINKED_LIST[S]) : S
			--given a list of states, returns the state with the best heuristic function
		do
			state_list.start
			Result := state_list.item
			state_list.forth
			from
			until
				state_list.exhausted
			loop
				if problem.heuristic_value(Result) > problem.heuristic_value(state_list.item) then
					Result := state_list.item
				end
				state_list.forth
			end
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			is_search_successful := false
		ensure then
			is_search_successful_value_error: not is_search_successful
		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
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

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

	feature {NONE}

	successful_state: S
			-- Searched state

	invariant
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)

end
