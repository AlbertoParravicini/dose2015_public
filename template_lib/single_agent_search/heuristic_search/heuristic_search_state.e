note
	description: "[
		Abstract states for search based algorithmic solutions.
	    HEURISTIC_SEARCH_STATE is parameterized with a class RULE, used to capture
		the rule applied to reach a given state. A heuristic search state is a 
		comparable search state.
		]"
	library: "Eiffel AI Search Library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	HEURISTIC_SEARCH_STATE[RULE -> ANY]

inherit
	SEARCH_STATE[RULE]
	COMPARABLE
		undefine
			is_equal
		end


note
	copyright: "Copyright (c) 2015"
	license: "MIT License (see http://...)"

end
