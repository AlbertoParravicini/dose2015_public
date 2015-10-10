note
	description: "[
				Abstract class characterising abstract heuristic search problems.
				HEURISTIC_SEARCH_PROBLEM is parameterized with a class RULE, used to capture
				the rule applied to reach a given state, and A HEURISTIC_SEARCH_STATE[RULE], 
				capturing the states involved in the search problem.
				Heuristic search problems are search problems that can produce search values
				for heuristic search states.
				]"
	library: "Eiffel AI Search Library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 10:39:00 -0300$"
	revision: "$Revision: 0.1 $"


deferred class
	HEURISTIC_SEARCH_PROBLEM [RULE -> ANY, S -> HEURISTIC_SEARCH_STATE[RULE]]

inherit
	SEARCH_PROBLEM [RULE,S]

feature -- State space routines

	heuristic_value (s: S): REAL
			-- Given a state s, it evaluates the problem's heuristic function
			-- on the state. It returns a real number value, which should be an
			-- approximation of the length of the shortest path from s to a
			-- successful state.
		require
			s /= Void
		deferred
		end

note
	copyright: "Copyright (c) 2015"
	license: "MIT License (see http://...)"

end
