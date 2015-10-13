note
	description: "Abstract class which defines the basic elements necessary for implementing a search engine for adversary search problems."
	author: "Nazareno Aguirre"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ADVERSARY_SEARCH_ENGINE[RULE -> ANY, S -> ADVERSARY_SEARCH_STATE[RULE], P -> ADVERSARY_SEARCH_PROBLEM[RULE, S]]



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

	perform_search (initial_state: S)
		-- Starts the search on the associated search problem.
		-- Search starts from the problem's initial state, using the
		-- problem's declared rules for reconfiguration.
	require
		not search_performed
		initial_state /= Void
	deferred
	ensure
		search_performed
	end

	set_max_depth(new_max_depth: INTEGER)
			-- Sets the maximum depth to be used for search.
		deferred
		end



feature -- Status report

	obtained_value: INTEGER
		-- Returns the value of the most promising successor,
		-- obtained as a result of the search.
	require
		search_performed
	deferred
	end

	obtained_successor: S
		-- Returns the most promising successor,
		-- obtained as a result of the search.
	require
		search_performed
	deferred
	end


	search_performed: BOOLEAN
		-- Has the search been performed?

	max_depth: INTEGER
		-- the maximum depth used for the search

feature {NONE} -- Implementation

	problem: P
		-- Reference to the problem to which the engine is associated
		-- to.


end

