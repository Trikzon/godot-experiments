extends Label

func _process(delta):
	self.text = "FPS: " + String(Engine.get_frames_per_second())
