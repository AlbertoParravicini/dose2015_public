note
	description: "Abstract player in a Mancala game."
	author: "Luca"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PLAYER

	inherit
		ANY
		redefine
			is_equal,
			out
		end

feature -- Status report;

	score: INTEGER
		-- Player's score

	name: STRING
		-- Player's name

	is_equal (other: like Current): BOOLEAN
		do
			Result := (score = other.score) and then (name = other.name)
		end

	out: STRING
		do
			Result := "Name: " + name.out + ", Score: " + score.out
		end
end
