use gdnative::api::KinematicBody2D;
use gdnative::prelude::*;
use rand::prelude::*;

const MAX_SPEED: f32 = 25.0;
const MAX_FORCE: f32 = 0.4;

#[derive(NativeClass)]
#[inherit(KinematicBody2D)]
pub struct Boid {
    #[property]
    velocity: Vector2,
    #[property]
    acceleration: Vector2,
    sighted_boids: Vec<Ref<KinematicBody2D>>,
}

#[methods]
impl Boid {
    fn new(_owner: &KinematicBody2D) -> Self {
        Boid {
            velocity: Vector2::zero(),
            acceleration: Vector2::zero(),
            sighted_boids: vec![],
        }
    }

    #[export]
    fn _ready(&mut self, owner: &KinematicBody2D) {
        let mut rng = thread_rng();
        let screen_size = unsafe { owner.get_viewport().unwrap().assume_safe().size() };

        owner.set_position(Vector2::new(
            rng.gen_range(10..(screen_size.x as i32) - 10) as f32,
            rng.gen_range(10..(screen_size.y as i32) - 10) as f32,
        ));
        self.velocity = Vector2::new(
            rng.gen_range(-MAX_SPEED..MAX_SPEED) as f32,
            rng.gen_range(-MAX_SPEED..MAX_SPEED) as f32,
        );
    }

    #[export]
    fn _physics_process(&mut self, owner: &KinematicBody2D, delta: f64) {
        self.acceleration += self.flock(owner);

        owner.set_position(owner.position() + (self.velocity * (delta as f32)));
        self.velocity += self.acceleration;
        self.velocity =
            self.velocity.normalize() * f32::min(self.velocity.length(), MAX_SPEED as f32);
        owner.set_rotation_degrees(self.velocity.angle_from_x_axis().to_degrees() as f64);

        self.acceleration *= 0.0;
    }

    fn flock(&self, owner: &KinematicBody2D) -> Vector2 {
        let mut alignment = Vector2::zero();
        let mut coheision = Vector2::zero();
        let mut separation = Vector2::zero();

        for boid in self.sighted_boids.iter() {
            let boid = unsafe { boid.assume_safe() };
            alignment += boid.get("velocity").to_vector2();
            coheision += boid.position();

            let distance = boid.position().distance_to(owner.position());
            if distance != 0.0 {
                separation += (owner.position() - boid.position()) / distance;
            }
        }
        let total = self.sighted_boids.len() as f32;
        if total != 0.0 {
            alignment /= total;
            alignment = alignment.normalize() * MAX_SPEED;
            alignment -= self.velocity;
            alignment = alignment.normalize() * f32::min(alignment.length(), MAX_FORCE);

            coheision /= total;
            coheision -= owner.position();
            coheision = coheision.normalize() * MAX_SPEED;
            coheision -= self.velocity;
            coheision = coheision.normalize() * f32::min(coheision.length(), MAX_FORCE);

            separation /= total;
            separation = separation.normalize() * MAX_SPEED;
            separation -= self.velocity;
            separation = separation.normalize() * f32::min(separation.length(), MAX_FORCE);
        }
        alignment + coheision + separation
    }

    #[export]
    fn _on_view_area_body_entered(&mut self, owner: &KinematicBody2D, body: Ref<KinematicBody2D>) {
        let boid = unsafe { body.assume_safe() };
        if boid.get_instance_id() != owner.get_instance_id() {
            self.sighted_boids.push(body);
        }
    }

    #[export]
    fn _on_view_area_body_exited(&mut self, owner: &KinematicBody2D, body: Ref<KinematicBody2D>) {
        let boid = unsafe { body.assume_safe() };
        if boid.get_instance_id() != owner.get_instance_id() {
            if let Some(index) = self.sighted_boids.iter().position(|&b| b == body) {
                self.sighted_boids.remove(index);
            }
        }
    }
}
