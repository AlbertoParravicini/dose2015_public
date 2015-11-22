note
	description: "Summary description for {SOLITAIRE_CLIENT_CLI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_VIEW_CLI

inherit
	VIEW

create
	make


feature -- Status Setting

	start_view (a_game_manager: GAME_MANAGER)
		do
			game_manager := a_game_manager


				-- Game loop
			from
				send_action_to_game_manager(create {ACTION_START_GAME}.default_create)
			until
				equal(io.last_string, "exit")
			loop
				io.read_line
				io.last_string.to_lower
			end

		end

	show_state (a_current_state: GAME_STATE)
		do
			print(a_current_state.out)
		end

	show_message (a_message: STRING)
		do
			print(a_message)
		end

	parse_input_string_to_action (a_input: STRING)
		do
			print("Invalid command")
		end

end
