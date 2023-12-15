extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var visuals = $visuals
@onready var animation_player = $visuals/TinyHero/AnimationPlayer

var SPEED = 3
const JUMP_VELOCITY = 4.5

var walking_speed = 3.0
var running_speed = 5.0
#if I need to lock the character in an animation 
var is_locked = false

@export var sens_horiz = 0.2
@export var sens_vert = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horiz))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horiz))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vert))


func _physics_process(delta):
	
	if !animation_player.is_playing():
		is_locked = false
	
	if Input.is_action_just_pressed("atk"):
		if animation_player.current_animation != "sword_atk":
			animation_player.play("sword_atk")
			is_locked = true	
			
	if Input.is_action_pressed("run"):
		SPEED = running_speed
	else:
		SPEED = walking_speed
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if !is_locked:
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if SPEED == running_speed:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
			

				
			visuals.look_at(position + direction)
			
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()