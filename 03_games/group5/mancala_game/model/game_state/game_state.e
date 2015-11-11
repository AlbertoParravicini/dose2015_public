note
	description: "Represents the state of a Mancala game"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_STATE
feature
	--get_current_player
		-- Returns the player that will do the next move

	--get_player_list
		-- Returns the list of all players
feature
	-- Variables

	is_game_over : BOOLEAN
		-- Is the game over?

	-- map: GAME_MAP
	-- player_list: LIST[PLAYER]

end
