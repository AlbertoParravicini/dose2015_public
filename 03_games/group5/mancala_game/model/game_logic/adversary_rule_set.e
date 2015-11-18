note
	description: "Summary description for {ADVERSARY_RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_RULE_SET
inherit
	RULE_SET

feature -- Implementation

	is_valid_action (a_state: ADVERSARY_STATE; a_action: ACTION_SELECT): BOOLEAN
		require
			non_void_parameters: a_state /= VOID and a_action /= VOID

end
