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
			--rule: TUPLE [ACTION_ROTATE, INTEGER]
			current_selection: INTEGER
			current_state: SOLITAIRE_STATE
			current_stones: INTEGER
		do
--			create successors.make

--			if(state.selected_hole = -1) then
--				-- No first hole has been selected
--				from
--					current_selection:=1
--				until
--					current_selection>{GAME_CONSTANTS}.num_of_buckets
--				loop
--					create current_state.make
--					current_state.set_selected_hole (current_selection)
--					current_state.set_map (state.map)
--					successors.append (get_successors (current_state))
--				end -- End Loop
--			else
--				-- First hole has been selected

--				------------------------------------------------------------------------------------
--				-- How it works:
--				-- 1) empty the selected_hole, because it is the hole where the rule is applied
--				-- 2) according to cw / ccw rule, calculate the new selected_hole
--				-- 3) drop a stone and repeat
--				-- 4) if the selected hole is a special one (next to a store),
--				--    check the number of stones left and see what to do
--				------------------------------------------------------------------------------------

--				-- Rotate clockwise
--				create successor.make_from_parent_and_rule (state, [create {ACTION_ROTATE}.make((create {ENUM_ROTATE}).clockwise), state.selected_hole], deep_copy(state.map), state.selected_hole)
--				-- Change successor map and selected_hole
--				from
--					current_stones:=successor.map.get_bucket_value (successor.selected_hole)
--					successor.map.clear_bucket (state.selected_hole)
--				until
--					current_stones = 0
--				loop
--					if((successor.selected_hole <= {GAME_CONSTANTS}.num_of_buckets) and (successor.selected_hole >( ({GAME_CONSTANTS}.num_of_buckets / 2)+1))) then
--						-- Example: 7<selected_hole<=12
--						-- first update the position and then change the value of the position
--						successor.selected_hole:=successor.selected_hole-1
--						successor.map.add_token_to_store (successor.selected_hole)
--						current_stones := current_stones - 1
--					else if (successor.selected_hole = (({GAME_CONSTANTS}.num_of_buckets / 2) +1)) then
--						-- Example: selected_hole = 7
--						if(current_stones = 1) then
--							-- Only 1 stone left
--							successor.map.add_token_to_store (1)
--							current_stones := current_stones - 1
--						else
--							-- More than 1 stone left
--							successor.selected_hole:=1
--							successor.map.add_token_to_bucket (successor.selected_hole)
--							current_stones := current_stones - 1
--						end -- End inner if
--					else if ((successor.selected_hole >= 1) and ( successor.selected_hole < ({GAME_CONSTANTS}.num_of_buckets / 2))) then
--						-- Example: 1<= selected_hole < 6
--						successor.selected_hole:=successor.selected_hole+1
--						successor.map.add_token_to_store (successor.selected_hole)
--						current_stones := current_stones - 1
--					else if ( successor.selected_hole = ({GAME_CONSTANTS}.num_of_buckets /2)) then
--						-- Example: selected_hole = 6
--						if(current_stones = 1) then
--							-- Only 1 stone left
--							successor.map.add_token_to_store (2)
--							current_stones := current_stones - 1
--						else
--							-- More than 1 stone left
--							successor.selected_hole:={GAME_CONSTANTS}.num_of_buckets
--							successor.map.add_token_to_bucket (successor.selected_hole)
--							current_stones := current_stones - 1
--						end -- End inner if
--					end -- End multiple if
--				end -- End CW loop
--				-- Check if game over
--				successor.game_over:= is_game_over(successor)
--				-- Add successor to successors
--				successors.extend (successor)

--				-- Rotate counter-clockwise
--				create successor.make_from_parent_and_rule (state, [create {ACTION_ROTATE}.make((create {ENUM_ROTATE}).counter_clockwise), state.selected_hole], deep_copy(state.map), state.selected_hole)
--				-- Change successor map and selected_hole
--				from
--					current_stones:=successor.map.get_bucket_value (successor.selected_hole)
--					successor.map.clear_bucket (state.selected_hole)
--				until
--					current_stones = 0
--				loop
--					if((successor.selected_hole < {GAME_CONSTANTS}.num_of_buckets) and (successor.selected_hole >=(({GAME_CONSTANTS}.num_of_buckets / 2)+1))) then
--						-- Example: 7<=selected_hole<12
--						-- first update the position and then change the value of the position
--						successor.selected_hole:=successor.selected_hole+1
--						successor.map.add_token_to_store (successor.selected_hole)
--						current_stones := current_stones - 1
--					else if (successor.selected_hole = 1) then
--						-- Example: selected_hole = 1
--						if(current_stones = 1) then
--							-- Only 1 stone left
--							successor.map.add_token_to_store (1)
--							current_stones := current_stones - 1
--						else
--							-- More than 1 stone left
--							successor.selected_hole:= ({GAME_CONSTANTS}.num_of_buckets / 2)+1
--							successor.map.add_token_to_bucket (successor.selected_hole)
--							current_stones := current_stones - 1
--						end -- End inner if
--					else if ((successor.selected_hole > 1) and (successor.selected_hole <= ({GAME_CONSTANTS}.num_of_buckets / 2))) then
--						-- Example: 1< selected_hole <= 6
--						successor.selected_hole:=successor.selected_hole-1
--						successor.map.add_token_to_store (successor.selected_hole)
--						current_stones := current_stones - 1
--					else if ( successor.selected_hole = {GAME_CONSTANTS}.num_of_buckets) then
--						-- Example: selected_hole = 12
--						if(current_stones = 1) then
--							-- Only 1 stone left
--							successor.map.add_token_to_store (2)
--							current_stones := current_stones - 1
--						else
--							-- More than 1 stone left
--							successor.selected_hole:={GAME_CONSTANTS}.num_of_buckets/2
--							successor.map.add_token_to_bucket (successor.selected_hole)
--							current_stones := current_stones - 1
--						end -- End inner if
--					end -- End multiple ifs
--				end -- End CCW loop
--				-- Check if game over
--				successor.game_over:= is_game_over(successor)
--				-- Add successor to successors
--				successors.extend (successor)
--			end -- End external if

--			Result := successors
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
			Result:=1
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
feature {NONE}
	-- Auxiliary functions
	is_game_over(state: SOLITAIRE_STATE):BOOLEAN
	local
		placed_in_empty_hole: BOOLEAN
		no_store_increase : BOOLEAN
	do
		placed_in_empty_hole:=(state.map.get_hole_value (state.selected_hole) = 1)
		no_store_increase:= (state.map.get_store_value (1) = state.parent.map.get_store_value (1)) and (state.map.get_store_value (2) = state.parent.map.get_store_value (2))
		Result:= placed_in_empty_hole and no_store_increase
	end
end
