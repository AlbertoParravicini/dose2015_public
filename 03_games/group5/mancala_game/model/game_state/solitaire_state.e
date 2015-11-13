note
	description: "Game state for a Solitaire Mancala game."
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_STATE
inherit
	GAME_STATE

	SEARCH_STATE[STRING]
		-- Rules are represented as strings in this case.
		-- TODO: change to object event
		redefine
			is_equal, out
		end
create
	make, make_from_parent_and_rule
feature
	-- Creator
	make
		do
			game_over:=false
			create map.make
			selected_hole:= -1
		ensure
			no_rule_applied: rule_applied = void
			no_parent: parent = void
		end

	make_from_parent_and_rule(parent: SOLITAIRE_STATE, rule: ACTION, new_map: GAME_MAP, new_hole : INTEGER)
		do
			game_over:=is_game_over -- to be implemented
			set_parent(parent)
			set_rule_applied(rule)
			set_map(new_map)
			set_hole(new_hole)
		end
feature
	-- Setter
	set_map(new_map: GAME_MAP)
		do
			map:=new_map
		end

	set_hole(new_hole:INTEGER)
		do
			selected_hole:=new_hole
		end
feature
	-- Getter
	get_selected_hole : INTEGER
		-- Returns the selected hole
		do
			Result:=selected_hole
		end

	get_map : GAME_MAP
		-- Returns game map
		do
			Result:=map
		end

feature
	-- Operations
	is_game_over : BOOLEAN
		do
			Result:=(map.get_hole_value(selected_hole) = true)
		end
feature
	-- Inherited
	set_parent (new_parent: detachable like Current)
			-- Sets the parent for current state
		do
			parent = new_parent
		end

	set_rule_applied (rule: detachable RULE)
			-- Sets the rule_applied for current state
		do
			rule_applied = rule
		end

	is_equal (other: like Current): BOOLEAN
			-- Compares current state with another state other.
			-- Considered equal iff same map and same selected state.
		local
			map_is_equal: BOOLEAN
			selected_hole_is_equal: BOOLEAN
		do
			selected_hole_is_equal:= (selected_hole = other.get_selected_hole)
			map_is_equal:= (map = other.get_map)
			Result:= selected_hole_is_equal and map_is_equal
		end

	out: STRING
	do
		Result := "Selected hole: "+selected_hole.out+" Map: "+map.out+"/n"
	end
feature
	-- Variables
		selected_hole: INTEGER
			-- Target of the next move, it's the ending position after having moved in the previous state
end
