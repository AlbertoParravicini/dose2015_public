note
	description: "Container for stones."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASKET

feature -- Initialization

	make_with_owner (a_owner: PLAYER)
			-- Initialization with the provided owner;
		deferred
		ensure
			owner_set: owner = a_owner
			hole_is_empty: num_of_stones = 0
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is the basket empty?
		do
			if num_of_stones = 0 then
				Result := true
			else
				Result := false
			end
		ensure
			result_is_consistent_nec: Result = true implies num_of_stones = 0
			result_is_consistent_suf: num_of_stones = 0 implies Result = true
		end

	num_of_stones: INTEGER
			-- Number of stones in the basket;

	owner: PLAYER
			-- Tells who is the owner of the basket;

feature -- Status setting

	add_stone
			-- Add one stone to the basket;
		do
			num_of_stones := num_of_stones + 1
		ensure
			stone_added: num_of_stones = old num_of_stones + 1
		end

	add_stones (additional_stones: INTEGER)
		-- Adds more than one stone to the basket
		require
			additional_stones_not_negative: additional_stones >= 0
		do
			num_of_stones := num_of_stones + additional_stones
		ensure
			additional_stones_added: num_of_stones = old num_of_stones + additional_stones
		end

	clear_basket
			-- Set the number of stones to zero;
		do
			num_of_stones := 0
		ensure
			basket_emptied: num_of_stones = 0
		end

	remove_stone
			-- Remove one stone from the basket;
		do
			num_of_stones := num_of_stones - 1
		ensure
			stone_removed: num_of_stones = old num_of_stones - 1
		end

	set_owner (a_owner: PLAYER)
			-- Set the owner of the bucket;
		require
			owner = void
		do
			owner := a_owner
		ensure
			owner_not_void: owner /= void
			result_is_consistent: old (owner = void) implies owner = a_owner
		end

invariant
	not_negative_stones: num_of_stones >= 0
end
