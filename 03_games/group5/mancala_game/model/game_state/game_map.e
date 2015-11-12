note
	description: "Container for the set of holes and stores that are in a Mancala game"
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MAP

create
	make

feature
	-- Creator

	make
		local
			i: INTEGER
			temp_hole: HOLE
			temp_store: STORE
		do
			create holes.make (12)
				-- Create holes list
			create stores.make (2)
				-- Create stores list
			from
				i := 1
			until
				i > 12
			loop
				create temp_hole.make
				holes.put_i_th (temp_hole, i)
			end
				-- Filled the holes with empty holes
			from
				i := 1
			until
				i > 3
			loop
				create temp_store.make
				stores.put_i_th (temp_store, i)
			end
				-- Filled the stores tiwh empty stores
		end

feature
	-- Getters
	get_store (position: INTEGER): STORE
			-- Returns the store in the given position
		require
			valid_position: position > 0 and position <= 2
		do
			Result := stores.i_th (position)
		end

	get_hole (position: INTEGER): HOLE
			-- Returns the hole in the given position
		require
			valid_position: position > 0 and position < 13
		do
			Result := holes.i_th (position)
		end

	get_store_value (position: INTEGER): INTEGER
			-- Returns the store value in the given position
		require
			valid_position: position > 0 and position <= 2
		do
			Result := stores.i_th (position).num_of_stones
		end

	get_hole_value (position: INTEGER): INTEGER
			-- Returns the hole value in the given position
		require
			valid_position: position > 0 and position < 13
		do
			Result := holes.i_th (position).num_of_stones
		end


feature {NONE}
	-- Attributes

	holes: ARRAYED_LIST [HOLE]
			-- List of all hole

	stores: ARRAYED_LIST [STORE]
			-- List of all store

end
