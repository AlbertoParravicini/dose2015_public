note
	description: "Represents the state of a Mancala game"
	author: "Alberto"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_STATE

feature -- Status Report

	game_over: BOOLEAN
		-- Is the game over?

	map: GAME_MAP
			-- Map of the game

	current_player: PLAYER
			-- The player who has to make a move in the current turn;

	next_player: PLAYER
			-- Return the player who will play in the next turn;
		deferred
		end

feature -- Status Setting

	set_map (new_map: GAME_MAP)
			-- Set a new map for the state;
		require
			map_not_void: new_map /= void
		do
			map := new_map
		ensure
			map_set: map.is_equal (new_map)
		end

	set_current_player (new_current_player: PLAYER)
			-- Set a new current player for the state;
		do
			current_player := new_current_player
		end

end
