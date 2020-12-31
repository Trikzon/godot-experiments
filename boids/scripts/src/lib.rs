use gdnative::prelude::*;

mod boid;
mod fps;
mod simulation;

fn init(handle: InitHandle) {
    handle.add_class::<boid::Boid>();
    handle.add_class::<fps::FPS>();
    handle.add_class::<simulation::Simulation>();
}

godot_init!(init);
