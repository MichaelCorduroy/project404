extends StaticBody3D

@onready var vater = self.get_parent().get_parent().get_parent()
@onready var anim = vater.get_child(0)



var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# opens or closes the door and plays animation
func activate():
	print("door activated")
	if open:
		anim.play("closedoor")
		open = false
	else:
		anim.play("opendoor")
		open = true
