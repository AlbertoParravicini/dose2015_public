note
	description: "Summary description for {SOLITAIRE_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_PROBLEM

inherit

	HEURISTIC_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

	STATE_COST_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

	HEURISTIC_STATE_COST_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

create
	make, make_with_initial_state

feature
	-- Initialization

	make
			-- Default, generates a random init state
		do
			create initial_state.make
		end

	make_with_initial_state (new_state: SOLITAIRE_STATE)
			-- Provided values, assigns to a variable
		do
			initial_state := new_state
		end

feature

	initial_state: SOLITAIRE_STATE

	get_successors (state: SOLITAIRE_STATE): LIST [SOLITAIRE_STATE]
		local
			successors: LINKED_LIST [SOLITAIRE_STATE]
			successor: SOLITAIRE_STATE
			rule: TUPLE [ACTION_ROTATE, INTEGER]
		do
				-- To be implemented
			create successors.make

				-- Rotate clockwise

				--FIXTHIS

				rule := [create {ACTION_ROTATE}.make((create {ENUM_ROTATE}).clockwise), state.selected_hole]
				-- TODO: get map from state and modify it
				-- TODO: create new state setting parent and other things
			create successor.make
			successors.extend (successor)

				-- Rotate counter-clockwise
			create successor.make

				rule:= [create {ACTION_ROTATE}.make((create {ENUM_ROTATE}).counter_clockwise), state.selected_hole]
				-- TODO: get map from state and modify it
				-- TODO: create new state setting parent and other things
			successors.extend (successor)

				-- Return
			Result := successors
		end

	is_successful (state: SOLITAIRE_STATE): BOOLEAN
		-- Is the state successful, i.e. is the player score equal to the number of stones in the game?
		do
			Result := state.player.score = {GAME_CONSTANTS}.num_of_stones
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
end
