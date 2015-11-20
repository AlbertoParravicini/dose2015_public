note
	description: "Summary description for {GAME_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MANAGER

create
	make

feature {NONE} -- Creation

	make (a_algorithm: STRING)
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
			supported_algorithms:
				equal(a_algorithm, "minimax") or
				equal(a_algorithm, "minimax_ab") or
				equal(a_algorithm, "negascout") or
				equal(a_algorithm, "two_players") or
				equal(a_algorithm, "df") or
				equal(a_algorithm, "bf") or
				equal(a_algorithm, "df_cycle_checking") or
				equal(a_algorithm, "a_star")
		do

			if false then

			end

		end

end
