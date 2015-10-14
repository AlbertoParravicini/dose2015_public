note
	description: "[
				Iterative deepening search engine. This is a generic implementation of iterative deepening
				algorithm, to be applied to search problems. To use this engine, instantiate the class 
				providing search states, rules for search states, and a search problem involving the
				search states and rules.
				Iterative deepening performs an unbounded search, based on iterating bounded depth first 
				searches with increasingly deeper maximum depths.
				]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"


class
	ITERATIVE_DEEPENING_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- ITERATIVE_DEEPENING_SEARCH_ENGINE with a problem
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
			-- Starts the search using iterative deepening
			-- strategy. This search strategy is unbounded.
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

feature -- Status setting

	set_step (new_step: INTEGER)
			-- Sets the step used to increase the depth in each iteration of
			-- bounded depth first search
		require
			new_step >= 1
		do
			-- TODO: add your code here
		ensure
			step = new_step
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

	step: INTEGER
			-- Step used to increase max. depth in subsequent bounded dfs searches.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.


end
