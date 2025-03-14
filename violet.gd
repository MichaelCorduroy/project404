extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var opened = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not opened:
		anim_player.play("open")
		opened = true
	


func _on_area_3d_body_entered_portal(body: Node3D) -> void:
	if body is CharacterBody3D:
		get_tree().change_scene_to_file("res://tubeportal.tscn")
