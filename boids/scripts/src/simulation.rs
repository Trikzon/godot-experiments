use gdnative::prelude::*;

const BOID_COUNT: usize = 250;

#[derive(NativeClass)]
#[inherit(Node2D)]
pub struct Simulation {
    boid_template: Option<Ref<PackedScene, ThreadLocal>>,
}

#[methods]
impl Simulation {
    fn new(_owner: &Node2D) -> Self {
        Simulation {
            boid_template: None,
        }
    }

    #[export]
    fn _ready(&mut self, owner: &Node2D) {
        self.boid_template = load_scene("res://scenes/Boid.tscn");
        if let Some(boid_template) = &self.boid_template {
            for _ in 0..BOID_COUNT {
                match instance_scene::<Node2D>(boid_template) {
                    Ok(boid) => owner.add_child(boid.into_shared(), false),
                    Err(e) => godot_warn!("Could not instance child boid : {:?}", e),
                }
            }
        } else {
            godot_error!("Could not load boid scene.");
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum ManageErrs {
    CouldNotMakeInstance,
    RootClassNotSpatial(String),
}

pub fn load_scene(path: &str) -> Option<Ref<PackedScene, ThreadLocal>> {
    let scene = ResourceLoader::godot_singleton().load(path, "PackedScene", false)?;
    let scene = unsafe { scene.assume_thread_local() };
    scene.cast::<PackedScene>()
}

fn instance_scene<Root>(scene: &PackedScene) -> Result<Ref<Root, Unique>, ManageErrs>
where
    Root: gdnative::GodotObject<RefKind = ManuallyManaged> + SubClass<Node>,
{
    let instance = scene
        .instance(PackedScene::GEN_EDIT_STATE_DISABLED)
        .ok_or(ManageErrs::CouldNotMakeInstance)?;
    let instance = unsafe { instance.assume_unique() };

    instance
        .try_cast::<Root>()
        .map_err(|instance| ManageErrs::RootClassNotSpatial(instance.name().to_string()))
}
