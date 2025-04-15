extends Node3D


# character node
@onready var character = self.get_child(0).get_child(0) 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set cutscening true initially
	character.toggle_cutscene()
	# look up
	character.looking_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("Music down")
		MusicManager.stop_music()
	
