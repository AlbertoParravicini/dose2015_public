note
	description: "Summary description for {ACTION_OTHER}."
	author: ""
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
			else
				Result:= "Unknown action"
			end
		end

feature
	-- Variables

	action: ENUM_OTHER

end
