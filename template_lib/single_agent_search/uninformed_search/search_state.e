note
	description: "[
		Abstract states for search based algorithmic solutions.
	    SEARCH_STATE is parameterized with a class RULE, used to capture
		the rule applied to reach a given state.
		]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	SEARCH_STATE[RULE -> ANY]

feature -- Status report

	parent: detachable like Current
			-- Parent of current state
		deferred
		end

	rule_applied: detachable RULE
			-- Rule applied to reach current state.
			-- If the state is an initial state, rule_applied
			-- is Void.
	deferred
	end

feature -- Status setting

	set_parent (new_parent: detachable like Current)
			-- Sets the parent for current state
		deferred
		ensure
			parent = new_parent
		end

	set_rule_applied (rule: detachable RULE)
			-- Sets the rule_applied for current state
		deferred
		ensure
			rule_applied = rule
		end

end
