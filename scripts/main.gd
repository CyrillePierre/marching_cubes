extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.connect("raycast_action", _change_density)


func _change_density(point: Vector3, value: float) -> void:
	$dynamic_terrain.draw_density(point, value, 2.)
