note
	description: "Summary description for {RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RULE_SET [STATE -> GAME_STATE]

feature {NONE}

	make_by_state (a_initial_state: STATE; selected_algorithm: STRING; selected_depth: INTEGER)
			-- Create a ruleset with a given initial state;
		require
			non_void_parameter: a_initial_state /= Void
		deferred
		ensure
			setting_done: current_state = a_initial_state
		end

feature -- Status report

	current_state: STATE
			-- Current state of the game;

	is_valid_action (a_player_id: INTEGER; a_action: ACTION): BOOLEAN
			-- Validate the action passed as parameter,
			-- by comparing the player who performed the action with the current state of the game.
			-- Return true iff the action is validated;
		require
			non_void_parameters: a_player_id /= Void and a_action /= Void
		deferred
		ensure
			non_performed_action: (Result = false implies (current_state = Old current_state))
			performed_action: (not attached {ACTION_OTHER} a_action) implies (Result = true implies (current_state /= Old current_state))
			invalid_player: a_player_id /= Old current_state.index_of_current_player implies Result = false
		end
	is_game_over: BOOLEAN
			-- Utility function which tells if the current state is a final state for the game which is being played;
		deferred
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
