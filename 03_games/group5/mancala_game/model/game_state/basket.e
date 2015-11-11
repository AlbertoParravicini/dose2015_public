note
	description: "Summary description for {BASKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASKET
feature
	--clear_basket
		-- Set the value of stones to zero
	--add_stone
		-- Add one stone to the basket

	is_empty: BOOLEAN
		-- Tell if the basket is empty

feature
	-- Variables

	stones : INTEGER
		-- Number of stones in the basket
	-- owner : PLAYER
		-- Tells who is the owner of the basket
end
