extends Sprite

export(Texture) var tx_zero
export(Texture) var tx_one
export(Texture) var tx_two
export(Texture) var tx_three
export(Texture) var tx_four
export(Texture) var tx_five
export(Texture) var tx_six
export(Texture) var tx_seven
export(Texture) var tx_eight
export(Texture) var tx_bomb
export(Texture) var tx_hidden

var value = "hidden" setget set_value

func set_value(v):
	value = v
	match value:
		0: self.texture = tx_zero
		1: self.texture = tx_one
		2: self.texture = tx_two
		3: self.texture = tx_three
		4: self.texture = tx_four
		5: self.texture = tx_five
		6: self.texture = tx_six
		7: self.texture = tx_seven
		8: self.texture = tx_eight
		"bomb": self.texture = tx_bomb
		"hidden": self.texture = tx_hidden
