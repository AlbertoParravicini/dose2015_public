note
	description: "Summary description for {GAME_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_CONSTANTS
	-- Class used to represent the game constants:
	-- the number of buckets, stores and tokens;

create
	default_create

feature -- Access

	num_of_buckets: INTEGER = 12
		-- The number of buckets in the map;

	num_of_stores: INTEGER = 2
		-- The number of stores in the map;

	num_of_tokens: INTEGER = 48
		-- The number of tokens used in the game;

invariant
	num_of_buckets_even: num_of_buckets \\ 2 = 0
	num_of_stores_even: num_of_stores \\ 2 = 0
	num_of_buckets_positive: num_of_buckets >= 2
	num_of_stores_positive: num_of_stores >= 2
	num_of_tokens_positive: num_of_tokens >= 12
			-- Without least 12 tokens the game would become pretty much impossible to play;
end
