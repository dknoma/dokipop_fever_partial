class_name SubsystemKeyholeTransition extends DialogicSubsystem

## Describe the subsystems purpose here.
signal transition_finished

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

func start_transition(texture : Texture2D, duration : float, transition_in : bool, ease_type : Tween.EaseType, transition_type : Tween.TransitionType, color : Color, wait : float) -> void:
	#	ScreenTransitionController.transition_finished.connect(_on_transition_finished, CONNECT_ONE_SHOT)
	ScreenTransitionController.keyhole_transition(texture, duration, transition_in, ease_type, transition_type, color, wait)
	
	await ScreenTransitionController.transition_finished
	
	transition_finished.emit()

	
