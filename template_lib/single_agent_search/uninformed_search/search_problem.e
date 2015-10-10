note
	description: "[
				Abstract class characterising abstract search problems.
				SEARCH_PROBLEM is parameterized with a class RULE, used to capture
				the rule applied to reach a given state, and SEARCH_STATE[RULE], 
				capturing the states involved in the search problem.
				]"
	library: "Eiffel AI Search Library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 10:39:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	SEARCH_PROBLEM [RULE -> ANY, S -> SEARCH_STATE[RULE]]

feature -- State space routines

	initial_state: S
			-- Returns the initial state of the problem,
			-- where the search should start.
		deferred
		ensure
			Result /= Void
		end

	get_successors (s: S): LIST [S]
			-- Given a search state s, it produces its list of
			-- successor states for the search. This routine can be
			-- thought of as the joint application of all
			-- advance/reconfiguration rules on state s
		require
			s /= Void
		deferred
		ensure
			Result /= Void
		end

	is_successful (s: S): BOOLEAN
			-- Given a state s, it decides whether the state is a
			-- success state, i.e., if it is one of the target states
			-- of the search.
		require
			s /= Void
		deferred
		end

note
	copyright: "Copyright (c) 2015"
	license: "MIT License (see http://...)"

end
