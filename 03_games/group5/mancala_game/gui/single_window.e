note
	description: "EiffelVision Widget SINGLE_WINDOW.The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date: 2010-12-22 10:39:24 -0800 (Wed, 22 Dec 2010) $"
	revision: "$Revision: 85202 $"

class
	SINGLE_WINDOW

inherit

	SINGLE_WINDOW_IMP

feature {NONE} -- Initialization

	default_button_color : EV_COLOR
	default_button_selected_color : EV_COLOR

	user_create_interface_objects
			-- Create any auxilliary objects needed for SINGLE_WINDOW.
			-- Initialization for these objects must be performed in `user_initialization'.
		do
				-- Create attached types defined in class here, initialize them in `user_initialization'.
				create default_button_selected_color.make_with_8_bit_rgb (193, 203, 213)
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
				-- Initialize types defined in current class
				default_button_color:=button_hole_1.background_color
		end

feature {NONE} -- Implementation

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
				send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).hint))
				refresh_now
		end

	action_solve_click
		do
				-- Create a new 'ACTION_OTHER' with an '{ENUM_OTHER}.solve'
				-- as a parameter
				send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).solve))
				refresh_now
		end

	action_clockwise_click
		do
				-- Create a new 'ACTION_ROTATE' with '{ENUM_ROTATE}.clockwise'
				-- as a parameter
				send_action_to_game_manager (create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise))
				refresh_now
		end

	action_counter_clockwise_click
		do
				-- Create a new 'ACTION_ROTATE' with '{ENUM_ROTATE}.counter_clockwise'
				-- as a parameter
				send_action_to_game_manager (create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise))
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
				refresh_now
		end

feature -- Inherited from VIEW

	start_view (a_game_manager: GAME_MANAGER)
		do
			action_log_click
			game_manager := a_game_manager
			send_action_to_game_manager (create {ACTION_OTHER}.make ((create {ENUM_OTHER}).start_game))
			refresh_now
		end

	show_state (a_current_state: GAME_STATE)
			-- Used to show a representation of the current state:
			-- the GUI updates its values (labels text, etc...), the CLI can print the state;
		do
			update_holes (a_current_state)
			update_stores (a_current_state)
			update_stones (a_current_state)
			update_selected_hole (a_current_state)
			update_rotation_buttons (a_current_state)
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

feature {NONE}

	show_game_over (a_current_state: GAME_STATE)
	local
		end_game_dialog : ENDGAME_DIALOG
		game_over_message: STRING
	do
		if attached {SOLITAIRE_STATE} a_current_state as solitaire_state and then solitaire_state.is_game_over then
			current.disable_sensitive

			if solitaire_state.is_won then
				game_over_message := " You won! "
			else
				game_over_message := " You lost! "
			end
			create end_game_dialog
			end_game_dialog.end_avatar_pixmap.hide
			end_game_dialog.set_label (game_over_message)
			end_game_dialog.show_relative_to_window (current)
		end
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
			refresh_now
		end

	update_stores (a_current_state: GAME_STATE)
			-- Update stores
		do
			label_store_1.set_text ((a_current_state.map.get_store_value (1)).out)
			label_store_2.set_text ((a_current_state.map.get_store_value (2)).out)
			refresh_now
		end

	update_stones (a_current_state: GAME_STATE)
			-- Update remaining stones
		do
			label_stones_value.set_text ((a_current_state.map.num_of_stones - a_current_state.map.get_store_value (1)-a_current_state.map.get_store_value (2)).out)
			refresh_now
		end

	update_selected_hole (a_current_state: GAME_STATE)
			-- Update selected state
		local
			l_selected_hole: INTEGER
			counter: INTEGER
		do
				-- Assuming that the given state is a solitaire one
			if attached {SOLITAIRE_STATE} a_current_state as a_solitaire_state then
				l_selected_hole := a_solitaire_state.selected_hole
				if (l_selected_hole = -1) then
						-- Time to select an hole
					from
						counter := 1
					until
						counter > 12
					loop
						-- Enable select and deselect all
						list_button_hole.i_th (counter).enable_sensitive
						list_button_hole.i_th (counter).set_background_color (default_button_color)
						counter := counter + 1
					end
				else
						-- Change the selected one
					from
						counter := 1
					until
						counter > 12
					loop
						-- Disable select and select the current one
						list_button_hole.i_th (counter).disable_sensitive
						list_button_hole.i_th (counter).set_background_color (default_button_color)
						if(counter=l_selected_hole)then
								--list_button_hole.i_th (counter).enable_sensitive
								list_button_hole.i_th (counter).set_background_color (default_button_selected_color)
						end

						counter := counter + 1
					end
				end
			end
			refresh_now
		end
	update_rotation_buttons (a_current_state: GAME_STATE)
		-- Enable or disable according to the selected hole
		do
			if attached {SOLITAIRE_STATE} a_current_state as a_solitaire_state then
				if(a_solitaire_state.selected_hole = -1) then
					button_clockwise.disable_sensitive
					button_counter_clockwise.disable_sensitive
				else
					button_clockwise.enable_sensitive
					button_counter_clockwise.enable_sensitive
				end
			end
			refresh_now
		end
end
