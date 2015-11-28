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
	out : STRING
		do
			if (rotation = (create {ENUM_ROTATE}).clockwise) then
				Result:="Rotation: Clockwise"
			else
				Result:="Rotation: Counter-Clockwise"
			end
		end

feature
	-- Variables

	rotation: ENUM_ROTATE

end
