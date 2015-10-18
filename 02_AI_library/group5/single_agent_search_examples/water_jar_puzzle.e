note
	description: "Summary description for {WATER_JAR_PUZZLE}."
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	WATER_JAR_PUZZLE

inherit
	HEURISTIC_SEARCH_PROBLEM[STRING,WATER_JAR_PUZZLE_STATE]
	STATE_COST_SEARCH_PROBLEM[STRING,WATER_JAR_PUZZLE_STATE]
	HEURISTIC_STATE_COST_SEARCH_PROBLEM[STRING, WATER_JAR_PUZZLE_STATE]

create
	make

feature -- Initialisation

	make
		do
		end

feature
	-- A_max = 19
	-- B_max = 13
	-- C_max = 7
	initial_state: WATER_JAR_PUZZLE_STATE
	local
		new_state: WATER_JAR_PUZZLE_STATE
	do
		create new_state.make_with_contents (4, 9, 7)
		Result := new_state
	end

	get_successors (state: WATER_JAR_PUZZLE_STATE): LIST[WATER_JAR_PUZZLE_STATE]
	local
		successors: LINKED_LIST[WATER_JAR_PUZZLE_STATE]
		successor: WATER_JAR_PUZZLE_STATE
		rule: STRING
	do
		create successors.make
		-- move from A to B
		if state.contents_a>0 and state.contents_b<13 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("A->B")
				successor.set_rule_applied (rule)
			until
				successor.contents_a=0 or successor.contents_b=13
			loop
				successor.set_contents_a (successor.contents_a-1)
				successor.set_contents_b (successor.contents_b+1)
			end
			successors.extend (successor)
		end
		-- move from A to C
		if state.contents_a>0 and state.contents_c<7 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("A->C")
				successor.set_rule_applied (rule)
			until
				successor.contents_a=0 or successor.contents_c=7
			loop
				successor.set_contents_a (successor.contents_a-1)
				successor.set_contents_c (successor.contents_c+1)
			end
			successors.extend (successor)
		end
		-- move from B to A
		if state.contents_b>0 and state.contents_a<19 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("B->A")
				successor.set_rule_applied (rule)
			until
				successor.contents_b=0 or successor.contents_a=19
			loop
				successor.set_contents_b (successor.contents_b-1)
				successor.set_contents_a (successor.contents_a+1)
			end
			successors.extend (successor)
		end
		-- move from B to C
		if state.contents_b>0 and state.contents_c<7 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("B->C")
				successor.set_rule_applied (rule)
			until
				successor.contents_b=0 or successor.contents_c=7
			loop
				successor.set_contents_b (successor.contents_b-1)
				successor.set_contents_c (successor.contents_c+1)
			end
			successors.extend (successor)
		end
		-- move from C to A
		if state.contents_c>0 and state.contents_a<19 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("C->A")
				successor.set_rule_applied (rule)
			until
				successor.contents_c=0 or successor.contents_a=19
			loop
				successor.set_contents_c (successor.contents_c-1)
				successor.set_contents_a (successor.contents_a+1)
			end
			successors.extend (successor)
		end
		-- move from C to B
		if state.contents_c>0 and state.contents_b<13 then
			from
				create successor.make_with_contents_and_parent (state.contents_a, state.contents_b, state.contents_c, state)
				create rule.make_from_string ("C->B")
				successor.set_rule_applied (rule)

			until
				successor.contents_c=0 or successor.contents_b=13
			loop
				successor.set_contents_c (successor.contents_c-1)
				successor.set_contents_b (successor.contents_b+1)
			end
			successors.extend (successor)
		end
		Result := successors
	end

	is_successful (state: WATER_JAR_PUZZLE_STATE): BOOLEAN
			-- State is successful if two jars have 10 litres each.
		do
			Result := state.contents_a = 10 and state.contents_b = 10
		end

feature {ANY} -- Heuristic search related routines

	heuristic_value (state: WATER_JAR_PUZZLE_STATE): REAL
			-- Distance from jars A and B having 20
			-- The smaller the value, the better the state.
		local
			distance_A, distance_B: INTEGER
		do
			distance_A := absolute_value (10 - state.contents_A)
			distance_B := absolute_value (10 - state.contents_B)
			Result := (distance_A + distance_B)
		end

feature {ANY} -- State Cost related routines

	cost (state: WATER_JAR_PUZZLE_STATE): REAL
			-- Cost of rule leading to current state.
			-- Cost will be 0 for the root, and 1
			-- for any other state.
		do
			if state.parent = Void then
				Result := 0
			else
				Result := 1
			end
		end


feature {NONE} -- Auxiliary features

	absolute_value (x: INTEGER): INTEGER
		do
			if x >= 0 then
				Result := x
			else
				Result := -x
			end
		end


end
