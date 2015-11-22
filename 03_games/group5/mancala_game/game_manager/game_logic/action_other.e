note
	description: "Action that represents an operation not included in other categories;%
				% it can be a request to have AI support, or a request to start the game."
	author: "Alberto Parravicini"
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_OTHER

inherit

	ACTION

create
	make

feature
	-- Creator

	make (enum: ENUM_OTHER)
		do
			action := enum
		end

feature
	out : STRING
		do
			if (action = (create {ENUM_OTHER}).hint) then
				Result:="Action: Hint"
			elseif (action = (create {ENUM_OTHER}).solve) then
				Result:="Action: Solve"
			elseif (action = (create {ENUM_OTHER}).start_game) then
				Result:="Action: Start Game"
			else
				Result:= "Unknown action"
			end
		end

feature
	-- Variables

	action: ENUM_OTHER

end
