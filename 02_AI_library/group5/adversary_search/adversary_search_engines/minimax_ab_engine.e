note
	description: "[
		Minimax adversary search engine, with alpha-beta pruning. This is a generic implementation of
		minimax alpha-beta, that can be applied to any adversary search problem. The engine is 
		parameterized with an adversary search problem, the adversary search state for the problem, 
		and the rules associated with state change.
		]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	MINIMAX_AB_ENGINE [RULE -> ANY, S -> ADVERSARY_SEARCH_STATE [RULE], P -> ADVERSARY_SEARCH_PROBLEM [RULE, S]]

inherit
	ADVERSARY_SEARCH_ENGINE [RULE, S, P]

create
	make, make_with_depth

feature

	make (new_problem: P)
		require
			new_problem /= Void
		do
			-- TODO: add your code here
		end

	make_with_depth (new_problem: P; new_max_depth: INTEGER)
		require
			new_problem /= Void
			new_max_depth >= 0
		do
			-- TODO: add your code here
		end

feature

	reset_engine
	do
			-- TODO: add your code here
	end

	perform_search (initial_state: S)
	do
			-- TODO: add your code here
	end

	set_max_depth (new_max_depth: INTEGER)
	do
			-- TODO: add your code here
	end

	obtained_value: INTEGER

	obtained_successor: S


end
