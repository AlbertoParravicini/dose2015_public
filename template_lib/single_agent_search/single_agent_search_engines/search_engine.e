note
	description: "[
				Abstract class characterising abstract search engines.
				SEARCH_ENGINE is parameterized with a search problem (to which it is applied),
				a search state (associated to the search problem), and a "rule" class that
				captures the rules that produce reconfigurations from a state to its successors.
				]"
	library: "Eiffel AI Search Library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	SEARCH_ENGINE[RULE -> ANY, S -> SEARCH_STATE[RULE], P -> SEARCH_PROBLEM[RULE, S]]

feature -- Status setting

	reset_engine
		-- Resets the engine so a new search can be performed
		-- with it.
	deferred
	ensure
		not search_performed
	end

	set_problem(p: P)
		-- Sets a problem for the search be operate on.
	require
		p /= Void
	do
		problem := p
	end

	perform_search
		-- Starts the search on the associated search problem.
		-- Search starts from the problem's initial state, using the
		-- problem's declared rules for reconfiguration.
	require
		not search_performed
	deferred
	ensure
		search_performed
	end


feature -- Status report

	obtained_solution: detachable S
		-- Returns the solution obtained as a result of the
		-- search. Obtained solution can be null if no solution
		-- has been found.
	require
		search_performed
	deferred
	end

	path_to_obtained_solution: LIST[S]
		-- Returns the path to the solution obtained as a result
		-- of the search. Path includes last (successful) state.
		-- Path can be empty, if no solution was found.
	require
		search_performed
	deferred
	end


	is_search_successful: BOOLEAN
		-- Was the last search successful?
	require
		search_performed
	deferred
	end



	search_performed: BOOLEAN
		-- Has the search been performed?


feature {NONE} -- Implementation

	problem: P
		-- Reference to the problem to which the engine is associated
		-- to.


end

