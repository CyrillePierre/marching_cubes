@tool
extends MeshInstance3D

class Cell:
	var density: Array[float]
	var points: Array[Vector3]
	var index: int

@export var resolution = 2:
	set(value):
		_resolution = value
		reset()
	get:
		return _resolution

@export var cube_size = 0.5:
	set(value):
		_cube_size = value
	get:
		return _cube_size

var _density_map: PackedFloat32Array
var _resolution: int = 2
var _cube_size: float = 0.5
var _cells: Array[Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func reset() -> void:
	if mesh is ArrayMesh:
		mesh.clear_surfaces()
	initialize_density_map()
	create_cells()
	create_mesh()
	print('cells:')
	print(_cells)

func initialize_density_map() -> void:
	_density_map = PackedFloat32Array()
	_density_map.resize(resolution ** 3)
	_density_map.fill(-1.)
	
	set_density(0, 1, 1, 1.0)
				
func get_density(i: int, j: int, k: int) -> float:
	return _density_map[i + (j + k * _resolution) * _resolution]
	
func set_density(i: int, j: int, k: int, value: float) -> void:
	_density_map[i + (j + k * _resolution) * _resolution] = value

func create_cells():
	_cells = []
	_cells.resize((resolution - 1) ** 3)
	var index = 0
	for i in range(resolution - 1):
		for j in range(resolution - 1):
			for k in range(resolution - 1):
				_cells[index] = create_cell(i, j, k)
				index += 1

func create_cell(i: int, j: int, k: int) -> Dictionary:
	var cell = {
		density = [
			get_density(i + 0, j + 0, k + 0),
			get_density(i + 1, j + 0, k + 0),
			get_density(i + 0, j + 1, k + 0),
			get_density(i + 1, j + 1, k + 0),
			get_density(i + 0, j + 0, k + 1),
			get_density(i + 1, j + 0, k + 1),
			get_density(i + 0, j + 1, k + 1),
			get_density(i + 1, j + 1, k + 1),
		],
		points = [
			get_pos(i + 0, j + 0, k + 0),
			get_pos(i + 1, j + 0, k + 0),
			get_pos(i + 0, j + 1, k + 0),
			get_pos(i + 1, j + 1, k + 0),
			get_pos(i + 0, j + 0, k + 1),
			get_pos(i + 1, j + 0, k + 1),
			get_pos(i + 0, j + 1, k + 1),
			get_pos(i + 1, j + 1, k + 1),
		],
	}
	cell.index = cube_index(cell)
	return cell
	
func cube_index(cell: Dictionary):
	var index = 0
	for i in range(8):
		if cell.density[i] > 0.: index |= 1 << i
	return index

func create_mesh() -> void:
	var vertices = PackedVector3Array()
	vertices.push_back(get_pos(0, 0, 0))
	vertices.push_back(get_pos(1, 0, 0))
	vertices.push_back(get_pos(0, 0, 1))

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh
	
func get_pos(i: int, j: int, k: int) -> Vector3:
	return Vector3(i, j, k) * _cube_size
	
