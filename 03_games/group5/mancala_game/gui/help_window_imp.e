note
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	generator: "EiffelBuild"
	date: "$Date: 2015-04-03 06:15:42 -0700 (Fri, 03 Apr 2015) $"
	revision: "$Revision: 97017 $"

deferred class
	HELP_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects, initialize, is_in_default_state
		end

	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

feature {NONE}-- Initialization

	frozen initialize
			-- Initialize `Current'.
		local
			internal_font: EV_FONT
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants


				-- Build widget structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (text_rules)
			l_ev_vertical_box_1.extend (label_dose_group)
			l_ev_vertical_box_1.extend (frame_italy)
			frame_italy.extend (box_italy)
			box_italy.extend (label_ita_1)
			box_italy.extend (label_ita_2)
			box_italy.extend (label_ita_3)
			l_ev_vertical_box_1.extend (frame_argentina)
			frame_argentina.extend (box_argentina)
			box_argentina.extend (label_arg_1)
			box_argentina.extend (label_arg_2)
			box_argentina.extend (label_arg_3)
			l_ev_vertical_box_1.extend (l_ev_pixmap_1)


			l_ev_vertical_box_1.set_padding (2)
			l_ev_vertical_box_1.set_border_width (5)
			text_rules.set_text (" # ADVERSARY MODE #%N%NMancala is an ancient family of board games, and there are numerous variants. This is a version of the basic game, known as two-rank Mancala and also known as Kalah.%N%N - Holes and store%NYour holes on the board are on the bottom or right side. Your store is the big hole on the right or top edge.%N%N - Sow stones%NChose a hole to pick up all pieces. Moving counter-clockwise, the game now deposits one of the stones in each hole until the stones run out.%N%N - Store%NIf you run into your own store, deposit one piece in it. If you run into your opponent's store, skip it.%N%N - Free turn%NIf the last piece you drop is in your own store, you get a free turn.%N%N - Capture%NIf the last piece you drop is in an empty hole on your side, you capture that piece and any pieces in the hole directly opposite.%N%N - End%NThe game ends when all six spaces on one side of the Mancala board are empty. The player who still has pieces on his side of the board when the game ends captures all of those pieces.%N%N - Win%NCount all the pieces in each store. The winner is the player with the most pieces.%N%N # SOLITAIRE MODE #%N%NThe game is played on a standard mancala board by one player. The goal is to put all the stones in the stores, leaving all the holes empty%N%N - Begin of first round%NThe player shall select a hole (in any row, thus any of the 12 holes)%N%N - Round%NWhen a hole is selected, all stones in the selected hole are distributed either clockwise or anti-clockwise%N%N - Dropping clockwise%NOne stone is placed in each hole starting with the hole next to the selected one, in clockwise direction. If the number of stones remaining to be distributed is more than 1 after dropping in hole07 or hole01, then store01 or store02 respectively is skipped, and the next stone is dropped in hole06 or hole12 respectively.%NIf the number of stones remaining to be distributed is 1 after dropping in hole07 (hole01), this stone is dropped in store01 (store02)%NThe round is over when there are no more stones to distribute. If the game is not over, a new round starts, where the selected hole will be the one where the last stone of this round was dropped.%N%N - Dropping anti-clockwise%NOne stone is placed in each hole starting with the hole next to the selected one, in anti-clockwise direction. If the number of stones remaining to be distributed is more than 1 after dropping in hole06 or hole12, then store01 or store02 respectively is skipped, and the next stone is dropped in hole07 or hole01 respectively.%NIf the number of stones remaining to be distributed is 1 after dropping in hole06 (hole12), this stone is dropped in store01 (store02)%NThe round is over when there are no more stones to distribute. If the game is not over, a new round starts, where the selected hole will be the one where the last stone of this round was dropped.%N%N - Game over: lose%NWhen the last stone distributed in a round is placed in an empty hole, the player loses and the game is over.%N%N - Game over: win%NThe player wins the game if no stone remains in any of the 12 holes")
			text_rules.set_minimum_height (200)
			text_rules.disable_edit
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_bold)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (20)
			internal_font.preferred_families.extend ("Segoe UI")
			label_dose_group.set_font (internal_font)
			label_dose_group.set_text ("Dose 2015 Group 5")
			frame_italy.set_text ("Politecnico of Milan")
			label_ita_1.set_text ("Ripamonti Simone")
			label_ita_2.set_text ("Parravicini Alberto")
			label_ita_3.set_text ("Stornaiuolo Luca")
			frame_argentina.set_text ("Universidad Nacional de Rio Cuarto")
			label_arg_1.set_text ("Andruvetto Daniel")
			label_arg_2.set_text ("Lanzoni Lucas Fermin")
			label_arg_3.set_text ("Castagneris Nazareno")
			l_ev_pixmap_1.set_with_named_file (".\extra\dummy.png")
			l_ev_pixmap_1.hide
			set_minimum_width (400)
			set_minimum_height (400)
			set_title ("Display window")

			set_all_attributes_using_constants

				-- Connect events.
				Current.minimize_actions.extend (agent action_enable_show_image)
				Current.restore_actions.extend (agent action_show_image)
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked.
			close_request_actions.extend (agent destroy_and_exit_if_last)

				-- Call `user_initialization'.
			user_initialization
		end

	frozen create_interface_objects
			-- Create objects
		do

				-- Create all widgets.
			create l_ev_vertical_box_1
			create text_rules
			create label_dose_group
			create frame_italy
			create box_italy
			create label_ita_1
			create label_ita_2
			create label_ita_3
			create frame_argentina
			create box_argentina
			create label_arg_1
			create label_arg_2
			create label_arg_3
			create l_ev_pixmap_1


			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			user_create_interface_objects
		end


feature -- Access

	text_rules: EV_TEXT
	label_dose_group, label_ita_1, label_ita_2, label_ita_3, label_arg_1,
	label_arg_2, label_arg_3: EV_LABEL
	frame_italy, frame_argentina: EV_FRAME
	box_italy, box_argentina: EV_HORIZONTAL_BOX

feature {NONE} -- Implementation

	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_pixmap_1: EV_PIXMAP


feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			Result := True
		end

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		deferred
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end

	action_show_image
			-- Called by `pointer_button_release_actions' of `label_dose_group'.
		deferred
		end

	action_enable_show_image
		deferred
		end

feature {NONE} -- Constant setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).item (Void)
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).item (Void)
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				arg1 := integer_interval_constant_retrieval_functions.item.item (Void)
				integer_interval_constant_retrieval_functions.forth
				arg2 := integer_interval_constant_retrieval_functions.item.item (Void)
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).item (Void)
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).item (Void)
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).item (Void)
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end

	frozen set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end

	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_COLOR]]

	frozen integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end
