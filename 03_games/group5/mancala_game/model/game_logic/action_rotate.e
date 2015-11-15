note
	description: "Action that represents the selection of the rotation by the user"
	author: "Simone Ripamonti"
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_ROTATE

inherit

	ACTION

create
	make

feature
	-- Creator

	make (enum: ENUM_ROTATE)
		do
			rotation := enum
		end

feature
	-- Variables

	rotation: ENUM_ROTATE

end
