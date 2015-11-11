note
	description: "Represents a store."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STORE
inherit
	BASKET

create
	make_with_owner

feature -- Initialitazion
	make_with_owner (a_owner: PLAYER)
			-- Initialization with the provided owner;
		do
			owner := a_owner
			num_of_stones := 0
		end

feature	-- Status setting

	set_stones (new_stones_amount: INTEGER)
		-- Set the amount of stones in the basket
		require
			new_stones_amount_not_negative: new_stones_amount >= 0
		do
			num_of_stones := new_stones_amount
		ensure
			new_stones_amount_set: num_of_stones = new_stones_amount
		end
end
