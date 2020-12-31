use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Label)]
pub struct FPS;

#[methods]
impl FPS {
    fn new(_owner: &Label) -> Self {
        FPS
    }

    #[export]
    fn _process(&self, owner: &Label, _delta: f32) {
        owner.set_text(format!(
            "FPS: {}",
            gdnative::api::Engine::godot_singleton().get_frames_per_second()
        ));
    }
}
