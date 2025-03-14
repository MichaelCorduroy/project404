extends Node3D


@onready var shelf = $shelf
@export var speed = 2.0
@onready var char = self.get_parent().get_child(0).get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	char.toggle_cutscene("portal")
func _process(delta):
	shelf.position.y -= speed * delta  # Moves tunnel upward, making player feel slower
	pass
