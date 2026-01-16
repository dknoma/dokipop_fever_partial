## Resource used to populate a DokiPOP match
class_name MatchData extends Resource

# opponent to face during match
@export var opponent : CharacterData
@export_group("Story Continuity")
# Chapter to move on to when match is won
@export var win_chapter : Chapter
# Label of the timeline to start at
@export var win_label : String
# Lets PuzzleService know what to do when match is lost; if not present, PuzzleService defaults to showing the LoseScreen
@export var scripted_loss := false
@export_group("Audio")
# BGM to play during a match. If not set, a default BGM will be played
@export var bgm : AudioStream
@export var volume := 0.2
@export_group("Tutorial Window")
@export var tutorial_scn : PackedScene = preload("res://scenes/tutorial/tutorial_window.tscn")
