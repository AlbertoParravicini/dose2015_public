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
			other_problem /= Void
		do
			-- TODO: add your code here
		ensure
			problem = other_problem
			not search_performed
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a depth first search
			-- strategy. This search strategy performs cycle checking.
			-- When a cycle is detected, the search is forced to backtrack.
			-- The result of the search is indicated in
			-- is_search_successful.
		do
			-- TODO: add your code here
		end

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
