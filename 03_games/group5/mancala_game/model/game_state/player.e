note
	description: "Abstract player in a Mancala game."
	author: "Luca"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

	inherit
		ANY
		redefine
			is_equal,
			out
		end

create
	make, make_with_name, make_with_initial_score, make_with_initial_values


feature {NONE} -- Implementation

	default_name: STRING
			-- Get default name.
		do
			Result := generator
				-- Use class name as default_name
		end


feature {NONE} --Initialization

	make_with_initial_values (a_name: STRING a_inital_score: INTEGER)
			-- Create human player with specific name and initial score.
		require
		    non_negative_inital_score: a_inital_score >= 0
		    valid_name: a_name /= void and not a_name.is_empty
		do
			set_score(a_inital_score)
			name := a_name
		ensure
			setting_done: score = a_inital_score and equal(name, a_name)
		end

	make_with_name(a_name: STRING)
			-- Create human player with specific name.
		require
		    valid_name: a_name /= void and not a_name.is_empty
		do
			make_with_initial_values(a_name, 0)
		ensure
			setting_done: score = 0 and equal(name, a_name)
		end

	make_with_initial_score(a_inital_score: INTEGER)
			-- Create human player with initial score and default name.
		require
		    non_negative_inital_score: a_inital_score >= 0
		do
			make_with_initial_values(default_name, a_inital_score)
		ensure
			setting_done: score = a_inital_score and equal(name, default_name)
		end

	make
			-- Create human player with default score and default name.
		do
			make_with_initial_values(default_name, 0)
		ensure
			setting_done: score = 0 and equal(name, default_name)
		end



feature -- Operations

	set_score(a_score: INTEGER)
			-- Set a specific score.
		require
		    non_negative_score: a_score >= 0
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
			setting_done: score = old score + 1
		end

	sum_to_score(a_additional_score: INTEGER)
			-- Sum an additional ammount to score.
		require
		    non_negative_additional_score: a_additional_score >= 0
		do
			set_score(score + a_additional_score)
		ensure
			setting_done: score = score + a_additional_score
		end

feature -- Status Report

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

invariant
	    non_negative_score: score >= 0
	    valid_name: name /= void and not name.is_empty

end
