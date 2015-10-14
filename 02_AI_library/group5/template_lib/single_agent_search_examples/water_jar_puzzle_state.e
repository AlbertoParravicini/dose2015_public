note
	description: "Summary description for {WATER_JAR_PUZZLE_STATE}."
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"
	
class
	WATER_JAR_PUZZLE_STATE

inherit
	SEARCH_STATE[STRING]
		-- Rules are represented as strings in this case.
		-- Rules are pour from X to Y, with X /= Y and X, Y \in {A,B,C}.
		-- Jar A is 19 litres, jar B is 13 litres, jar C is 7 litres.
		redefine
			is_equal, out
		end

create
	make, make_with_contents, make_with_contents_and_parent

feature

	make
			-- creates state with empty jars and Void parent
		do
			parent := Void
		end

	make_with_contents(jar_A: INTEGER; jar_B: INTEGER; jar_C: INTEGER)
			-- creates state with provided contents for jars and Void parent
		require
			jar_A>=0 and jar_A<=19
			jar_B>=0 and jar_B<=13
			jar_C>=0 and jar_C<=7
		do
			contents_A := jar_A
			contents_B := jar_B
			contents_C := jar_C
			parent := Void
		end

	make_with_contents_and_parent(jar_A: INTEGER; jar_B: INTEGER; jar_C: INTEGER; new_parent: WATER_JAR_PUZZLE_STATE)
			-- creates state with provided contents for jars and provided parent
		require
			jar_A>=0 and jar_A<=19
			jar_B>=0 and jar_B<=13
			jar_C>=0 and jar_C<=7
		do
			contents_A := jar_A
			contents_B := jar_B
			contents_C := jar_C
			parent := new_parent
		end


feature

	set_contents_A (new_value: INTEGER)
			-- Sets the number of litres in jar A
		require
			new_value>=0 and new_value<=19
		do
			contents_A := new_value
		end

	set_contents_B (new_value: INTEGER)
			-- Sets the number of litres in jar B
		require
			new_value>=0 and new_value<=13
		do
			contents_B := new_value
		end

	set_contents_C (new_value: INTEGER)
			-- Sets the number of litres in jar C
		require
			new_value>=0 and new_value<=7
		do
			contents_C := new_value
		end


	set_parent (new_parent: WATER_JAR_PUZZLE_STATE)
			-- Sets the parent of the state to new_parent
		do
			parent := new_parent
		end

	set_rule_applied(rule: detachable STRING)
		do
			rule_applied := rule
		end

feature

	is_equal (other: like Current): BOOLEAN
			-- Compares current state with another state other.
			-- Considered equal iff they hold the same number of litres in each jar.
		do
			Result := (contents_A = other.contents_A and contents_B = other.contents_B and contents_C = other.contents_C)
		end


	out: STRING
	do
		Result := "("+contents_A.out+", "+contents_B.out+", " +contents_C.out+")"
	end


feature

	contents_A: INTEGER
		-- The contents of jar A (number of litres in the jar).
		-- Value must be between 0 and 19

	contents_B: INTEGER
		-- The contents of jar B (number of litres in the jar).
		-- Value must be between 0 and 13

	contents_C: INTEGER
		-- The contents of jar C (number of litres in the jar).
		-- Value must be between 0 and 7

	parent: detachable WATER_JAR_PUZZLE_STATE
		-- The parent of the current state.

	rule_applied: detachable STRING
		-- Represents the rule applied to lead to current state.

invariant
	contents_A >= 0 and contents_A<=19
	contents_B >= 0 and contents_B<=13
	contents_C >= 0 and contents_C<=7

end
