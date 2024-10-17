extends Node3D

@onready var player = $player
@onready var terrain = $dynamic_terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("raycast_action", _change_density)

func _change_density(point: Vector3, value: float) -> void:
	var local_point = terrain.to_local(point)
	terrain.draw_density(local_point, value, 1.)
