class_name SubsystemPuzzleGame extends DialogicSubsystem

## Describe the subsystems purpose here.
#signal match_started()
#signal match_finished(won : bool)

#region STATE
####################################################################################################

func clear_game_state(clear_flag := Dialogic.ClearFlags.FULL_CLEAR) -> void:
	dialogic.current_state_info['match_file_path'] = ""

	
func load_game_state(load_flag := LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

# Add some useful methods here.

func start_match(path : String) -> void:
	dialogic.paused = true
	var dict := { 'path': path }
	dialogic.current_state_info['match_file_path'] = path
	#dialogic.VAR.set_variable("force_disable", true)
	dialogic.Styles.get_layout_node().hide() # hides all the dialogue layout nodes
#	Game.Story.hide_story_scene()
	Game.Puzzle._initialize(dict)
	Game.Puzzle._execute()
	
