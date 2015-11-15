note
	description: "Represents holes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HOLE

inherit

	BASKET

create
	make, make_with_value

feature {NONE} -- Initialization

	make
			-- Initialization with the provided owner;
		do
			num_of_stones := 0
		end

	make_with_value (starting_stones: INTEGER)
			-- Initialization with the provided owner and starting stones;
		do
			num_of_stones := starting_stones
		ensure
			initial_stones_set: num_of_stones = starting_stones
		end
end
