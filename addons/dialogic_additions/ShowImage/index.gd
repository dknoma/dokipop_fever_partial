@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_show_image.gd')]


func _get_subsystems() -> Array:
	return [{'name':'ShowImage', 'script':this_folder.path_join('ShowImageSubsystem.gd')}]
