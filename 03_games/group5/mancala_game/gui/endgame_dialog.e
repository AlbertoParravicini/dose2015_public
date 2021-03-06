note
	description: "EiffelVision Widget MY_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date: 2010-12-22 10:39:24 -0800 (Wed, 22 Dec 2010) $"
	revision: "$Revision: 85202 $"

class
	ENDGAME_DIALOG

inherit
	ENDGAME_DIALOG_IMP


feature {NONE} -- Initialization

	user_create_interface_objects
			-- Create any auxilliary objects needed for MY_DIALOG.
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

feature {NONE} -- Implementation

	action_replay_click
	local
		l_adversary_window : ADVERSARY_WINDOW
		windows : LINEAR[EV_WINDOW]
		l_game_manager : GAME_MANAGER
	do
		current.destroy
		windows := current.ev_application.windows
		from
			windows.start
		until
			windows.exhausted
		loop
			windows.item.destroy
			windows.forth
		end
		if attached {ADVERSARY_WINDOW}game_manager.view then
			create l_adversary_window
			create l_game_manager.make (game_manager.algorithm_selected, game_manager.algorithm_depth, l_adversary_window)
			l_adversary_window.start_view (l_game_manager)
			l_adversary_window.start_match_replay (game_manager.rules_set.current_state)
			l_adversary_window.show
		end
	end

	action_retry_click
	local
		l_adversary_window : ADVERSARY_WINDOW
		l_single_window : SINGLE_WINDOW
		windows : LINEAR[EV_WINDOW]
		l_game_manager : GAME_MANAGER
	do
		current.destroy
		windows := current.ev_application.windows
		from
			windows.start
		until
			windows.exhausted
		loop
			windows.item.destroy
			windows.forth
		end
		if attached {ADVERSARY_WINDOW}game_manager.view then
			create l_adversary_window
			create l_game_manager.make (game_manager.algorithm_selected, game_manager.algorithm_depth, l_adversary_window)
			l_adversary_window.start_view (l_game_manager)
			l_adversary_window.show
		else
			create l_single_window
			create l_game_manager.make (game_manager.algorithm_selected, game_manager.algorithm_depth, l_single_window)
			l_single_window.start_view (l_game_manager)
			l_single_window.show
		end
	end

	action_menu_click
	local
		menu : MAIN_WINDOW
	    windows : LINEAR[EV_WINDOW]
	do
		current.destroy
		windows := current.ev_application.windows
		from
			windows.start
		until
			windows.exhausted
		loop
			windows.item.destroy
			windows.forth
		end
		create menu
		menu.show

	end

	action_exit_click
			-- Process user request to close the window.
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text ("You are about close this window. %NClick OK to proceed.")
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok then
					-- Destroy the window.
				destroy

					-- End the application.
					--| TODO: Remove next instruction if you don't want the application
					--|       to end when the first window is closed..
				if attached (create {EV_ENVIRONMENT}).application as a then
					a.destroy
				end
			end
		end

feature {ANY}

	game_manager : GAME_MANAGER

	set_label (text : STRING)
	do
		l_ev_label_1.set_text (text)
	end

	set_game_manager (manager : GAME_MANAGER)
	do
		game_manager := manager
	end

end
