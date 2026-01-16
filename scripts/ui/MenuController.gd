# Class that controls menu tweening
class_name MenuController extends Control


@export var camera : Camera2D

@export var main_menu : Menu
@export var story_menu : Menu
@export var endless_menu : Menu

@export var story_button : Button
@export var story_back_button : Button
@export var endless_button : Button
@export var endless_back_button : Button

@export var chapter_container : GridContainer

var chapter_buttons : Array[Button] = []
var current_menu : Menu = main_menu


#func _ready() -> void:
#	story_button.pressed.connect(swap_to_story)
#	story_back_button.pressed.connect(swap_to_main)
#	endless_button.pressed.connect(swap_to_endless)
#	endless_back_button.pressed.connect(swap_to_main)
#	chapter_buttons.clear()
#	for child : Button in chapter_container.get_children():
#		chapter_buttons.append(child)
#	
#	chapter_buttons[0].pressed.connect(func () -> void:
#		get_tree().change_scene_to_file("res://test/ui_control_test.tscn")
#		pass
#	)
#
#
#func swap_to_story() -> void:
#	for child : Button in chapter_container.get_children():
#		child.disabled = true
#	story_back_button.disabled = true
#	story_menu.transition_finished.connect(enable_story_buttons)
#	disable_main_menu()
#	var tween := get_tree().create_tween()
#	tween.set_ease(Tween.EASE_OUT)
#	tween.set_trans(Tween.TRANS_EXPO)
#	tween.tween_property(camera, "global_position", story_menu.global_position + (get_viewport_rect().size / 2), 1)
#	tween.play()
#	main_menu.hide_ui()
#	story_menu.show_ui()
#	current_menu = story_menu
#	
#
#func swap_to_endless() -> void:
#	endless_back_button.disabled = true
#	endless_menu.transition_finished.connect(func () -> void: endless_back_button.disabled = false)
#	disable_main_menu()
#	var tween := get_tree().create_tween()
#	tween.set_ease(Tween.EASE_OUT)
#	tween.set_trans(Tween.TRANS_EXPO)
#	tween.tween_property(camera, "global_position", endless_menu.global_position + (get_viewport_rect().size / 2), 1)
#	tween.play()
#	main_menu.hide_ui()
#	endless_menu.show_ui(0.5)
#	current_menu = endless_menu
#	
#	
#func swap_to_main() -> void:
#	disable_main_menu()
#	if current_menu == story_menu:
#		for child : Button in chapter_container.get_children():
#			child.disabled = true
#		story_menu.hide_children_only()
#		await get_tree().create_timer(0.4).timeout
#	elif current_menu == endless_menu:
#		endless_menu.hide_children_only()
#		await endless_menu.transition_finished
#	
#	current_menu = main_menu
#	
#	var tween := get_tree().create_tween()
#	tween.set_ease(Tween.EASE_OUT)
#	tween.set_trans(Tween.TRANS_EXPO)
#	tween.tween_property(camera, "global_position", main_menu.global_position + (get_viewport_rect().size / 2), 0.75)
#	tween.play()
#	main_menu.show_ui()
#
#	await tween.finished
#	
#	story_button.disabled = false
#	endless_button.disabled = false
#	
#	
#func disable_main_menu() -> void:
#	story_button.disabled = true
#	endless_button.disabled = true
#
#
#func enable_story_buttons() -> void:
#	story_back_button.disabled = false
#	for child : Button in chapter_container.get_children():
#		child.disabled = false
