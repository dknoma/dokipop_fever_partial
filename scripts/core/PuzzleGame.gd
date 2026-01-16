#class_name PuzzleGame extends GameState
#
#const NAME := "PuzzleGame"
#
#signal match_finished(won : bool)
#
#var match_data : MatchData
#
#
#	
#func _start(info : Dictionary) -> void:
#	var path : String = info["path"]
#	match_data = load(path)
#
#	Game.current_player.hp.updated.connect(on_player_hp_changed)
#	match_data.opponent.hp.updated.connect(on_opponent_hp_changed)	
#
#	var scn : PuzzleGameScene = load("res://scenes/puzzle_game_scene.tscn").instantiate()
#	get_tree().current_scene.add_child(scn)
#	scn.start_match(match_data)
#	
#	
#func on_player_hp_changed(value : int) -> void:
#	if value > 0:
#		return
#	
#	match_finished.emit(false)	
#	
#	
#func on_opponent_hp_changed(value : int) -> void:
#	if value > 0:
#		return
#	
#	match_finished.emit(true)	
#	