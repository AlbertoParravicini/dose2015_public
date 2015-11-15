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
		end

	get_hole_value (position: INTEGER): INTEGER
			-- Returns the number of stones in the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			Result := holes.at (position)
		ensure
			positive_result: Result >= 0
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
			-- S1				    S2
			--    01 02 03 04 05 06
		local
			output: STRING
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
				stores.start
				output.append ("%N ")
			until
				stores.index > {GAME_CONSTANTS}.num_of_stores
			loop
				output.append (stores.item.out + "             ")
				stores.forth
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

feature -- Status settings

	add_stone_to_hole (position: INTEGER)
			-- Add one stone to the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_holes
		do
			holes.at (position) := holes.at (position) + 1
		ensure
			stone_added: holes.at (position) = old (holes.at (position) + 1)
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
		end

	add_stone_to_store (position: INTEGER)
			-- Add one stone to the hole at the given position;
		require
			valid_position: position > 0 and position <= {GAME_CONSTANTS}.num_of_stores
		do
			stores.at (position) := stores.at (position) + 1
		ensure
			stone_added: stores.at (position) = old (stores.at (position) + 1)
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
		end

feature {NONE} -- Implementative routines

	holes: ARRAYED_LIST [INTEGER]
			-- List of all holes;

	stores: ARRAYED_LIST [INTEGER]
			-- List of all stores;

invariant
--	num_of_holes_is_constant: holes.count = {GAME_CONSTANTS}.num_of_holes
--	num_of_stores_is_constant: stores.count = {GAME_CONSTANTS}.num_of_stores
--	holes_value_is_non_negative: across holes as curr_buc all curr_buc.item >= 0 end
--	store_value_is_non_negative: across stores as curr_store all curr_store.item >= 0 end
	--	num_of_stones_is_constant: across stores as curr_store from sum := 0 loop sum := sum + curr_store.item end end

end
