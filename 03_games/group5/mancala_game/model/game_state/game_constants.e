note
	description: "Summary description for {GAME_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_CONSTANTS
	-- Class used to represent the game constants:
	-- the number of holes, stores and stones;

create
	default_create

feature -- Access

	num_of_holes: INTEGER = 12
		-- The number of holes in the map;

	num_of_stores: INTEGER = 2
		-- The number of stores in the map;

	num_of_stones: INTEGER = 48
		-- The number of stones used in the game;

invariant
	num_of_holes_even: num_of_holes \\ 2 = 0
	num_of_stores_even: num_of_stores \\ 2 = 0
	num_of_stones_even: num_of_stones \\ 2 = 0
	num_of_holes_positive: num_of_holes >= 2
	num_of_stores_positive: num_of_stores >= 2
	num_of_stones_positive: num_of_stones >= num_of_holes
			-- Without least 12 stones the game would become pretty much impossible to play;
end
