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
				send_action_to_game_manager(create {ACTION_OTHER}.make ((create {ENUM_OTHER}).start_game))
			until
				equal(io.last_string, "exit")
			loop
				io.read_line
				io.last_string.to_lower
				parse_input_string_to_action(io.last_string)
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
			-- TODO
			if equal(a_input, "exit") then
				print("Quit!%N")
			elseif a_input.is_integer then
				send_action_to_game_manager(create {ACTION_SELECT}.make (a_input.to_integer))
			elseif a_input.is_equal("a") or a_input.is_equal("clockwise") then
				send_action_to_game_manager(create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise))
			elseif a_input.is_equal("d") or a_input.is_equal("counter-clockwise") then
				send_action_to_game_manager(create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise))
			elseif a_input.is_equal("h") or a_input.is_equal("hint") then
				send_action_to_game_manager(create {ACTION_OTHER}.make ((create {ENUM_OTHER}).hint))
			elseif a_input.is_equal("s") or a_input.is_equal("solve") then
				send_action_to_game_manager(create {ACTION_OTHER}.make ((create {ENUM_OTHER}).solve))
			else
				print("ERROR: " + a_input + " isn't a valid move!%N")
			end

		end

end
