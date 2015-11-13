note
	description: "Container for the set of holes and stores that are in a Mancala game"
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MAP

inherit

	ANY
		redefine
			is_equal, out
		end

create
	make

feature -- Creator

	make
		local
			i: INTEGER
		do
			create buckets.make (num_of_buckets)
				-- Create the holes list;
			create stores.make (num_of_stores)
				-- Create the stores list;
			from
				i := 1
			until
				i > num_of_buckets
			loop
				buckets.extend (0)
				buckets.forth
				i := i + 1
			end
				-- Filled the holes with empty holes
			from
				i := 1
			until
				i > num_of_stores
			loop
				stores.extend (0)
				stores.forth
				i := i + 1
			end
				-- Filled the stores tiwh empty stores
		end

feature -- Status Report

	get_store_value (position: INTEGER): INTEGER
			-- Returns the number of tokens in the store at the given position;
		require
			valid_position: position > 0 and position <= num_of_stores
		do
			Result := stores.at (position)
		ensure
			positive_result: Result >= 0
		end

	get_bucket_value (position: INTEGER): INTEGER
			-- Returns the number of tokens in the bucket at the given position;
		require
			valid_position: position > 0 and position <= num_of_buckets
		do
			Result := buckets.at (position)
		ensure
			positive_result: Result >= 0
		end

	is_store_empty (position: INTEGER): BOOLEAN
			-- Is the store at the given position empty?
		require
			valid_position: position > 0 and position <= num_of_stores
		do
			if stores.at (position) = 0 then
				Result := true
			else
				Result := false
			end
		ensure
			result_is_consistent_nec: Result = true implies stores.at (position) = 0
			result_is_consistent_suf: stores.at (position) = 0 implies Result = true
		end

	is_bucket_empty (position: INTEGER): BOOLEAN
			-- Is the basket at the given position empty?
		require
			valid_position: position > 0 and position <= num_of_buckets
		do
			if buckets.at (position) = 0 then
				Result := true
			else
				Result := false
			end
		ensure
			result_is_consistent_nec: Result = true implies buckets.at (position) = 0
			result_is_consistent_suf: buckets.at (position) = 0 implies Result = true
		end

	num_of_buckets: INTEGER
			-- The number of buckets in the map;
		once
			Result := 12
		end

	num_of_stores: INTEGER
			-- The number of buckets in the map;
		once
			Result := 2
		end

	is_equal (other_map: like Current): BOOLEAN
		local
			equal_map: BOOLEAN
		do
			equal_map := true

				-- Compare the buckets;
			from
				buckets.start
			until
				buckets.exhausted or equal_map = false
			loop
				if not equal (buckets.item, other_map.get_bucket_value (buckets.index)) then
					equal_map := false
				end
				buckets.forth
			end
				-- Compare the stores;
			from
				stores.start
			until
				stores.exhausted or equal_map = false
			loop
				if not equal (stores.item, other_map.get_store_value (stores.index)) then
					equal_map := false
				end
				stores.forth
			end

			Result := equal_map
		end

	out: STRING
			--    12 11 10 09 08 07
			-- S1				    S2
			--    01 02 03 04 05 06
		local
			output: STRING
		do
			output := ""
			-- Print the top row of buckets;
			from
				buckets.finish
				output.append ("   ")
			until
				buckets.index <= num_of_buckets // 2
			loop
				output.append (buckets.item.out + " ")
				buckets.back
			end
			-- Print the stores;
			from
				stores.start
				output.append ("%N ")
			until
				stores.index > num_of_stores
			loop
				output.append (stores.item.out + "             ")
				stores.forth
			end
			-- Print the bottom row of buckets;
			from
				buckets.start
				output.append ("%N   ")
			until
				buckets.index > num_of_buckets / 2
			loop
				output.append (buckets.item.out + " ")
				buckets.forth
			end
			Result := output
		end

feature -- Status settings

	add_stone_to_bucket (position: INTEGER)
			-- Add one stone to the bucket at the given position;
		require
			valid_position: position > 0 and position <= num_of_buckets
		do
			buckets.at (position) := buckets.at (position) + 1
		ensure
			stone_added: buckets.at (position) = old (buckets.at (position) + 1)
		end

	add_stones_to_bucket (additional_stones: INTEGER; position: INTEGER)
			-- Adds more than one stone to the bucket at the given position;
		require
			additional_stones_not_negative: additional_stones >= 0
			valid_position: position > 0 and position <= num_of_buckets
		do
			buckets.at (position) := buckets.at (position) + additional_stones
		ensure
			additional_stones_added: buckets.at (position) = old (buckets.at (position)) + additional_stones
		end

	clear_bucket (position: INTEGER)
			-- Set the number of stones to zero in the bucket at the given position;
		require
			valid_position: position > 0 and position <= num_of_buckets
		do
			buckets.at (position) := 0
		ensure
			basket_emptied: buckets.at (position) = 0
		end

	remove_stone_from_bucket (position: INTEGER)
			-- Remove one stone from the basket;
		require
			valid_position: position > 0 and position <= num_of_buckets
		do
			buckets.at (position) := buckets.at (position) - 1
		ensure
			stone_removed: buckets.at (position) = old (buckets.at (position)) - 1
		end

	add_stone_to_store (position: INTEGER)
			-- Add one stone to the bucket at the given position;
		require
			valid_position: position > 0 and position <= num_of_stores
		do
			stores.at (position) := stores.at (position) + 1
		ensure
			stone_added: stores.at (position) = old (stores.at (position) + 1)
		end

	add_stones_to_store (additional_stones: INTEGER; position: INTEGER)
			-- Adds more than one stone to the bucket at the given position;
		require
			additional_stones_not_negative: additional_stones >= 0
			valid_position: position > 0 and position <= num_of_stores
		do
			stores.at (position) := stores.at (position) + additional_stones
		ensure
			additional_stones_added: stores.at (position) = old (stores.at (position)) + additional_stones
		end

	clear_store (position: INTEGER)
			-- Set the number of stones to zero in the bucket at the given position;
		require
			valid_position: position > 0 and position <= num_of_stores
		do
			stores.at (position) := 0
		ensure
			store_emptied: stores.at (position) = 0
		end

	remove_stone_from_store (position: INTEGER)
			-- Remove one stone from the basket;
		require
			valid_position: position > 0 and position <= num_of_stores
		do
			stores.at (position) := stores.at (position) - 1
		ensure
			stone_removed: stores.at (position) = old (stores.at (position)) - 1
		end

feature {NONE} -- Implementative routines

	buckets: ARRAYED_LIST [INTEGER]
			-- List of all hole

	stores: ARRAYED_LIST [INTEGER]
			-- List of all store

invariant
	num_of_buckets_is_constant: buckets.count = num_of_buckets
	num_of_stores_is_constant: stores.count = num_of_stores
	buckets_value_is_non_negative: across buckets as curr_buc all curr_buc.item >= 0 end
	store_value_is_non_negative: across stores as curr_store all curr_store.item >= 0 end

end
