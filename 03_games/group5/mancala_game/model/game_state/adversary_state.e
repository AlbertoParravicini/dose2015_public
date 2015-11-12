note
	description: "State representing a Human vs AI game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_STATE
inherit
	GAME_STATE

	ADVERSARY_SEARCH_STATE[STRING]
		undefine
			out
		end

	ANY
		redefine
			out
		end
feature
	--is_min

	--is_max

feature
	-- Getter
	get_current_player: PLAYER
			-- Returns the player that will do the next move
		do
			Result := player_list.i_th (current_player)
		end

	change_player
			-- Change the player
		do
			if(current_player=1) then
				current_player:=2
			else
				current_player:=1
			end
		ensure
			current_player_changed: current_player /= old current_player
		end
feature {NONE}
	player_list: ARRAYED_LIST [PLAYER]
			-- List of players

	current_player: INTEGER
			-- Values is 1 or 2

invariant
	valid_current_player: current_player = 1 or current_player = 2
end
