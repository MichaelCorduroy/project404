extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
var MAX_LOOK_UP = deg_to_rad(60)  # Adjust for desired maximum look-up angle
var MAX_LOOK_DOWN = deg_to_rad(-60)  # Adjust for desired maximum look-down angle


#node linkage 
@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var body = $Mesh


# runs on start 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.body.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("leftt", "rightt", "forwardd", "downn")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)





func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var new_rotation_x = camera.rotation.x - event.relative.y * MOUSE_SENSITIVITY
			new_rotation_x = clamp(new_rotation_x, MAX_LOOK_DOWN, MAX_LOOK_UP)
			camera.rotation.x = new_rotation_x
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)








	move_and_slide()
