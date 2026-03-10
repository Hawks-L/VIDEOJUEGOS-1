extends Node2D

@export var bullet_scene: PackedScene
@export var polygon: Sprite2D
@export var audioStream: AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hola mundo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(
		get_global_mouse_position()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed: 
			var bullet = bullet_scene.instantiate()
			add_child(bullet)
			bullet.global_transform = global_transform
			bullet.apply_central_impulse(global_transform.x * 1000)
			audioStream.play()
			
			var tween = create_tween()
			tween.tween_property(polygon,"position",Vector2.ZERO,0.2).from(Vector2(35,0))
			
