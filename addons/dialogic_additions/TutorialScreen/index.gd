@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_tutorial_screen.gd')]


func _get_subsystems() -> Array:
	return [{'name':'Tutorial', 'script':this_folder.path_join('TutorialScreenSubsystem.gd')}]
