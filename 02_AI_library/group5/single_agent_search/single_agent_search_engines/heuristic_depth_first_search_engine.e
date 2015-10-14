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
	HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE[RULE -> ANY, S -> SEARCH_STATE[RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]

inherit
	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
		do
			-- TODO: add your code here
		ensure
			problem = other_problem
			not search_performed
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a heuristic depth first search
			-- strategy. 
			-- The result of the search is indicated in
			-- is_search_successful.
		do
			-- TODO: add your code here
		end

feature -- Status setting

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			-- TODO: add your code here
		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		do
			-- TODO: add your code here
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			-- TODO: add your code here
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

end
