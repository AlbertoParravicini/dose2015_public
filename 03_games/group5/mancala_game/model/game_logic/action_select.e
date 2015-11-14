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
	make (hole : INTEGER)
		require
			hole>0 and hole <13
		do
			selection := hole
		ensure
			selection = hole
		end
feature
	-- Getter
	get_selection: INTEGER
		do
			Result:=selection
		ensure
			Result > 0 and Result < 13
		end
feature {NONE}
	-- variables
	selection:INTEGER
		-- selected hole
end
