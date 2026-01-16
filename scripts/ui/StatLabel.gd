class_name StatLabel extends Control

func _ready() -> void:
	$TextureRect.texture = $SubViewport.get_texture()

func update_text(text:String) -> void:
	$SubViewport/Label3D.text = text
