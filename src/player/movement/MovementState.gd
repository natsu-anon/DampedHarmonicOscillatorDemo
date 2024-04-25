class_name MovementState extends Node

@export var acceleration: float = 140
@export var friction: float = 50
@export var max_speed: float = 20

@onready var time: float = 0.0

var movement: PlayerMovement
var player: Player

func _init() -> void:
	pass

func _ready() -> void:
	pass

func tick(delta: float, dir: Vector3) -> void:
	move(delta, dir)
	time += delta

func move(delta: float, dir: Vector3) -> void:
	player.velocity = _decelerate(delta, player.velocity, _friction())
	player.velocity = _accelerate(delta, dir, player.velocity, _acceleration())
	player.velocity = _fall(delta, _gravity(), player.velocity)
	player.move_and_slide()

func enter(_msg: Dictionary={}) -> void:
	time = 0.0
	print("Enter: " + name)

func exit() -> void:
	pass

func _decelerate(delta: float, velocity: Vector3, value: float) -> Vector3:
	var y_cache: float = velocity.y
	velocity.y = 0.0
	var speed: float = velocity.length()
	if !is_zero_approx(speed):
		velocity = velocity.normalized() * max(0.0, speed - delta * value)
	velocity.y = y_cache
	return velocity

func _accelerate(delta: float, dir: Vector3, velocity: Vector3, value: float) -> Vector3:
	var delta_speed: float = delta * value
	var speed: float = _acceleration_speed(dir, velocity)
	if speed + delta_speed > max_speed:
		delta_speed = max_speed - speed
	return velocity + dir * delta_speed

func _acceleration_speed(dir: Vector3, velocity: Vector3) -> float:
	return dir.dot(velocity)

func _fall(delta: float, gravity: float, velocity: Vector3) -> Vector3:
	return velocity + delta * gravity * Vector3.DOWN

func _friction() -> float:
	return friction

func _acceleration() -> float:
	return acceleration

func _gravity() -> float:
	return ProjectSettings.get_setting("physics/3d/default_gravity")
