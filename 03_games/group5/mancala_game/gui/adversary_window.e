note
	description: "EiffelVision Widget ADVERSARY_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date: 2010-12-22 10:39:24 -0800 (Wed, 22 Dec 2010) $"
	revision: "$Revision: 85202 $"

class
	ADVERSARY_WINDOW

inherit
	ADVERSARY_WINDOW_IMP


feature {NONE} -- Initialization

	avatar_folder: STRING
	avatar_human1: STRING
	avatar_human2: STRING
	avatar_human: STRING
	avatar_ai: STRING
	avatar_tie: STRING
	avatar_hint1: STRING
	avatar_hint2: STRING
	avatar_hint: STRING
	avatar_solve: STRING

	log_counter: INTEGER

	user_create_interface_objects
			-- Create any auxilliary objects needed for ADVERSARY_WINDOW.
			-- Initialization for these objects must be performed in `user_initialization'.
		do
				-- Create attached types defined in class here, initialize them in `user_initialization'.
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
				-- Initialize types defined in current class
		end

	set_avatar_folder
		do
			if avatar_folder = VOID then
				avatar_folder := "star_wars"
			elseif avatar_folder.is_equal ("star_wars") then
				avatar_folder := "marvel"
			elseif avatar_folder.is_equal ("marvel") then
				avatar_folder := "star_wars"
			end

			avatar_human1 := "./extra/avatar/" + avatar_folder + "/human1.png"
			avatar_human2 := "./extra/avatar/" + avatar_folder + "/human2.png"
			avatar_human := "./extra/avatar/" + avatar_folder + "/human.png"
			avatar_ai := "./extra/avatar/" + avatar_folder + "/ai.png"
			avatar_tie := "./extra/avatar/" + avatar_folder + "/tie.png"
			avatar_hint1 := "./extra/avatar/" + avatar_folder + "/hint1.png"
			avatar_hint2 := "./extra/avatar/" + avatar_folder + "/hint2.png"
			avatar_hint := avatar_hint1
			avatar_solve := "./extra/avatar/" + avatar_folder + "/solve.png"

			if attached {ADVERSARY_RULE_SET} game_manager.rules_set as adv_rule_set and then adv_rule_set.engine = VOID then
				avatar_human := avatar_human1
				avatar_ai := avatar_human2
			end
		end

feature {NONE} -- Implementation

	is_solve_processing: BOOLEAN
	is_two_player_mode: BOOLEAN
	player1_name: STRING
	player2_name: STRING

	action_hole_click(a_hole:INTEGER)
		do
				-- Create a new 'ACTION_SELECT' with the selected
				-- hole as a parameter
				send_action_to_game_manager(create {ACTION_SELECT}.make (a_hole))
				refresh_now
		end

	action_hint_click
		do
				-- Create a new 'ACTION_OTHER' with an '{ENUM_OTHER}.hint'
				-- as a parameter
				activate_player_buttons(1,false)
				avatar_pixmap.set_with_named_file (avatar_hint)
				label_player_name.set_text ("Hint")

				if avatar_hint.is_equal (avatar_hint1) then
					avatar_hint := avatar_hint2
				else
					avatar_hint := avatar_hint1
				end

				button_hint.disable_sensitive
				button_solve.disable_sensitive
				send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).hint))
				refresh_now
		end

	action_solve_click
		do
				-- Create a new 'ACTION_OTHER' with an '{ENUM_OTHER}.hint'
				-- as a parameter
				is_solve_processing := true
				activate_player_buttons(1,false)
				avatar_pixmap.set_with_named_file (avatar_solve)
				label_player_name.set_text ("Solve")
				button_hint.disable_sensitive
				button_solve.disable_sensitive
				send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).solve))
				refresh_now
		end

	action_log_click
		do

				-- Toggle 'text_log' visibility and change the text
				-- of the button according to the status of 'text_log'
				if(text_log.is_show_requested)then
					-- Hide log
					text_log.hide
					button_log.set_text ("Show Log")
					set_minimum_height (298)
					set_height (298)
				else
					-- Show log
					text_log.show
					button_log.set_text ("Hide Log")
					set_minimum_height (430)
					set_height (430)
				end

				log_counter := log_counter + 1
				if log_counter >= 10 then
					log_counter := 0
					set_avatar_folder
					show_message (capitalize_string (avatar_folder) + " mode!%N")
					show_state (game_manager.rules_set.current_state)
				end

				refresh_now
		end

	activate_player_buttons(a_index_of_current_player: INTEGER; a_enable: BOOLEAN)
		require
			a_index_of_current_player > 0 and a_index_of_current_player <= 2
		local
			counter: INTEGER
		do
			from
				counter := 1 + (a_index_of_current_player - 1) * ({GAME_CONSTANTS}.num_of_holes // 2)
			until
				counter > (1 + (a_index_of_current_player - 1)) * ({GAME_CONSTANTS}.num_of_holes // 2)
			loop
				-- Enable select and deselect all
				if a_enable then
					list_button_hole.i_th (counter).enable_sensitive
				else
					list_button_hole.i_th (counter).disable_sensitive
				end
				counter := counter + 1
			end
		end

	activate_current_player_buttons (a_current_state: GAME_STATE)
		do

			if attached {ADVERSARY_STATE} a_current_state as adv_state then
				if not is_solve_processing and attached {HUMAN_PLAYER} a_current_state.current_player then
					activate_player_buttons(adv_state.index_of_current_player, true)
					activate_player_buttons((adv_state.index_of_current_player \\ 2) + 1, false)
					button_hint.enable_sensitive
					button_solve.enable_sensitive
					if adv_state.index_of_current_player = 1 then
						avatar_pixmap.set_with_named_file (avatar_human)
					else
						avatar_pixmap.set_with_named_file (avatar_ai)
					end
				else
					activate_player_buttons(1, false)
					activate_player_buttons(2, false)
					button_hint.disable_sensitive
					button_solve.disable_sensitive
					if not is_solve_processing then
						avatar_pixmap.set_with_named_file (avatar_ai)
					end
				end
				label_player_name.set_text (capitalize_string(a_current_state.current_player.name))
			end

		end

	show_last_move (a_current_state: GAME_STATE)
		local
			counter: INTEGER
		do
			from
				counter := 1
			until
				counter > {GAME_CONSTANTS}.num_of_holes
			loop
				-- Enable select and deselect all
				if (attached {ADVERSARY_STATE} a_current_state as adv_state) and then adv_state.parent /= VOID then

					if counter = adv_state.rule_applied.get_selection then
						list_button_hole.i_th (counter).set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (193, 203, 213))
					else
						list_button_hole.i_th (counter).set_default_colors
					end

				end
				counter := counter + 1
			end

		end

		show_game_over (a_current_state: GAME_STATE)
			local
				game_over_message: STRING
				game_over_avatar: STRING
				end_game_dialog : ENDGAME_DIALOG
			do

				if attached {ADVERSARY_STATE} a_current_state as adv_state and then adv_state.is_game_over then


						-- Player 1 wins
					if adv_state.map.get_store_value (1) > adv_state.map.get_store_value (2) then
						game_over_message := " " + player1_name + " Wins! "
						game_over_avatar := avatar_human

					-- Player 2 wins
					elseif adv_state.map.get_store_value (1) < adv_state.map.get_store_value (2) then
						game_over_message := " " + player2_name + " Wins! "
						game_over_avatar := avatar_ai

					-- Tie	
					else
						game_over_message := " Tie! "
						game_over_avatar := avatar_tie
					end

					avatar_pixmap.set_with_named_file (game_over_avatar)
					label_player_name.set_text (game_over_message)
					show_message(game_over_message + "%N")
					current.disable_sensitive
					create end_game_dialog
					end_game_dialog.end_avatar_pixmap.set_with_named_file (game_over_avatar)
					end_game_dialog.set_label(game_over_message)
					end_game_dialog.show
				end
			end


	initialize_players
		do
			is_solve_processing := false

			if attached {ADVERSARY_RULE_SET} game_manager.rules_set as adv_rule_set then
				-- Two Players
				if adv_rule_set.engine = VOID then
					is_two_player_mode := true
					button_hint.hide
					button_solve.hide
				else
					is_two_player_mode := false
				end

				-- Players Name
				player1_name := capitalize_string(adv_rule_set.current_state.players.i_th (1).name)
				player2_name := capitalize_string(adv_rule_set.current_state.players.i_th (2).name)
				label_store_1_name.set_text (player1_name + "%NScore")
				label_store_2_name.set_text (player2_name + "%NScore")

			end

		end


feature -- Inherited from VIEW
	start_view (a_game_manager: GAME_MANAGER)
		do
			action_log_click
			game_manager := a_game_manager
			set_avatar_folder
			log_counter := 0
			initialize_players
			send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).start_game))

			refresh_now
		end

	show_state (a_current_state: GAME_STATE)
			-- Used to show a representation of the current state:
			-- the GUI updates its values (labels text, etc...), the CLI can print the state;
		do
			update_holes (a_current_state)
			update_stores (a_current_state)
			activate_current_player_buttons (a_current_state)
			show_last_move (a_current_state)
			show_game_over (a_current_state)
			refresh_now
		end

	show_message (a_message: STRING)
			-- Used to communicate generic messages to the client,
			-- for instance an error message or a notification which should be displayed to the user
		do
			text_log.append_text (a_message)
			text_log.scroll_to_end
			refresh_now
		end

feature {NONE} -- Auxiliary features

	update_holes (a_current_state: GAME_STATE)
			-- Updates holes
		local
			counter: INTEGER
		do
			from
				counter := 1
			until
				counter > 12
			loop
				list_button_hole.i_th (counter).set_text ((a_current_state.map.get_hole_value (counter).out))
				counter := counter + 1
			end
		end

	update_stores (a_current_state: GAME_STATE)
			-- Update stores
		do
			label_store_1_value.set_text ((a_current_state.map.get_store_value (1)).out)
			label_store_2_value.set_text ((a_current_state.map.get_store_value (2)).out)
		end

	capitalize_string (a_string: STRING): STRING
		local
			l_string: STRING
			l_substring: STRING
		do

			from
				l_string := a_string.as_lower
			until
				l_string.substring_index ("_",1) = 0
			loop
				l_substring := l_string.substring (1,l_string.substring_index ("_",1) - 1)
				l_string := l_substring + " " + first_letter_up (l_string.substring (l_string.substring_index ("_",1) + 1, l_string.count))
			end

			l_string := first_letter_up (l_string)

			Result := l_string
		end

		first_letter_up (a_string: STRING): STRING
			local
				l_string: STRING
				l_first_letter_of_substring: STRING
			do
				l_string := a_string
				if l_string.count /= 0 then
					l_first_letter_of_substring := l_string.substring (1,1)
					l_string := l_first_letter_of_substring.as_upper + l_string.substring (2,l_string.count)
				end
				Result := l_string
			end

Invariant
	adversary_state: game_manager /= VOID implies (attached {ADVERSARY_RULE_SET} game_manager.rules_set)

end
