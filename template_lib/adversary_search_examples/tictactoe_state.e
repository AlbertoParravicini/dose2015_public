note
	description: "Summary description for {TICTACTOE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TICTACTOE_STATE

inherit
	ADVERSARY_SEARCH_STATE[STRING]
		undefine
			out
		end

	ANY
		redefine
			out
		end

create
	make, make_with_parent

feature -- Initialisation

	make
			-- Creates empty tic tac toe board.
			-- First turn is X's turn.
		do
			create board.make_filled (None, 3, 3)
			cross_turn := True
		end

	make_with_parent (curr_parent: TICTACTOE_STATE)
			-- Creates empty tic tac toe board, and sets parent to provided state
			-- Turn is opposite to the parent's.
		local
			i,j: INTEGER
		do
			create board.make_filled (None, 3, 3)
			from
				i := 1
			until
				i>3
			loop
				from
					j := 1
				until
					j>3
				loop
					board[i,j] := curr_parent.board[i,j]
					j := j+1
				end
				i := i+1
			end
			cross_turn := not curr_parent.cross_turn
			parent := curr_parent
		end

feature -- Status setting

	set_parent (new_parent: TICTACTOE_STATE)
			-- Sets parent to provided value
		do
			parent := new_parent
		end

	set_rule_applied (new_rule: STRING)
			-- Sets rule to provided value
		do
			rule_applied := new_rule
		end

feature -- Status report

	out: STRING
		local
			i, j: INTEGER
			output: STRING
		do
			output := ""
			from
				i := 1
			until
				i > 3
			loop
				from
					j := 1
				until
					j > 3
				loop
					if board[i,j] = Cross then
						output.append (" X ")
					else
						if board[i,j] = Circle then
							output.append  (" O ")
						else
							output.append  ("   ")
						end
					end
					j := j+1
				end
				output.append  ("%N")
				i := i + 1
			end
			Result := output
		end

	parent: detachable TICTACTOE_STATE

	rule_applied: detachable STRING

	is_max: BOOLEAN
			-- Indicates whether game's turn in current state is max's.
			-- Max player is X, so it says whether it's X's turn
		do
			Result := cross_turn
		end

	is_min: BOOLEAN
			-- Indicates whether game's turn in current state is min's.
			-- Min player is O, so it says whether it's O's turn
		do
			Result := not cross_turn
		end

	has_cross: BOOLEAN
		local
			i, j: INTEGER
			found: BOOLEAN
		do
			from
				i := 1
				found := False
			until
				found or i>3
			loop
				from
					j := 1
				until
					found or j>3
				loop
					if board[i,j] = Cross then
						found := True
					end
					j := j+1
				end
				i := i+1
			end
			Result := found
		end

	has_circle: BOOLEAN
		local
			i, j: INTEGER
			found: BOOLEAN
		do
			from
				i := 1
				found := False
			until
				found or i>3
			loop
				from
					j := 1
				until
					found or j>3
				loop
					if board[i,j] = Circle then
						found := True
					end
					j := j+1
				end
				i := i+1
			end
			Result := found
		end

	has_double_cross: BOOLEAN
		local
			found: BOOLEAN
		do
			found := False
			if board[1,2] = Cross then
				if board[1,1] = Cross or board[2,2] = Cross or board[1,3] = Cross then
					found := True
				end
			end
			if board[2,1] = Cross then
				if board[1,1] = Cross or board[2,2] = Cross or board[3,1] = Cross then
					found := True
				end
			end
			if board[2,3] = Cross then
				if board[1,3] = Cross or board[2,2] = Cross or board[3,3] = Cross then
					found := True
				end
			end
			if board[3,2] = Cross then
				if board[3,1] = Cross or board[2,2] = Cross or board[3,3] = Cross then
					found := True
				end
			end
			Result := found
		end

	has_double_circle: BOOLEAN
		local
			found: BOOLEAN
		do
			found := False
			if board[1,2] = Circle then
				if board[1,1] = Circle or board[2,2] = Circle or board[1,3] = Circle then
					found := True
				end
			end
			if board[2,1] = Circle then
				if board[1,1] = Circle or board[2,2] = Circle or board[3,1] = Circle then
					found := True
				end
			end
			if board[2,3] = Circle then
				if board[1,3] = Circle or board[2,2] = Circle or board[3,3] = Circle then
					found := True
				end
			end
			if board[3,2] = Circle then
				if board[3,1] = Circle or board[2,2] = Circle or board[3,3] = Circle then
					found := True
				end
			end
			Result := found
		end

	has_cross_won: BOOLEAN
	local
		won: BOOLEAN
	do
		won := False
		if board[1,1] = Cross then
			if board[1,2] = Cross and board[1,3] = Cross then
				won := True
			end
			if board[2,2] = Cross and board[3,3] = Cross then
				won := True
			end
			if board[2,1] = Cross and board[3,1] = Cross then
				won := True
			end
		end
		if board[1,2] = Cross then
			if board[2,2] = Cross and board[3,2] = Cross then
				won := True
			end
		end
		if board[1,3] = Cross then
			if board[2,2] = Cross and board[3,1] = Cross then
				won := True
			end
			if board[2,3] = Cross and board[3,3] = Cross then
				won := True
			end
		end
		if board[2,1] = Cross then
			if board[2,2] = Cross and board[2,3] = Cross then
				won := True
			end
		end
		if board[3,1] = Cross then
			if board[3,2] = Cross and board[3,3] = Cross then
				won := True
			end
		end
		Result := won
	end


	has_circle_won: BOOLEAN
	local
		won: BOOLEAN
	do
		won := False
		if board[1,1] = Circle then
			if board[1,2] = Circle and board[1,3] = Circle then
				won := True
			end
			if board[2,2] = Circle and board[3,3] = Circle then
				won := True
			end
			if board[2,1] = Circle and board[3,1] = Circle then
				won := True
			end
		end
		if board[1,2] = Circle then
			if board[2,2] = Circle and board[3,2] = Circle then
				won := True
			end
		end
		if board[1,3] = Circle then
			if board[2,2] = Circle and board[3,1] = Circle then
				won := True
			end
			if board[2,3] = Circle and board[3,3] = Circle then
				won := True
			end
		end
		if board[2,1] = Circle then
			if board[2,2] = Circle and board[2,3] = Circle then
				won := True
			end
		end
		if board[3,1] = Circle then
			if board[3,2] = Circle and board[3,3] = Circle then
				won := True
			end
		end
		Result := won
	end


feature -- Constants

	Cross: INTEGER = 1
			-- X is represented by 1

	Circle: INTEGER = -1
			-- O is represented by -1

	None: INTEGER = 0
			-- Empty cell value is represented by zero

feature -- Implementation

	board: ARRAY2[INTEGER]
			-- Board of the tictactoe game.
			-- Zero means empty cell, -1 is O (circle), and 1 is X (cross)

	cross_turn: BOOLEAN


end
