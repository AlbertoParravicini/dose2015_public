note
	description: "Represents the state of a Mancala game"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_STATE

feature
	-- Getters
	is_game_over
			-- Is the game over?
		do
			Result:=game_over
		end

feature {NONE}
	-- Variables

	game_over: BOOLEAN
			-- Is the game over?

	map: GAME_MAP
			-- Map of the game




end
