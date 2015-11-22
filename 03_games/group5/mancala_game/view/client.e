note
	description: "Summary description for {CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VIEW

feature {NONE} -- Creation

	make
		do
		end

feature {NONE} -- Implementation

	game_manager: GAME_MANAGER
			-- A reference to the game manager is needed to parse and validate the player's actions;

feature -- Status Setting

	start_view (a_game_manager: GAME_MANAGER)
		require
			non_void_game_manager: a_game_manager /= VOID
		deferred
		ensure
			setting_done: game_manager = a_game_manager
		end

	show_state (a_current_state: GAME_STATE)
			-- Used to show a representation of the current state:
			-- the GUI updates its values (labels text, etc...), the CLI can print the state;
		require
			not_void_parameter: a_current_state /= VOID
		deferred
		end

	show_message (a_message: STRING)
			-- Used to communicate generic messages to the client,
			-- for instance an error message or a notification which should be displayed to the user
		require
			not_void_parameter: a_message /= VOID
		deferred
		end

	send_action_to_game_manager (a_new_action: ACTION)
			-- Call the game manager to validate the action: if the answer is positive,
			-- the interface should be updated, otherwise an error message might be displayed;
		require
			not_void_parameter: a_new_action /= VOID
		do
			game_manager.parse_action_string (a_new_action)
		end

end
