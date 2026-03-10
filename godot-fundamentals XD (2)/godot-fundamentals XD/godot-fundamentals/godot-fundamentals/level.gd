extends Node2D
@export var enemy_scene: PackedScene


func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	var position: Vector2 = Vector2(
		randf_range(-600,600),
		randf_range(-350, 350)
	)
	
	while position.distance_to(Vector2(0,0))<150:
		position=Vector2(
			randf_range(-600,600),
			randf_range(-350,350)
		)
	enemy.global_position = position
