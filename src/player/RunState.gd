extends MovementState

@export_range(0.0, 1.0) var lurch_scale: float = 0.1
@onready var prev_velocity := Vector3.ZERO
@onready var prev_dir := Vector3.ZERO

func tick(delta: float, dir: Vector3) -> void:
	if Input.is_action_pressed("jump"):
		movement.transition_and_move(delta, dir, "Airborne", {"jump": true, "crouching": false})
		return
	elif !player.is_on_floor():
		movement.transition_and_move(delta, dir, "Airborne", {"jump": false, "crouching": false})
		return
	elif Input.is_action_just_pressed("toggle_crouch"):
		movement.crouching.emit(true)
		movement.transition_and_move(delta, dir, "Crouch")
		return
	prev_velocity = player.velocity
	super(delta, dir)
	if dir.dot(prev_dir) <= 0.0 && !prev_velocity.is_zero_approx():
		movement.add_camera_velocity.emit(lurch_scale * prev_velocity)
	elif player.is_on_wall() && prev_velocity.dot(player.velocity) < 0.0:
		movement.add_camera_velocity.emit(lurch_scale * prev_velocity)
	prev_dir = dir
