extends Node2D

const TileScene = preload("res://Tile.tscn")

const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 6
const GRID_Y_OFFSET: int = 48
const TILE_PIXEL_SIZE: int = 16

export var mine_count: int = 10

var grid: Dictionary = {}

func create_empty_grid() -> void:
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var tile = TileScene.instance()
			self.add_child(tile)
			
			tile.position.y = (y * TILE_PIXEL_SIZE) + GRID_Y_OFFSET
			tile.position.x = x * TILE_PIXEL_SIZE
			
			grid[Vector2(x, y)] = tile

func add_mines_to_grid() -> void:
	for _i in range(mine_count):
		# Give up after 100 tries
		for _j in range(100):
			var x = randi() % GRID_WIDTH
			var y = randi() % GRID_HEIGHT
			var pos = Vector2(x, y)
			
			if grid[pos].value != "mine":
				grid[pos].value = "mine"
				break

func calculate_tile_values() -> void:
	for tile_pos in grid:
		if grid[tile_pos].value != "mine": continue;
		
		for pos in get_surrounding_8_tiles(tile_pos, []):
			grid[pos].increment_value()

func is_on_grid(pos: Vector2) -> bool:
	return (pos.x >= 0 and pos.x < GRID_WIDTH) and (pos.y >= 0 and pos.y < GRID_HEIGHT)

func _ready() -> void:
	randomize()
	
	create_empty_grid()
	add_mines_to_grid()
	calculate_tile_values()

func _input(event):
	if event is InputEventMouseButton:
		var grid_pos = global_pos_to_grid(event.position)
		if Input.is_action_just_pressed("left_click"):
			reveal_tile(grid_pos)
		if Input.is_action_just_pressed("right_click"):
			if is_on_grid(grid_pos):
				grid[grid_pos].flag()

func reveal_tile(pos: Vector2) -> void:
	if !is_on_grid(pos): return
	
	grid[pos].reveal()
	
	var zero_tiles = []
	if grid[pos].value == "0":
		zero_tiles.append(pos)
	
	for surrounding in get_surrounding_8_tiles(pos, []):
		if grid[surrounding].value == "0" and grid[surrounding].unrevealed == true:
			zero_tiles.append(surrounding)
	
	var checked_tiles = zero_tiles.duplicate()
	# Give up after 100 tries
	for _i in range(100):
		var temp_zero_tiles = zero_tiles.duplicate()
		zero_tiles.clear()
		for zero in temp_zero_tiles:
			grid[zero].reveal()
			for surrounding in get_surrounding_8_tiles(zero, checked_tiles):
				if grid[surrounding].value == "0":
					zero_tiles.append(surrounding)
				elif grid[surrounding].value != "mine":
					grid[surrounding].reveal()
				checked_tiles.append(surrounding)

func get_surrounding_8_tiles(pos: Vector2, exclude: Array) -> Array:
	var temp_result = []
	temp_result.append(Vector2(pos.x - 1, pos.y + 0))
	temp_result.append(Vector2(pos.x - 1, pos.y + 1))
	temp_result.append(Vector2(pos.x - 1, pos.y - 1))
	temp_result.append(Vector2(pos.x + 0, pos.y + 1))
	temp_result.append(Vector2(pos.x + 0, pos.y - 1))
	temp_result.append(Vector2(pos.x + 1, pos.y + 0))
	temp_result.append(Vector2(pos.x + 1, pos.y + 1))
	temp_result.append(Vector2(pos.x + 1, pos.y - 1))
	
	var result = []
	for vector in temp_result:
		if is_on_grid(vector) and !exclude.has(vector):
			result.append(vector)
	
	return result

# Make sure to check the returned value with is_on_grid() before using it
func global_pos_to_grid(pos: Vector2) -> Vector2:
	# warning-ignore:narrowing_conversion
	var x: int = pos.x / TILE_PIXEL_SIZE
	# warning-ignore:narrowing_conversion
	var y: int = (pos.y - GRID_Y_OFFSET) / TILE_PIXEL_SIZE
	return Vector2(x, y)
