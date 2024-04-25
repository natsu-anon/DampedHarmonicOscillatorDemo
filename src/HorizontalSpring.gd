class_name HorizontalSpring extends Node3D

@export var spring_coefficient: float
@export var damping_coefficient: float = 1.0
@export var click_velocity: float = 50.0
@onready var velocity: float = 0.0
@onready var ideal_x: float = position.x

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_horizontal"):
		print("just pressed")
		ideal_x += 10
	elif Input.is_action_just_released("move_horizontal"):
		print("just released")
		ideal_x -= 10
	if Input.is_action_just_pressed("add_velocity"):
		print("add_velocity")
		velocity += click_velocity
		# print(v)
	position.x = _spring_movement(delta)

func _spring_movement(delta: float) -> float:
	var deceleration: float = delta * damping_coefficient * velocity
	# check to prevent overdamping
	if abs(velocity) > abs(deceleration):
		velocity -= deceleration
	else:
		velocity = 0.0
	velocity += delta * spring_coefficient * (ideal_x - position.x)
	return position.x + delta * velocity
