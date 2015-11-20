note
	description: "Summary description for {SOLITAIRE_RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_RULE_SET
inherit
	RULE_SET[SOLITAIRE_STATE]

create
	make_by_state

feature -- Implementation

	is_valid_action (a_player_id: INTEGER; a_action: ACTION): BOOLEAN
		local
			l_is_valid: BOOLEAN
		do
			l_is_valid := true

			-- THE ACTION MUST BE AN ACTION_SELECT OR AN ACTION_ROTATE OR...
			if not attached {ACTION_SELECT} a_action or not attached {ACTION_ROTATE} a_action then
				l_is_valid := true
			end

			-- CHOSING THE HOLE IS ALLOWED ONLY IN THE FIRST TURN:
			if attached {ACTION_SELECT} a_action as select_action and then (current_state.parent /= Void or current_state.rule_applied /= Void) then
				l_is_valid := false
			end

			-- THE CHOSEN HOLE MUST EXIST:
			if attached {ACTION_SELECT} a_action as select_action and then (select_action.get_selection <= 0 or select_action.get_selection > {GAME_CONSTANTS}.num_of_holes) then
				l_is_valid := false
			end

			-- MOVE CLOCKWISE OR COUNTER-CLOCKWISE ONLY IF THE HOLE IS SELECTED
			if attached {ACTION_ROTATE} a_action as action_rotate and (current_state.selected_hole <= 0 or current_state.selected_hole > {GAME_CONSTANTS}.num_of_holes) then
				l_is_valid := false
			end

			-- ACCEPT ONLY IF THE HOLE ISN'T EMPTY
			if attached {ACTION_ROTATE} a_action as action_rotate and (current_state.map.get_hole_value (current_state.selected_hole) <= 0) then
				l_is_valid := false
			end

			if l_is_valid and then attached {ACTION_SELECT} a_action as action_select then
				current_state := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state, action_select)
			elseif l_is_valid and then attached {ACTION_ROTATE} a_action as action_rotate then
				current_state := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state, action_rotate)
			end

			Result := l_is_valid
		end
end
