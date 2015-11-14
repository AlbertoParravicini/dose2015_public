note
	description: "Summary description for {SOLITAIRE_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_PROBLEM

inherit

	HEURISTIC_SEARCH_PROBLEM [STRING, SOLITAIRE_STATE]

	STATE_COST_SEARCH_PROBLEM [STRING, SOLITAIRE_STATE]

	HEURISTIC_STATE_COST_SEARCH_PROBLEM [STRING, SOLITAIRE_STATE]

create
	make, make_with_initial_state

feature
	-- Initialization

	make
			-- Default, generates a random init state
		do
			create init_state.make
		end

	make_with_initial_state (new_state: SOLITAIRE_STATE)
			-- Provided values, assigns to a variable
		do
			init_state := new_state
		end

feature

	initial_state: SOLITAIRE_STATE
		do
			Result := init_state
		end

	get_successors (state: SOLITAIRE_STATE): LIST [SOLITAIRE_STATE]
		do
			-- To be implemented
		end

	is_successful(state: SOLITAIRE_STATE) : BOOLEAN
		do
			-- To be implemented
		end

feature
	-- Heuristic search related routines

	heuristic_value (state: SOLITAIRE_STATE): REAL
		do
			-- To be implemented

		end

feature
	-- State cost realted routines

	cost (state: SOLITAIRE_STATE): REAL
			-- Cost of rule leading to current state
		do
			if state.parent = void then
				Result := 0
			else
				Result := 1
			end
		end

feature
	-- Variables

	init_state: SOLITAIRE_STATE
			-- Initial state

end
