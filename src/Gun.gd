extends Node3D

signal camera_recoil(value: Vector2)

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@export_group("Recoil Settings")
@export var recoil_constant: Vector2 = Vector2.ZERO
@export var recoil_radii: Vector2 = Vector2.ZERO
# @export_group("Particles")
@onready var particles: GPUParticles3D = get_node("FireParticles")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		if animation_player.assigned_animation == "Fire":
			animation_player.stop()
		animation_player.play("Fire")
		particles.emitting = true
		recoil()

func recoil() -> void:
	var theta: float = 2.0 * PI * randf()
	var res: Vector2 = randf() * Vector2(cos(theta), sin(theta))
	res.x *= deg_to_rad(recoil_radii.y)
	res.y *= deg_to_rad(recoil_radii.x)
	res.x += deg_to_rad(recoil_constant.y)
	res.y += deg_to_rad(recoil_constant.x)
	camera_recoil.emit(res)
