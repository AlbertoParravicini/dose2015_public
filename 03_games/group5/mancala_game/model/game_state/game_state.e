note
	description: "Represents the state of a Mancala game"
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_STATE

feature	-- Getters

	is_game_over: BOOLEAN
			-- Is the game over?
		deferred
		end

feature 
	-- Variables

	game_over: BOOLEAN
			-- Is the game over?

	map: GAME_MAP
			-- Map of the game




end
