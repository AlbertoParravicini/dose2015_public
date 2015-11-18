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
	make_by_state (a_state: ADVERSARY_STATE)
		require
			non_void_parameters: a_state /= VOID
		do
			state := a_state
		ensure
			setting_done: state = a_state
		end

feature {NONE} -- Implementation

	state: ADVERSARY_STATE
	player_name: STRING
	action: ACTION_SELECT

	option_1 ...

feature

	is_valid_action (a_player_name: STRING; a_action: ACTION_SELECT): BOOLEAN
		require
			non_void_parameters: a_player_name /= VOID and not a_player_name.is_empty and a_action /= VOID
		do

			if option_1 and option_2 and ... then
				Result := false
			else
				Result := true
			end

		ensure
		end

end
