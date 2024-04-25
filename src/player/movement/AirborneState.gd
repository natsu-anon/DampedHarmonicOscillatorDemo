extends MovementState

@export_range(0.0, 1.0) var landing_scale: float = 0.4
@onready var holding_jump: bool = false
@onready var crouching: bool = false
@onready var prev_y: float = 0.0

func tick(delta: float, dir: Vector3) -> void:
	if Input.is_action_just_pressed("toggle_crouch"):
		crouching = !crouching
		movement.crouching.emit(crouching)
	holding_jump = holding_jump && Input.is_action_pressed("jump")
	prev_y = player.velocity.y
	super(delta, dir)
	if player.is_on_floor():
		if crouching:
			# movement.transition_and_move(delta, dir, "Crouch")
			movement.transition_to("Crouch")
		else:
			# movement.transition_and_move(delta, dir, "Run")
			movement.transition_to("Run")
		movement.add_camera_velocity.emit(Vector3(0, landing_scale * prev_y, 0))
		return

func enter(msg: Dictionary={}) -> void:
	super(msg)
	if msg.has("jump") && msg["jump"]:
		holding_jump = true
		movement.jump()
		movement.add_camera_velocity.emit(Vector3(0, -player.velocity.y, 0))
	else:
		holding_jump = false
	crouching = msg.has("crouching") && msg["crouching"]

func _gravity() -> float:
	if holding_jump && player.velocity.y > 0.0:
		return super()
	else:
		return movement.fall_gravity
