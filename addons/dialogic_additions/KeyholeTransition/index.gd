@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_keyhole_transition.gd')]

func _get_subsystems() -> Array:
	return [{'name':'KeyholeTransition', 'script':this_folder.path_join('subsystem_keyhole_transition.gd')}]
