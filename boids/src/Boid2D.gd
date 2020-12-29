extends KinematicBody2D
class_name Boid2D

static func init(parent: Node2D) -> Boid2D:
	var boid: Boid2D = load("res://src/Boid2D.tscn").instance()
	parent.add_child(boid)
	parent.move_child(boid, 0)
	return boid

const NICE_COLORS = [Color.aquamarine, Color.orchid, Color.lightblue, Color.lightcoral]

const VIEW_RADIUS := 100
const MAX_SPEED := 25
const MAX_FORCE := 0.4

onready var width := get_viewport().size.x
onready var height := get_viewport().size.y

var velocity := Vector2()
var acceleration := Vector2()
var sighted_boids := []

func _ready():
	self.position = Vector2(rand_range(0, width), rand_range(0, height))
	self.velocity = Vector2(rand_range(-100, 100), rand_range(-100, 100))
	$Polygon.color = NICE_COLORS[rand_range(0, NICE_COLORS.size())]

func _physics_process(delta):
	wrap_edges()
	
	flock(sighted_boids)
	var avoid_walls = avoid_walls()
	self.acceleration += avoid_walls
	
	self.position += self.velocity * delta
	self.velocity += self.acceleration
	self.velocity = self.velocity.normalized() * min(self.velocity.length(), MAX_SPEED)
	self.rotation = self.velocity.angle()
	
	self.acceleration *= 0

func avoid_walls() -> Vector2:
	for i in $Rays.get_children():
		var ray := i as RayCast2D
		if ray and ray.is_colliding():
			return (self.position - ray.get_collision_point()).normalized() * MAX_FORCE
	
	return Vector2()

func flock(boids: Array):
	var alignment := Vector2()
	var cohesion := Vector2()
	var separation := Vector2()
	var total := 0
	var separation_total := 0

	for i in boids:
		var other := i as Boid2D
		if not other or other == self:
			continue

		total += 1
		alignment += other.velocity
		cohesion += other.position
		
		var distance := other.position.distance_to(self.position)
		if distance != 0:
			separation += (self.position - other.position) / distance

	if total > 0:
		alignment /= total
		alignment = alignment.normalized() * MAX_SPEED
		alignment -= self.velocity
		alignment = alignment.normalized() * min(alignment.length(), MAX_FORCE)

		cohesion /= total
		cohesion -= self.position
		cohesion = cohesion.normalized() * MAX_SPEED
		cohesion -= self.velocity
		cohesion = cohesion.normalized() * min(cohesion.length(), MAX_FORCE)

		separation /= total
		separation = separation.normalized() * MAX_SPEED
		separation -= self.velocity
		separation = separation.normalized() * min(separation.length(), MAX_FORCE)

	self.acceleration += alignment
	self.acceleration += cohesion
	self.acceleration += separation

func wrap_edges():
	if self.position.x > width:
		self.position.x = 0
	elif self.position.x < 0:
		self.position.x = width

	if self.position.y > height:
		self.position.y = 0
	elif self.position.y < 0:
		self.position.y = height

func _on_ViewArea_body_entered(body: Node):
	var boid := body as Boid2D
	if boid:
		sighted_boids.append(body)

func _on_ViewArea_body_exited(body: Node):
	var boid := body as Boid2D
	if boid:
		var index = sighted_boids.find(body)
		if index >= 0:
			sighted_boids.remove(index)
