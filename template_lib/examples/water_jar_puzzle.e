note
	description: "Summary description for {WATER_JAR_PUZZLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WATER_JAR_PUZZLE

inherit
	SEARCH_PROBLEM[STRING,WATER_JAR_PUZZLE_STATE]

create
	make

feature -- Initialisation

	make
		do
		end

feature

	initial_state: WATER_JAR_PUZZLE_STATE
	local
		new_state: WATER_JAR_PUZZLE_STATE
	do
		create new_state.make_with_contents (0, 13, 7)
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
				create rule.make_from_string ("A->B")
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

end
