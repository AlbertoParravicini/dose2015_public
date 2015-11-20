note
	description: "Summary description for {RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RULE_SET [STATE -> GAME_STATE]

feature {NONE}

	make_by_state (a_initial_state: STATE)
			-- Create a ruleset with a given initial state;
		require
			non_void_parameter: a_initial_state /= Void
		do
			current_state := a_initial_state
		ensure
			setting_done: current_state = a_initial_state
		end

feature -- Status report

	current_state: STATE
			-- Current state of the game;

	is_valid_action (a_player_id: INTEGER; a_action: ACTION_SELECT): BOOLEAN
			-- Validate the action passed as parameter,
			-- by comparing the player who performed the action with the current state of the game.
			-- Return true iff the action is validated;
		require
			non_void_parameters: a_player_id /= Void and a_action /= Void
		deferred
		ensure
			non_performed_action: Result = false implies current_state = Old current_state
			performed_action: Result = true implies current_state /= Old current_state
		end

feature -- Status setting

	set_current_state (a_state: STATE)
		require
			non_void_parameters: a_state /= Void
		do
			current_state := a_state
		ensure
			setting_done: current_state = a_state
		end
end
