extends Node2D

var boids := []

func _ready():
	randomize()
	for i in range(250):
		boids.append(Boid2D.init(self))
