extends Node2D

const TILE_PIXEL_SIZE = 16
const GRID_WIDTH = 10
const GRID_HEIGHT = 6
const GRID_Y_OFFSET = 48

const TileScene = preload("res://Tile.tscn")

var grid = {}

func _ready():
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var pos = Vector2(x, y)
			var tile = TileScene.instance()
			add_child(tile)
			
			tile.offset.y = GRID_Y_OFFSET + (y * TILE_PIXEL_SIZE)
			tile.offset.x = x * TILE_PIXEL_SIZE
			
			tile.value = "hidden"
			grid[pos] = tile

func _input(event):
	if event is InputEventMouseButton:
		print(event.position)
		var x = int(event.position.x / TILE_PIXEL_SIZE)
		var y = int((event.position.y / TILE_PIXEL_SIZE) - (GRID_Y_OFFSET / TILE_PIXEL_SIZE))
		grid[Vector2(x, y)].value = "bomb"
