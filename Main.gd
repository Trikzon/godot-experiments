extends Node2D

onready var Grid = $Grid
onready var MineDisplay = $MineDisplay

var running = false

func _ready():
	randomize()
	Grid.create_new_grid()

func _on_Grid_exploaded():
	pass # Replace with function body.

func _on_Grid_won():
	pass # Replace with function body.

func _on_Grid_update_mine_count():
	MineDisplay.number = Grid.mine_count
