note
	description: "Summary description for {ADVERSARY_RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_RULE_SET

inherit

	RULE_SET [ADVERSARY_STATE]

create
	make_by_state

feature -- Implementation

	is_valid_action (a_player_id: INTEGER; a_action: ACTION): BOOLEAN
		local
			l_is_valid: BOOLEAN
			l_hole_selected: INTEGER
		do
			l_is_valid := true

			if attached {ACTION_SELECT} a_action as action_select then
				l_hole_selected := action_select.get_selection

					-- INVALID PLAYER:
				if a_player_id /= current_state.index_of_current_player then
					l_is_valid := false
				end

					-- THE HOLE SELECTED EXISTS:
				if action_select.get_selection <= 0 or {GAME_CONSTANTS}.num_of_holes < action_select.get_selection then
					l_is_valid := false
				end

					-- HOLE OF ANOTHER PLAYER:
				if not current_state.valid_player_hole (current_state.index_of_current_player, l_hole_selected) then
					l_is_valid := false
				end

					-- HOLE WITH ZERO VALUE:
				if current_state.map.get_hole_value (l_hole_selected) = 0 then
					l_is_valid := false
				end
			else
				l_is_valid := false
			end
			
			if attached {ACTION_SELECT} a_action as action_select and then l_is_valid then
				current_state := create {ADVERSARY_STATE}.make_from_parent_and_rule (current_state, action_select)
			end
			Result := l_is_valid
		ensure then
				--	hole_of_another_player: attached {ACTION_SELECT} a_action as action_select implies (not Old current_state.valid_player_hole (current_state.index_of_current_player, action_select.get_selection) implies Result = false)
			invalid_player: a_player_id /= Old current_state.index_of_current_player implies Result = false
				--	hole_with_zero_value: attached {ACTION_SELECT} a_action as action_select implies (Old current_state.map.get_hole_value (action_select.get_selection) = 0 implies Result = false)
		end

end
