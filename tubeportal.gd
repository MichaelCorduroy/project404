extends Node3D

@onready var character = self.get_child(0).get_child(0) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.stop_music()
	character.hide_title()
	#play rabhole
	MusicManager.play_music("rabhole2")

	#wait 17 seconds then glitch
	await get_tree().create_timer(67.0).timeout
	character.glitch()

	#wait 5 seconds then change scene
	await get_tree().create_timer(3.0).timeout
	MusicManager.stop_music()
	get_tree().change_scene_to_file("res://end.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
