note
	description: "Game state for a Solitaire Mancala game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_STATE
inherit
	GAME_STATE

	SEARCH_STATE[STRING]
		-- Rules are represented as strings in this case.
		-- TODO: change to object event
		redefine
			is_equal, out
		end
feature

end
