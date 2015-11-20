note
	description: "Container for the set of holes and stores that are in a Mancala game"
	author: "Alberto"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MAP

inherit

	ANY
		redefine
			is_equal,
			out
		end

create
	make, make_from_map

feature -- Creator

	make
			-- Default constructor, initialize an empty map with size specified in the GAME_CONSTANTS class;
		local
			i: INTEGER
		do
			create holes.make ({GAME_CONSTANTS}.num_of_holes)
				-- Create the holes list;
			create stores.make ({GAME_CONSTANTS}.num_of_stores)
				-- Create the stores list;
			from
				i := 1
			until
				i > {GAME_CONSTANTS}.num_of_holes
			loop
				holes.extend (0)
				holes.forth
				i := i + 1
			end
				-- Create a list of empty holes;
			from
				i := 1
			until
				i > {GAME_CONSTANTS}.num_of_stores
			loop
				stores.extend (0)
				stores.forth
				i := i + 1
			end
				-- Create a list of empty stores;
		ensure
			map_is_empty: num_of_stones = 0
			holes_initialized: holes /= void and then holes.count = {GAME_CONSTANTS}.num_of_holes
			stores_initialized: stores /= void and then stores.count = {GAME_CONSTANTS}.num_of_stores
		end

	make_from_map (other_map: GAME_MAP)
			-- Copy constructor: it creates a map which is a copy of another map given as input;
		local
			i: INTEGER
		do
			create holes.make ({GAME_CONSTANTS}.num_of_holes)
				-- Create the holes list;
			create stores.make ({GAME_CONSTANTS}.num_of_stores)
				-- Create the stores list;
			from
				i := 1
			until
				i > {GAME_CONSTANTS}.num_of_holes
			loop
				holes.extend (other_map.get_hole_value (i))
				holes.forth
				i := i + 1
			end
				-- Create a list of holes whose value is the same of the other map;
			from
				i := 1
			until
				i > {GAME_CONSTANTS}.num_of_stores
			loop
				stores.extend (other_map.get_store_value (i))
				stores.forth
				i := i + 1
			end
				-- Create a list of empty stores whose value is the same of the other map;
		ensure
			num_of_stones_constant: num_of_stones = other_map.num_of_stones
			holes_initialized: holes /= void and then holes.count = {GAME_CONSTANTS}.num_of_holes
			stores_initialized: stores /= void and then stores.count = {GAME_CONSTANTS}.num_of_stores
		end

feature -- Status Report

	get_store_value (position: INTEGER): INTEGER
			-- Returns the number of stones in the store at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			Result := stores.at (position)
		ensure
			positive_result: Result >= 0
			result_is_consistent: Result <= {GAME_CONSTANTS}.num_of_stones
		end

	get_hole_value (position: INTEGER): INTEGER
			-- Returns the number of stones in the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			Result := holes.at (position)
		ensure
			positive_result: Result >= 0
			result_is_consistent: Result <= {GAME_CONSTANTS}.num_of_stones
		end

	is_store_empty (position: INTEGER): BOOLEAN
			-- Is the store at the given position empty?
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
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

	is_hole_empty (position: INTEGER): BOOLEAN
			-- Is the basket at the given position empty?
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			if holes.at (position) = 0 then
				Result := true
			else
				Result := false
			end
		ensure
			result_is_consistent_nec: Result = true implies holes.at (position) = 0
			result_is_consistent_suf: holes.at (position) = 0 implies Result = true
		end

	is_equal (other_map: like Current): BOOLEAN
		local
			equal_map: BOOLEAN
		do
			equal_map := true

				-- Compare the holes;
			from
				holes.start
			until
				holes.exhausted or equal_map = false
			loop
				if not equal (holes.item, other_map.get_hole_value (holes.index)) then
					equal_map := false
				end
				holes.forth
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
			-- S2				    S1
			--    01 02 03 04 05 06
		local
			output: STRING
			i: INTEGER
		do
			output := ""
				-- Print the top row of holes;
			from
				holes.finish
				output.append ("   ")
			until
				holes.index <= {GAME_CONSTANTS}.num_of_holes // 2
			loop
				output.append (holes.item.out + " ")
				holes.back
			end
				-- Print the stores;
			from
				stores.finish
				output.append ("%N ")
			until
				stores.exhausted
			loop
				i := i + 1
				output.append (stores.item.out + "             ")
				stores.back
			end
				-- Print the bottom row of holes;
			from
				holes.start
				output.append ("%N   ")
			until
				holes.index > {GAME_CONSTANTS}.num_of_holes / 2
			loop
				output.append (holes.item.out + " ")
				holes.forth
			end
			Result := output
		end

	num_of_stones: INTEGER
		-- Return the number of stones currently in the map;
		local
			sum: INTEGER
		do
			across holes as curr_hole from Result := 0 loop Result := Result + curr_hole.item end
			across stores as curr_store loop Result := Result + curr_store.item end
		ensure
			result_is_consistent: Result = {GAME_CONSTANTS}.num_of_stones
		end

	sum_of_stores_token: INTEGER
		local
			i: INTEGER
			sum: INTEGER
		do
			from
				i := 1
				sum := 0
			until
				i > {GAME_CONSTANTS}.num_of_stores
			loop
				sum := sum + get_store_value (i)
				i := i + 1
			end
			Result := sum
		ensure
			result_is_consistent: Result >= 0 and Result <= {GAME_CONSTANTS}.num_of_stones
		end

feature -- Status settings

	add_stone_to_hole (position: INTEGER)
			-- Add one stone to the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			holes.at (position) := holes.at (position) + 1
		ensure
			stone_added: holes.at (position) = old (holes.at (position) + 1)
			result_is_consistent: holes.at (position) <= {GAME_CONSTANTS}.num_of_stones
		end

	add_stones_to_hole (additional_stones: INTEGER; position: INTEGER)
			-- Adds more than one stone to the hole at the given position;
		require
			additional_stones_not_negative: additional_stones >= 0
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			holes.at (position) := holes.at (position) + additional_stones
		ensure
			additional_stones_added: holes.at (position) = old (holes.at (position)) + additional_stones
			result_is_consistent: holes.at (position)<= {GAME_CONSTANTS}.num_of_stones
		end

	clear_hole (position: INTEGER)
			-- Set the number of stones to zero in the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			holes.at (position) := 0
		ensure
			basket_emptied: holes.at (position) = 0
		end

	remove_stone_from_hole (position: INTEGER)
			-- Remove one stone from the basket;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			holes.at (position) := holes.at (position) - 1
		ensure
			stone_removed: holes.at (position) = old (holes.at (position)) - 1
			stones_non_negative: holes.at (position) >= 0
		end

	add_stone_to_store (position: INTEGER)
			-- Add one stone to the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			stores.at (position) := stores.at (position) + 1
		ensure
			stone_added: stores.at (position) = old (stores.at (position) + 1)
			result_is_consistent: stores.at (position) <= {GAME_CONSTANTS}.num_of_stones
		end

	add_stones_to_store (additional_stones: INTEGER; position: INTEGER)
			-- Adds more than one stone to the hole at the given position;
		require
			additional_stones_not_negative: additional_stones >= 0
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			stores.at (position) := stores.at (position) + additional_stones
		ensure
			additional_stones_added: stores.at (position) = old (stores.at (position)) + additional_stones
			result_is_consistent: stores.at (position) <= {GAME_CONSTANTS}.num_of_stones
		end

	clear_store (position: INTEGER)
			-- Set the number of stones to zero in the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			stores.at (position) := 0
		ensure
			store_emptied: stores.at (position) = 0
		end

	remove_stone_from_store (position: INTEGER)
			-- Remove one stone from the basket;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			stores.at (position) := stores.at (position) - 1
		ensure
			stone_removed: stores.at (position) = old (stores.at (position)) - 1
			stones_non_negative: stores.at (position) >= 0
		end


feature {NONE} -- Implementative routines

	holes: ARRAYED_LIST [INTEGER]
			-- List of all holes;

	stores: ARRAYED_LIST [INTEGER]
			-- List of all stores;

invariant
	num_of_holes_is_constant: holes.count = {GAME_CONSTANTS}.num_of_holes
	num_of_stores_is_constant: stores.count = {GAME_CONSTANTS}.num_of_stores
	holes_value_is_non_negative: across holes as curr_buc all curr_buc.item >= 0 end
	store_value_is_non_negative: across stores as curr_store all curr_store.item >= 0 end
end
