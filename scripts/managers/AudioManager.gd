extends Node

@export var master_player : AudioStreamPlayer
@export var music_player : AudioStreamPlayer
@export var sfx_player : AudioStreamPlayer
@export var dialogue_player : AudioStreamPlayer

@export_group("Testers")
@export var music_tester : AudioStreamPlayer

@onready var main_menu_bgm : AudioStream = preload("res://assets/audio/Dokipop Frenzy Songs/Dokipop Frenzy 3 Menu.wav")
@onready var puzzle_bgm : AudioStream = preload("res://assets/audio/Dokipop Frenzy Songs/Dokipop Frenzy 1.wav")
@onready var boss_bgm : AudioStream = preload("res://assets/audio/Dokipop Frenzy Songs/Dokipop Frenzy 2.wav")
@onready var dialogue_bgm : AudioStream = preload("res://assets/audio/忘れた記憶.mp3")
@onready var menu_click_1 : AudioStream = preload("res://assets/audio/ui/ui_button_simple_click_01.wav")
@onready var menu_click_3 : AudioStream = preload("res://assets/audio/ui/ui_button_simple_click_03.wav")
@onready var bubble_connect : AudioStream = preload("res://assets/audio/DokiFrenzy_Sounds/Pop2.wav")
@onready var bubble_pop : AudioStream = preload("res://assets/audio/DokiFrenzy_Sounds/Pop1.wav")


func play_song(audio : AudioStream, volume : float = 0.3) -> void:
	music_player.stream = audio
	music_player.volume_db = linear_to_db(volume)
	music_player.play()
	
	
func stop_song() -> void:
	music_player.stop()


func play_sfx(audio : AudioStream, volume : float = 1.0) -> void:
	sfx_player.stream = audio
	sfx_player.volume_db = linear_to_db(volume)
	sfx_player.play()


func play_dialogue_fx(audio : AudioStream, volume : float = 1.0) -> void:
	dialogue_player.stream = audio
	dialogue_player.volume_db = linear_to_db(volume)
	dialogue_player.play()
	
	
func play_master_audio(audio : AudioStream, volume : float = 1.0) -> void:
	master_player.stream = audio
	master_player.volume_db = linear_to_db(volume)
	master_player.play()

	
func play_button_hover(volume : float = 0.3) -> void:
	sfx_player.stream = menu_click_3
	sfx_player.volume_db = linear_to_db(volume)
	sfx_player.play()
	

func test_music(audio : AudioStream) -> void:
	music_tester.stream = audio
	music_tester.play()
