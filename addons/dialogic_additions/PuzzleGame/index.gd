@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_puzzle_game.gd')]

func _get_subsystems() -> Array:
	return [{'name':'PuzzleGame', 'script':this_folder.path_join('subsystem_puzzle_game.gd')}]