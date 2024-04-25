class_name PlayerMovement extends Node

signal crouching(value: bool)
signal add_camera_velocity(value: Vector3)
signal transitioned(state_name: String)

@export var camera_velocity_scale: float = 100.0
@export var jump_height: float = 5.0
@export var fall_gravity: float = 19.6
@export var initial_state: NodePath = NodePath()
@onready var state: MovementState = get_node(initial_state)
var player: Player

func _ready() -> void:
	await owner.ready
	player = owner
	crouching.connect(player.change_pose)
	for child: MovementState in get_children():
		child.movement = self
		child.player = owner
	state.enter()

func _process(delta: float) -> void:
	state.tick(delta, _tick_move())

func jump() -> void:
	player.velocity.y = sqrt(2.0 * jump_height * ProjectSettings.get_setting("physics/3d/default_gravity"))

func transition_to(state_name: String, msg: Dictionary={}) -> void:
	if !has_node(state_name):
		return
	state.exit()
	state = get_node(state_name)
	state.enter(msg)
	transitioned.emit(state_name)

func transition_and_move(delta: float, dir: Vector3, state_name: String, msg: Dictionary={}) -> void:
	transition_to(state_name, msg)
	state.move(delta, dir)

func _tick_move() -> Vector3:
	var res : Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		res += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		res += Vector3.BACK
	if Input.is_action_pressed("move_right"):
		res += Vector3.RIGHT
	if Input.is_action_pressed("move_left"):
		res += Vector3.LEFT
	return Quaternion.from_euler(Vector3(0.0, player.bearing_yaw(), 0.0)) * res.normalized() # doesn't work with controllers :^)
