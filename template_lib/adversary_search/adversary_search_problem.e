note
	description: "Abstract class characterising abstract search problems."
	library: "Eiffel AI Search Library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "N. Aguirre, R. Degiovanni, S. Gutierrez, N. Ricci"
	date: "$Date: 2015-08-22 10:39:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	ADVERSARY_SEARCH_PROBLEM [RULE -> ANY, S -> ADVERSARY_SEARCH_STATE[RULE]]

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

	is_end (s: S): BOOLEAN
			-- Given a state s, it decides whether the state is an
			-- end state, i.e., if game cannot proceed from it.
		require
			s /= Void
		deferred
		end


	value (s: S): INTEGER
			-- Given a state s, it provides the (estimated) value for this state.
			-- This value, determined statically, is an estimation of how good the
			-- state is on min/max values (intuitively, the better the value for min
			-- the closer it should be to min_value, and the better the value for max
			-- the closer it should be to max_value).
		deferred
		end


  	min_value: INTEGER
  			-- Indicates the least possible value for a state in the problem.
	 		-- Together with max_value, it determines an interval in which
	 		-- values for states must range.
  		deferred
   		end


  	max_value: INTEGER
  			-- Indicates the greatest possible value for a state in the problem.
	 		-- Together with min_value, it determines an interval in which
	 		-- values for states must range.
   		deferred
   		end


note
	copyright: "Copyright (c) 2015, UNRC"
	license: "MIT License (see http://...)"
	source: "[
		Dpto. de Computacion, FCEFQyN
		Universidad Nacional de Rio Cuarto
		Ruta Nacional No. 36 Km 601
		Rio Cuarto (5800), Cordoba, Argentina
		Telephone +54 358 4676235
	]"

end
