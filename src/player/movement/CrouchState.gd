extends MovementState

@export_group("Slide Settings")
@export_range(0.0, 10.0) var slide_duration: float = 3.0
@export var friction_scale: Curve

func tick(delta: float, dir: Vector3) -> void:
	if Input.is_action_pressed("jump"):
		movement.transition_and_move(delta, dir, "Airborne", {"jump": true, "crouching": true})
		return
	elif !player.is_on_floor():
		movement.transition_and_move(delta, dir, "Airborne", {"jump": false, "crouching": true})
		return
	elif Input.is_action_just_pressed("toggle_crouch"):
		movement.crouching.emit(false)
		movement.transition_and_move(delta, dir, "Run")
		return
	super(delta, dir)

func enter(msg: Dictionary={}) -> void:
	super(msg)
	time = 0.0 if player.velocity.length_squared() > max_speed * max_speed else slide_duration

func _friction() -> float:
	if is_zero_approx(slide_duration):
		return friction
	else:
		return friction_scale.sample(time / slide_duration) * friction
