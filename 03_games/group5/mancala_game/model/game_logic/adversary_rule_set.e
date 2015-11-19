note
	description: "Summary description for {ADVERSARY_RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_RULE_SET
inherit
	RULE_SET

create
	make_by_state

feature {NONE} -- Creation

	make_by_state (a_initial_state: ADVERSARY_STATE)
		require
			non_void_parameter: a_initial_state /= VOID
		do
			get_current_state := a_initial_state
		ensure
			setting_done: get_current_state = a_initial_state
		end


feature -- Implementation

	get_current_state: ADVERSARY_STATE

	is_valid_action (a_player_name: STRING; a_action: ACTION_SELECT): BOOLEAN
		require
			non_void_parameters: a_player_name /= VOID and not a_player_name.is_empty and a_action /= VOID
		local
			l_is_valid: BOOLEAN
			l_hole_selected: INTEGER
		do
			l_is_valid := true
			l_hole_selected := a_action.get_selection

				-- INVALID PLAYER:
			if a_player_name /= get_current_state.current_player.name then
				l_is_valid := false
			end

				-- HOLE OF ANOTHER PLAYER:
			if not get_current_state.valid_player_hole (get_current_state.index_of_current_player, l_hole_selected) then
				l_is_valid := false
			end

				-- HOLE WITH ZERO VALUE:
			if get_current_state.map.get_hole_value (l_hole_selected) = 0 then
				l_is_valid := false
			end

			if l_is_valid then
				get_current_state := create {ADVERSARY_STATE}.make_from_parent_and_rule (get_current_state, a_action)
			end

			Result := l_is_valid

		ensure
			non_performed_action: Result = false implies get_current_state = Old get_current_state
			performed_action: Result = true implies get_current_state /= Old get_current_state
			invalid_player: a_player_name /= Old get_current_state.current_player.name implies Result = false
			hole_of_another_player: not Old get_current_state.valid_player_hole (get_current_state.index_of_current_player, a_action.get_selection) implies Result = false
			hole_with_zero_value: Old get_current_state.map.get_hole_value (a_action.get_selection) = 0 implies Result = false
		end
feature
	set_current_state(state: ADVERSARY_STATE)
		do
			get_current_state:=state
		end
end
