note
	description: "Summary description for {MINIMAX_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINIMAX_ENGINE [RULE -> ANY, S -> ADVERSARY_SEARCH_STATE [RULE], P -> ADVERSARY_SEARCH_PROBLEM [RULE, S]]

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
