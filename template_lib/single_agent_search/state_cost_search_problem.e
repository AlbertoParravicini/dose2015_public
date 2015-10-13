note
	description: "[
				Abstract class characterising abstract search problems based on state costs.
				STATE_COST_SEARCH_PROBLEM is parameterized with a class RULE, used to capture
				the rule applied to reach a given state, and a SEARCH_STATE[RULE], 
				capturing the states involved in the search problem.
				]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 10:39:00 -0300$"
	revision: "$Revision: 0.1 $"


deferred class
	STATE_COST_SEARCH_PROBLEM [RULE -> ANY, S -> SEARCH_STATE[RULE]]

inherit
	SEARCH_PROBLEM [RULE,S]

feature {ANY} -- Search related routines

	cost (s: S): REAL
			-- Given a state s, it evaluates the cost of reaching that state.
			-- Cost will usually be associated with the rule that led to the
			-- state. Routine returns a real number value, which should be an
			-- approximation of the cost of the rule performed leading to s.
		require
			s /= Void
		deferred
		end

end
