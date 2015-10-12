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
	HEURISTIC_SEARCH_PROBLEM [RULE -> ANY, S -> HEURISTIC_SEARCH_STATE[RULE]]

inherit
	SEARCH_PROBLEM [RULE,S]


end
