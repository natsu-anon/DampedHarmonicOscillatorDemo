class_name Player extends CharacterBody3D

@onready var camera: PlayerCamera = get_node("Player Camera")
@onready var movement_collision: CollisionShape3D = get_node("Movement Collision")

func change_pose(crouching: bool) -> void:
	if crouching:
		movement_collision.shape.height = 1.0
		movement_collision.position = Vector3(0.0, 0.5, 0.0)
		camera.set_position_target(Vector3(0.0, 0.5, 0.0))
	else:
		movement_collision.shape.height = 2.0
		movement_collision.position = Vector3(0.0, 1.0, 0.0)
		camera.set_position_target(Vector3(0.0, 1.5, 0.0))

func bearing_yaw() -> float:
	return camera.global_rotation.y
