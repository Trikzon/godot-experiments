extends Node2D

onready var Hundreds: Sprite = $Hundreds
onready var Tens: Sprite = $Tens
onready var Ones: Sprite = $Ones

export(Texture) var zero
export(Texture) var one
export(Texture) var two
export(Texture) var three
export(Texture) var four
export(Texture) var five
export(Texture) var six
export(Texture) var seven
export(Texture) var eight
export(Texture) var nine

var number: int = 0 setget set_number

func set_number(value: int):
	number = value
	
	set_sprite_texture(Ones, value % 10)
# warning-ignore:integer_division
	value = value / 10
	set_sprite_texture(Tens, value % 10)
# warning-ignore:integer_division
	value = value / 10
	set_sprite_texture(Hundreds, value % 10)

func set_sprite_texture(sprite: Sprite, value: int):
	match value:
		0: sprite.texture = zero
		1: sprite.texture = one
		2: sprite.texture = two
		3: sprite.texture = three
		4: sprite.texture = four
		5: sprite.texture = five
		6: sprite.texture = six
		7: sprite.texture = seven
		8: sprite.texture = eight
		9: sprite.texture = nine
