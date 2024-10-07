@tool
extends MeshInstance3D

@export var resolution = 4:
	set(value):
		_resolution = value
		reset()
	get:
		return _resolution

@export var cube_size = 0.5

var _density_map: PackedFloat32Array
var _resolution: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset() -> void:
	_ready()

func _initialize_density_map() -> void:
	_density_map = PackedFloat32Array()
	_density_map.resize(resolution ** 3)
	_density_map.fill(0)
	
	for i in range(resolution):
		for j in range(resolution):
			for k in range(resolution):
				pass
