note
	description: "Human player."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HUMAN_PLAYER
inherit
	PLAYER

create
	make

feature
	make
		do
			score := 0
			name := "pippo"
		end
end
