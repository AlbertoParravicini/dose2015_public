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
