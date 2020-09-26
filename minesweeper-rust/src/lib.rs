use gdnative::prelude::*;

enum TileValue {
    ZERO
}

#[derive(NativeClass)]
#[inherit(Node)]
#[register_with(register_properties)]
struct Tile {
    //#[property(path = "base/revealed")]
    revealed: bool,
    value: TileValue
}

fn register_properties(builder: &ClassBuilder<Tile>) {
    builder
        .add_property::<bool>("base/revealed")
        .done()
}

#[gdnative::methods]
impl Tile {
    fn new(_owner: &Node) -> Self {
        Tile {
            revealed: false,
            value: TileValue::ZERO
        }
    }

    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("Hi, I'm a tile")
    }
}

fn init(handle: InitHandle) {
    handle.add_class::<Tile>();
}

godot_init!(init);
