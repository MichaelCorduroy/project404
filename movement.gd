# this file defines everything immediate about the player
# this is probably the most important script in the game
# so don't mess with it unless you know what you're doing


extends CharacterBody3D

# possible idea: dreams are full screen while work is minimized 

# movement and physics variables
const SPEED = 5.0
const JUMP_VELOCITY = 7.5
const FALL_SPEED = 0.2

var sprinting = false
var tilted = false
var sprint_multiplier = 2.0

var current_speed = SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


#bobbing variables
var bob_offset = 0.0  # Stores current camera bob offset
var bob_speed = 9.0  # Adjust for desired bobbing frequency
var bob_amount = 0.01  # Adjust for desired bobbing intensity


#looking & camera variables
var MOUSE_SENSITIVITY = 0.001 
var MAX_LOOK_UP = deg_to_rad(60)  # Adjust for desired maximum look-up angle
var MAX_LOOK_DOWN = deg_to_rad(-60)  # Adjust for desired maximum look-down angle


# footstep soundfx


# 6 snow footsteps sound effects 
var snowfootstep1 = preload("res://snowstep1.wav")
var snowfootstep2 = preload("res://snowstep2.wav")
var snowfootstep3 = preload("res://snowstep3.wav")
var snowfootstep4 = preload("res://snowstep4.wav")
var snowfootstep5 = preload("res://snowstep5.wav")
var snowfootstep6 = preload("res://snowstep6.wav")

var snowfootsteps = [snowfootstep1, snowfootstep2, snowfootstep3, snowfootstep4, snowfootstep5, snowfootstep6]

# function to clear interact text
func clear_interact_text():
	#view_label.text = ""
	pass


# function to disable pixel shader
func disable_fuzz():
	FUZZ.visible = false


# node linkage
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var raycast := $Neck/Camera3D/RayCast3D
@onready var walkray := $Neck/Camera3D/walkray
@onready var view_label := $Neck/Camera3D/CanvasLayer/Label3D
@onready var visualFX := $Neck/Camera3D/VisualFX
@onready var localsound := $localsound
@onready var FUZZ = $Neck/Camera3D/fuzz 
@onready var dev_marker = $devmarker
@onready var surface_type = null
@onready var footstep_noise = null
@onready var prev_step = null
@onready var was_up = false
@onready var collision = self.get_child(1)
@onready var title = $"Neck/Camera3D/CanvasLayer/title"
@onready var intereract_text = "cheese"
@onready var spud = $"Neck/Camera3D/spud"
@onready var tutorial = $Neck/Camera3D/CanvasLayer/tutorial
@onready var tutorial_seen = false


# npc interaction variables
@onready var dialoguebox := $Neck/Camera3D/CanvasLayer/dialoguebox
@onready var speaker_label := dialoguebox.get_child(0)
@onready var dialogue_text := dialoguebox.get_child(1)
@onready var speaking := false # for detecting if player is in a conversation 
@onready var last_speaker = null # tracks the last npc that spoke to player

#head tilt variables (all onready)
@onready var is_tilting = false
@onready var tilt_duration = 2.0
@onready var tilt_elapsed = 0.0
@onready var start_tilt_rot_x = 0.0

# function to tilt head
func tilt_head(duration = 2.0):
	tilt_duration = duration
	tilt_elapsed = 0.0
	start_tilt_rot_x = camera.rotation.x
	is_tilting = true


# toggle tutorial visibility
func toggle_tutorial():
	if tutorial.visible:
		tutorial.visible = false
	elif !tutorial_seen:
		tutorial.visible = true
		tutorial_seen = true



func glitch():
	localsound.stream = preload("res://error.mp3")
	localsound.play()
	spud.play("popup")
	await get_tree().create_timer(3.0).timeout

#toggle if tutorial is visible






# look up at start of game
func looking_up():
	camera.rotation.x = MAX_LOOK_UP - 0.05
	print("looking up")

func hide_title():
	title.set("visible",false)


# npc functions
func done_speaking():
	speaking = false
	cutscening = false
	dialoguebox.hide()

func accept_dialogue(words):
	# display words one character at a time
	speaking = true
	for i in range(words.length()):
		dialogue_text.text = words.substr(0, i)
		await get_tree().create_timer(0.05).timeout
#	dialogue_text.text = words

#special variables
@onready var surface_overide = false #for walking on ground platfoms i.e cement or sidewalks
@onready var cutscening = false #for detecting if player is in a cutscene
@onready var interact_text = ""


#wooden footsteps sound effects 
#var footstep1 = preload("res://soundfx/footsteps/wdfootstep1.wav")
#var footstep2 = preload("res://soundfx/footsteps/wdfootstep2.wav")
#var footstep3 = preload("res://soundfx/footsteps/wdfootstep3.wav")
#var footstep4 = preload("res://soundfx/footsteps/wdfootstep4.wav")
#var footstep5 = preload("res://soundfx/footsteps/wdfootstep5.wav")
#var footstep6 = preload("res://soundfx/footsteps/wdfootstep6.wav")
#var footstep7 = preload("res://soundfx/footsteps/wdfootstep7.wav")

#var wooden_footsteps = [footstep1, footstep2, footstep3, footstep4, footstep5, footstep6, footstep7]

#carpet footsteps sound effects 
#var cpfootstep1 = preload("res://soundfx/footsteps/cptfootstep1.wav")
#var cpfootstep2 = preload("res://soundfx/footsteps/cptfootstep2.wav")
#var cpfootstep3 = preload("res://soundfx/footsteps/cptfootstep3.wav")
#var cpfootstep4 = preload("res://soundfx/footsteps/cptfootstep4.wav")

#var carpet_footsteps = [cpfootstep1, cpfootstep2, cpfootstep3, cpfootstep4]



#grass footsteps sound effects
#var grfootstep1 = preload("res://soundfx/footsteps/grfootstep1.wav")
#var grfootstep2 = preload("res://soundfx/footsteps/grfootstep2.wav")
#var grfootstep3 = preload("res://soundfx/footsteps/grfootstep3.wav")
#var grfootstep4 = preload("res://soundfx/footsteps/grfootstep4.wav")
#var grfootstep5 = preload("res://soundfx/footsteps/grfootstep5.wav")
#var grfootstep6 = preload("res://soundfx/footsteps/grfootstep6.wav")
#var grfootstep7 = preload("res://soundfx/footsteps/grfootstep7.wav")

#var grass_footsteps = [grfootstep1, grfootstep2, grfootstep3, grfootstep4, grfootstep5, grfootstep6, grfootstep7]

#cement footsteps sound effects
#var cemfootstep1 = preload("res://soundfx/footsteps/cemfootstep1.wav")
#var cemfootstep2 = preload("res://soundfx/footsteps/cemfootstep2.wav")
#var cemfootstep3 = preload("res://soundfx/footsteps/cemfootstep3.wav")
#var cemfootstep4 = preload("res://soundfx/footsteps/cemfootstep4.wav")
#var cemfootstep5 = preload("res://soundfx/footsteps/cemfootstep5.wav")
#var cemfootstep6 = preload("res://soundfx/footsteps/cemfootstep6.wav")
#var cemfootstep7 = preload("res://soundfx/footsteps/cemfootstep7.wav")
#var cemfootstep8 = preload("res://soundfx/footsteps/cemfootstep8.wav")

#var cement_footsteps = [cemfootstep1, cemfootstep3, cemfootstep4, cemfootstep5, cemfootstep6, cemfootstep7, cemfootstep8]


#  Called when the node enters the scene tree for the first time.
func _ready():
	
	# hide dev marker
	dev_marker.visible = false

	# set dialogue box initially invisible
	dialoguebox.visible = false

	tutorial.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		toggle_tutorial()
		if !tutorial_seen:
			tutorial_seen = true
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# Handle vertical rotation (pitch) with clamping
			var new_rotation_x = camera.rotation.x - event.relative.y * MOUSE_SENSITIVITY
			new_rotation_x = clamp(new_rotation_x, MAX_LOOK_DOWN, MAX_LOOK_UP)
			camera.rotation.x = new_rotation_x
			# handle horizontal rotation
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)



# switch item in right hand
func switch_item():
	#	accoutr.switch_item()
	pass





# trigger dream jump animation
func trigger_dream_jump():
	visualFX.play("disorient_zoom")
	# do after animation finishes
	await visualFX.animation_finished
	print("dream jumped!")

# fade screen to black
func fade_to_black():
	# dont forget to hide dialogue box
	dialoguebox.visible = false
	visualFX.play("fade")

# fade screen back from black
func fade_from_black():
	visualFX.play("return")


# function to toggle cutscene (stops player movement)	
func toggle_cutscene(action = null):
	print("cutscene toggle")
	if cutscening:
		# stop the cutscene and set the camera back to player pov
		cutscening = false
		camera.current = true
	elif not cutscening:
		# start the cutscene and clear interaction text
		cutscening = true
		view_label.text = ""
		
func _physics_process(delta):


	#head tilt logic
	if is_tilting:
		tilt_elapsed += delta
		var t = clamp(tilt_elapsed / tilt_duration, 0.0, 1.0)
		var eased_t = t * t * (3 - 2 * t) #smoothstep
		camera.rotation.x = lerp(start_tilt_rot_x, 0.0, eased_t)
		if t >= 1.0:
			is_tilting = false


	# do not move player around during cutscene
	if cutscening:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta + FALL_SPEED

		return
		
	#directional variables and input
	var input_dir = Input.get_vector("leftt", "rightt", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta + FALL_SPEED
	
	#camera bobbing
	if is_on_floor() and direction.length() > 0.1:  # Check for movement on ground
		bob_offset += delta * bob_speed
		camera.translate(Vector3(0, sin(bob_offset) * bob_amount, 0))

	# sprint logic
	if Input.is_action_pressed("sprint"):
		sprinting = true
	else:	
		sprinting = false

	current_speed = SPEED * (sprint_multiplier if sprinting else 1.0)
	
	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor() and !(self.get("metadata/operator")): 
		velocity.y = JUMP_VELOCITY
		

	# handle weapons and inventory management
	if Input.is_action_just_pressed("slot_1"):
		print("slot 1")


	#handle landingc 
	if not is_on_floor():
		was_up = true
	if was_up and is_on_floor():
		was_up = false
		
		# stream footstep sound effect
		if surface_type == "snow":
			localsound.stream = snowfootsteps.pick_random()
			pass


		'''
		if surface_type == "hardwood":
		#	localsound.stream = [footstep2, footstep5].pick_random()
			pass
		if surface_type == "carpet":
			#localsound.stream = carpet_footsteps.pick_random()
			pass
		if surface_type == "grass":
			#localsound.stream = [grfootstep6, grfootstep5, grfootstep4].pick_random()
			pass
		if surface_type == "cement":
			#localsound.stream = [cemfootstep6, cemfootstep5, cemfootstep2, cemfootstep7].pick_random()
			pass	
		'''
		localsound.play()
		
		
	#handle footsteps raycasting
	if(walkray.is_colliding()):
		var step_object = walkray.get_collider()
		surface_type = step_object.get("metadata/surface_type")
		#uncomment this to see what you're walking on
		#print(surface_type)
	
		
		
	#handle raycast vision specificfier
	if raycast.is_colliding() and !cutscening:
		var view_object = raycast.get_collider()
		#this debug prints the obeject being looked at
		#print(view_object)
		#^^uncomment to see what you're looking at in the console
		
		if view_object:
			interact_text = view_object.get("metadata/interact_text")
	
			
			if(interact_text != null):
				view_label.text = interact_text
				view_label.show() 
				if Input.is_action_just_pressed("click"):
					if(view_object.has_method("activate")):
						view_object.activate()
			else:
				#this basically runs when you aren't looking at anything to
				#interact with
				# (basically to swing dat sword lol)
			
				if Input.is_action_just_pressed("click"):
					if(view_object.has_method("activate")):
						view_object.activate()
					
				
				
				
				# handle dream jumping
				if view_object.has_method("dream_jump"):
					print("spotted view object")
					view_object.stare_time += delta
					if view_object.stare_time >= view_object.REQ_STARE_TIME:
						trigger_dream_jump()
					else:
						# set the view object's stare time to 0
						view_object.dream_jump()
			
	else:
		view_label.hide()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = direction.x * current_speed 
		velocity.z = direction.z * current_speed 
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	
		
	#check moving
	var is_moving = direction and is_on_floor()
	if is_moving:
		if !localsound.is_playing() and is_on_floor():
			if surface_type == "snow":
				footstep_noise = snowfootsteps.pick_random()
				while footstep_noise == prev_step:
					footstep_noise = snowfootsteps.pick_random()

			else:
				footstep_noise = null
			

			prev_step = footstep_noise
			localsound.stream = footstep_noise
			localsound.play()




				

	move_and_slide()


func _on_enter_button_pressed() -> void:
	MusicManager.play_music("fema")
	visualFX.play("start")
	#wait 3 seconds then tilt head
	await get_tree().create_timer(7.0).timeout
	tilt_head(3.0)
	#wait 3 seconds then turn off cutscenining
	await get_tree().create_timer(3.0).timeout
	toggle_cutscene()
	# show tutorial
	toggle_tutorial()
