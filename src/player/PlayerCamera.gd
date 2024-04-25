class_name PlayerCamera extends Camera3D

@export var first_person_camera: Camera3D
@export_group("Camera Settings")
@export var input_scale: float = 1.0
@export_range(0.0, 89.9) var max_camera_tilt: float = 89.0
@export_group("Position Spring Settings")
@export var external_velocity_scale: float = 3.0
@export var position_spring_coefficient: float = 80.0
@export var position_damping_coefficient: float = 20.0
@onready var position_spring := SecondaryMotion.Spring3.new(position_spring_coefficient, position_damping_coefficient)
@export_group("Recoil Spring Settings")
@export var recoil_spring_coefficient: float = 80.0
@export var recoil_damping_coefficient: float = 20.0
@onready var recoil_spring := SecondaryMotion.Spring2.new(recoil_spring_coefficient, recoil_damping_coefficient)

@onready var _camera_movement := Vector2.ZERO
# @onready var _tilt_yaw := Vector2(rotation.x, rotation.y)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	position_spring.target = position
	recoil_spring.target = Vector2(rotation.x, rotation.y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_movement -= event.relative

func _process(delta: float) -> void:
	position = position_spring.tick(delta, position)
	var move: Vector2 = input_scale * _get_camera_movement()
	recoil_spring.target.x = _clamp_tilt(recoil_spring.target.x + move.y)
	recoil_spring.target.y += move.x
	rotation.x = _clamp_tilt(rotation.x + move.y)
	rotation.y += move.x
	rotation = _recoil(delta, rotation)
	first_person_camera.global_position = global_position
	first_person_camera.global_rotation = global_rotation

func forward() -> Vector3:
	return global_basis.get_rotation_quaternion() * Vector3.FORWARD

func set_position_target(value: Vector3) -> void:
	position_spring.target = value

func add_position_velocity(value: Vector3) -> void:
	# have to fix if owner starts off with a nonzero yaw
	position_spring.velocity += external_velocity_scale * (Quaternion(Vector3.UP, -owner.rotation.y).normalized() * value)

func add_recoil_velocity(value: Vector2) -> void:
	recoil_spring.velocity += value

func _recoil(delta: float, rot: Vector3) -> Vector3:
	var recoil: Vector2 = recoil_spring.tick(delta, Vector2(rot.x, rot.y))
	return Vector3(_clamp_tilt(recoil.x), recoil.y, 0.0)

func _look(rot: Vector2) -> Vector2:
	var move: Vector2 = input_scale * _get_camera_movement()
	return Vector2(_clamp_tilt(rot.x + move.y), rot.y + move.x)

func _get_camera_movement() -> Vector2:
	var res: Vector2 = _camera_movement
	_camera_movement = Vector2.ZERO
	return res

func _clamp_tilt(value: float) -> float:
	return clamp(value, -deg_to_rad(max_camera_tilt), deg_to_rad(max_camera_tilt))
