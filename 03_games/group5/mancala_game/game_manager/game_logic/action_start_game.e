note
	description: "Summary description for {ACTION_START_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_START_GAME

inherit
	ACTION

create
	default_create

feature

	out: STRING
		do
			Result := "Game Start!"
		end
end
