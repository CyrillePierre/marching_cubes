extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const MOUSE_SENSITIVITY_X = .4
const MOUSE_SENSITIVITY_Y = .2
const CAM_ANGLE_MAX = 70

@onready var camera = get_node("rotation_point/camera")
@onready var rotPt = get_node("rotation_point")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY_X))
		var xAngle = rotPt.rotation_degrees.x - event.relative.y * MOUSE_SENSITIVITY_Y
		rotPt.rotation_degrees.x = clamp(xAngle, -CAM_ANGLE_MAX, CAM_ANGLE_MAX)
