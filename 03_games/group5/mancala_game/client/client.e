note
	description: "Summary description for {CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CLIENT

feature
	make (a_game_manager: GAME_MANAGER)
			-- Initializes the client with an ID = 0;
			-- the ID will be assigned by the controller and used to identify univocally the client;
		do
			id_player := 0
		end

feature {NONE} -- Implementation

	id_player: INTEGER
			-- The ID is assigned by the controller and used to identify univocally the client;
			-- The ID is sent alongside the action so that it can be validated (e.g. if it is the client's turn or not);

	current_game_manager: GAME_MANAGER
			-- A reference to the game manager is needed to parse and validate the player's actions;

feature -- Status Setting

	set_id_player (a_id: INTEGER)
			-- Set the ID of the client;
		require
			not_void_parameter: a_id /= VOID
		do
			id_player := a_id
		ensure
			setting_done: id_player = a_id
		end

	show_current_state (a_current_state: GAME_STATE)
			-- Used to show a representation of the current state:
			-- the GUI updates its values (labels text, etc...), the CLI can print the state;
		require
			not_void_parameter: a_current_state /= VOID
		do -- deferred
		end

	show_message (a_message: STRING)
			-- Used to communicate generic messages to the client,
			-- for instance an error message or a notification which should be displayed to the user
		require
			not_void_parameter: a_message /= VOID
		do -- deferred
		end

	send_action_to_game_manager (a_new_action: ACTION)
			-- Call the game manager to validate the action: if the answer is positive,
			-- the interface should be updated, otherwise an error message might be displayed;
		require
			not_void_parameter: a_new_action /= VOID
		do
			-- answer := game_manager.parse_action(a_new_action)
			-- if answer = true then show_current_state(game_manager.current_state)
			-- else show_message(?)
		end

end
