class_name SecondaryMotion extends Node

class Spring1:
	var spring_coefficient: float
	var damping_coefficient: float
	var velocity: float = 0.0
	var target: float = 0.0

	func _init(spring: float, damping: float) -> void:
		spring_coefficient = spring
		damping_coefficient = damping

	func tick(delta: float, position: float) -> float:
		var deceleration: float = delta * damping_coefficient * velocity
		if abs(velocity) > abs(deceleration):
			velocity -= deceleration
		else:
			velocity = 0.0
		velocity += delta * spring_coefficient * (target - position)
		return position + delta * velocity

class Spring2:
	var spring_coefficient: float
	var damping_coefficient: float
	var velocity: Vector2 = Vector2.ZERO
	var target: Vector2 = Vector2.ZERO

	func _init(spring: float, damping: float) -> void:
		spring_coefficient = spring
		damping_coefficient = damping

	func tick(delta: float, position: Vector2) -> Vector2:
		var deceleration: Vector2 = delta * damping_coefficient * velocity
		if velocity.length_squared() > deceleration.length_squared():
			velocity -= deceleration
		else:
			velocity = Vector2.ZERO
		velocity += delta * spring_coefficient * (target - position)
		return position + delta * velocity


class Spring3:
	var spring_coefficient: float
	var damping_coefficient: float
	var velocity: Vector3 = Vector3.ZERO
	var target: Vector3 = Vector3.ZERO

	func _init(spring: float, damping: float) -> void:
		spring_coefficient = spring
		damping_coefficient = damping

	func tick(delta: float, position: Vector3) -> Vector3:
		var deceleration: Vector3 = delta * damping_coefficient * velocity
		if velocity.length_squared() > deceleration.length_squared():
			velocity -= deceleration
		else:
			velocity = Vector3.ZERO
		velocity += delta * spring_coefficient * (target - position)
		return position + delta * velocity
