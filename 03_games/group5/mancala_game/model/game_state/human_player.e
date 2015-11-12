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
	make, make_with_name, make_with_initial_score, make_with_initial_value


feature {NONE} --Initialization

	make_with_initial_value(a_name: STRING a_inital_score: INTEGER)
			-- Create human player with specific name and initial score.
		require
		    minimum_inital_score: a_inital_score >= 0
		    valid_name: a_name /= void and not a_name.is_empty
		do
			set_score(a_inital_score)
			name := a_name
		ensure
			setting_done: score = a_inital_score and name = a_name
		end

	make_with_name(a_name: STRING)
			-- Create human player with specific name.
		require
		    valid_name: a_name /= void and not a_name.is_empty
		do
			make_with_initial_value(a_name, 0)
		ensure
			setting_done: score = 0 and name = a_name
		end

	make_with_initial_score(a_inital_score: INTEGER)
			-- Create human player with initial score and default name.
		require
		    minimum_inital_score: a_inital_score >= 0
		do
			make_with_initial_value("Player", a_inital_score)
		ensure
			setting_done: score = a_inital_score and name = "Player"
		end

	make
			-- Create human player with default score and default name.
		do
			make_with_initial_value("Player", 0)
		ensure
			setting_done: score = 0 and name = "Player"
		end



feature -- Operations

	set_score(a_score: INTEGER)
			-- Set a specific score.
		require
		    minimum_score: a_score >= 0
		do
			score := a_score
		ensure
			setting_done: score = a_score
		end

	increment_score
			-- Increment score.
		do
			set_score(score + 1)
		ensure
			setting_done: score = score + 1
		end

invariant
	    minimum_inital_score: score >= 0
	    valid_name: name /= void and not name.is_empty

end
