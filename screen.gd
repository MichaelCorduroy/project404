extends MeshInstance3D

@onready var viewport = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_surface_override_material(0).albedo_texture = viewport.get_texture()

	#wait 10 seconds then queue free self
	await get_tree().create_timer(35.0).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
