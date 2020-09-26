extends Sprite

onready var AnimPlayer = $AnimationPlayer

var unrevealed: bool = true
var is_flag: bool = false setget set_flag
var value: String = "0"

func reveal() -> void:
	unrevealed = false
	play_animation(value)

func set_flag(value: bool) -> void:	
	is_flag = value
	if value:
		play_animation("flag")
	else:
		play_animation("unreveal")

func is_mine() -> bool:
	return value == "mine"

func play_animation(animation: String) -> void:
	match animation:
		"0": AnimPlayer.play("Zero")
		"1": AnimPlayer.play("One")
		"2": AnimPlayer.play("Two")
		"3": AnimPlayer.play("Three")
		"4": AnimPlayer.play("Four")
		"5": AnimPlayer.play("Five")
		"6": AnimPlayer.play("Six")
		"7": AnimPlayer.play("Seven")
		"8": AnimPlayer.play("Eight")
		"mine": AnimPlayer.play("Mine")
		"flag": AnimPlayer.play("Flag")
		"unreveal": AnimPlayer.play("Unrevealed")
		_: print("Attempted to play animation for tile: ", animation)

func increment_value() -> void:
	if value == "mine": return
	self.value = String(int(value) + 1)
