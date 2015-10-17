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
			other_problem /= Void
		do
				-- TODO: add your code here
			set_problem (other_problem)
			create stack.make
			create visited_states.make
			stack.put (0, problem.initial_state)
			search_performed := false
			is_search_successful := false
			set_max_depth (0)
			nr_of_visited_states := 0
		ensure
			problem = other_problem
			not search_performed
			stack.count = 1
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
		do
				-- TODO: add your code here
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
				end
				if (not is_search_successful) then
						-- Have I reached max depth?
					if (not (current_depth >= maximum_depth)) then
							-- Get list of successors from current state
						current_successors.append (problem.get_successors (current_state))
						from
							current_successors.start
						until
							current_successors.exhausted or is_search_successful
						loop
								-- Add new states to stack if they are new state, check if they are succesfull
							if (not visited_states.has (current_successors.item)) then
									-- If I haven't visited this state already
								if (problem.is_successful (current_successors.item)) then
										-- If it is the desired state, set the search successfull
									successful_state := current_successors.item
									is_search_successful := true
								else
										-- Add the state to the stack
									stack.put ([current_depth + 1, current_successors.item])
								end
							end
							current_successors.forth
						end
					end
					visited_states.extend (current_state)
					nr_of_visited_states := nr_of_visited_states + 1
				end
			end
			search_performed := true
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
				-- TODO: add your code here
			create stack.make
			create visited_states.make
			stack.put (0, problem.initial_state)
			search_performed := false
			is_search_successful := false
			set_max_depth (0)
			nr_of_visited_states := 0
		end

feature -- Status setting

	set_max_depth (new_bound: INTEGER)
			-- Sets the max depth bound to new_bound
		require
			new_bound >= 0
		do
				-- TODO: add your code here
			maximum_depth := new_bound
		ensure
			maximum_depth = new_bound
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
			--TODO: postconditions
			--First member of the list is the starting state, ending position of the list is the searched state
			first_state_is_consistent: Result = void or else Result.first = problem.initial_state
			last_state_is_consistent: Result = void or else problem.is_successful (Result.last)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if (is_search_successful) then
				Result := successful_state
			end
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	maximum_depth: INTEGER
			-- Max depth employed for the bounded depth first search.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

feature

	stack: LINKED_STACK [TUPLE [depth: INTEGER; state: S]]
			-- Where the states will be saved

	visited_states: LINKED_LIST [S]
			-- States that have been visited

	successful_state: S
			-- Searched state

end
