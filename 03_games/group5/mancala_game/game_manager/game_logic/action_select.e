note
	description: "Action that represents the selection of an hole by the user"
	author: "Simone Ripamonti"
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_SELECT

inherit

	ACTION

create
	make

feature
	-- Creation

	make (hole: INTEGER)
		require
			hole_not_valid: hole >= 1 and hole <= {GAME_CONSTANTS}.num_of_holes
		do
			selection := hole
		ensure
			selection = hole
		end

feature
	-- Getter

	get_selection: INTEGER
		do
			Result := selection
		ensure
			Result >= 1 and Result <= {GAME_CONSTANTS}.num_of_holes
		end

feature

	out: STRING
		do
			Result := "Selected hole: " + selection.out
		end

feature {NONE}
	-- variables

	selection: INTEGER
			-- selected hole

end
