note
	description: "[
		Abstract states for adversary search based algorithmic solutions.
		ABSTRACT_ADVERSARY_SEARCH_STATE is parameterized with a class RULE, used to capture
		the rule applied to reach a given state.
		]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

deferred class
	ADVERSARY_SEARCH_STATE[RULE -> ANY]

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

	is_max: BOOLEAN
			-- Indicates whether current state is a max state
	deferred
	end

	is_min: BOOLEAN
			-- Indicates whether current state is a min state
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


note
	copyright: "Copyright (c) 2015, UNRC"
	license: "MIT License (see http://...)"
	source: "[
		Dpto. de Computacion, FCEFQyN
		Universidad Nacional de Rio Cuarto
		Ruta Nacional No. 36 Km 601
		Rio Cuarto (5800), Cordoba, Argentina
		Telephone +54 358 4676235
	]"

end
