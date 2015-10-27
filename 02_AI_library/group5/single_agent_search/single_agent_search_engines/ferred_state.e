note
	description: "define a new status to lead a priority queue ordered by lower cost"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FERRED_STATE[RULE->ANY,S->SEARCH_STATE[RULE]]
			inherit
			COMPARABLE
				redefine is_less end

	create make,make_with_params

	feature make
		do
		end

	feature make_with_params(new_state:S;new_cost:REAL_32)
		do
			state:=new_state
			cost:=new_cost
		ensure
			valid_make_state: state = new_state
			valid_make_cost: cost = new_cost
		end

	feature
		is_less alias "<"(new_state:like Current):BOOLEAN
		do
			Result := Current.cost > new_state.cost
		end

	feature
		set_state(new_state : S)
		do
			state:=new_state
		ensure
			state = new_state
		end


	feature
		set_cost(new_cost : REAL_32)

		do
			cost:=new_cost
		ensure
			cost = new_cost
		end

	feature
		state :S
		cost :	REAL_32

end
