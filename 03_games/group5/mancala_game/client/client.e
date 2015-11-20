note
	description: "Summary description for {CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CLIENT

feature
	make
		do
			id_player := 0
		end

feature {NONE} -- Implementation

	id_player: INTEGER

feature -- Status Setting

	set_id_player (a_id: INTEGER)
		require
			not_void_parameter: a_id /= VOID
		do
			id_player := a_id
		ensure
			setting_done: id_player = a_id
		end

	show_current_state (a_current_state: GAME_STATE)
		require
			not_void_parameter: a_current_state /= VOID
		do -- deferred
		end

	show_message (a_message: STRING)
		require
			not_void_parameter: a_message /= VOID
		do -- deferred
		end

	send_action_to_game_manager (a_new_action: ACTION)
		require
			not_void_parameter: a_new_action /= VOID
		do -- deferred
		end

end
