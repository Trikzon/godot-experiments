extends Node2D

onready var Grid = $Grid
onready var MineDisplay = $MineDisplay
onready var TimeDisplay = $TimeDisplay
onready var GameTimer = $GameTimer

var time: int = 0 setget set_time

func _ready():
	randomize()
	Grid.create_new_grid()

func _on_Grid_exploaded():
	GameTimer.stop()
	$ExplodeSound.play()

func _on_Grid_won():
	GameTimer.stop()

func _on_Grid_update_mine_count():
	MineDisplay.number = Grid.mine_count

func _on_Timer_timeout():
	self.time += 1

func _on_Grid_reveal_tile():
	if GameTimer.is_stopped():
		GameTimer.start()
	
	$RevealSound.play()

func set_time(value):
	if time < 999:
		time = value
		$TimeDisplay.number = value

func _on_TextureButton_pressed():
	Grid.create_new_grid()
	self.time = 0
	GameTimer.stop()

func _on_Grid_flag():
	$FlagSound.play()
