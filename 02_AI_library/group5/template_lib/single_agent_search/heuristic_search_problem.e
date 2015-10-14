note
	description: "[
		Abstract class characterising abstract heuristic search problems.
		HEURISTIC_SEARCH_PROBLEM is parameterized with a class RULE, used to capture
		the rule applied to reach a given state, and A HEURISTIC_SEARCH_STATE[RULE], 
		capturing the states involved in the search problem.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 10:39:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	HEURISTIC_SEARCH_PROBLEM [RULE -> ANY, S -> SEARCH_STATE [RULE]]

inherit

	SEARCH_PROBLEM [RULE, S]

feature {ANY} -- Search related routines

	heuristic_value (s: S): REAL
			-- Given a state s, it evaluates the problem's heuristic function
			-- on the state. It returns a real number value, which should be an
			-- approximation of the length of the shortest path from s to a
			-- successful state.
			-- That is, the smaller the value, the fitter the state.
		require
			s /= Void
		deferred
		end

end
