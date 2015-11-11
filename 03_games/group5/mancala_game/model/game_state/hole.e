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
	make_with_owner, make_with_owner_and_value

feature {NONE} -- Initialization

	make_with_owner (a_owner: PLAYER)
			-- Initialization with the provided owner;
		do
			owner := a_owner
			num_of_stones := 0
		end

	make_with_owner_and_value (a_owner: PLAYER; starting_stones: INTEGER)
			-- Initialization with the provided owner and starting stones;
		do
			owner := a_owner
			num_of_stones := starting_stones
		ensure
			owner_set: owner = a_owner
			initial_stones_set: num_of_stones = starting_stones
		end
end
