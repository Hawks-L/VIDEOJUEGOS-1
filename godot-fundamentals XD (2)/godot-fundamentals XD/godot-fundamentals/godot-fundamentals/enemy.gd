extends Area2D

@export var polygon: Polygon2D
@export var sprite: Sprite2D
@export var collision_node: CollisionShape2D

@export var destroy_delay: float = 0.06
@export var AudioDead : AudioStreamPlayer2D

func _ready() -> void:
	randomize()
	rotation_degrees = randf_range(0.0, 360.0)
	
	if collision_node:
		collision_node.set_deferred("disabled", true)
	
	if polygon:
		var new_color = Color.from_hsv(randf(), 0.5, 1.0)
		polygon.modulate = new_color
		
	var tween = create_tween()
	tween.tween_property(
		polygon,
		"scale",
		Vector2(1,1)
		,0.2
	).from(Vector2(1.5,1.5))


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.queue_free()
		die()
		AudioDead.play()

func die() -> void:
	if sprite:
		sprite.modulate = Color.WHITE
	
	await get_tree().create_timer(destroy_delay).timeout
	queue_free()
