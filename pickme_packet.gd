class_name PickmePacket extends SeedPacket
signal clicked(seed_packet)

var is_picked: bool = false
var menu_pos: Vector2

func _ready() -> void:
    setup()
    #texturerect.texture.region = icon_rect
    #cost_label.text = str(cost)
    
    await get_tree().process_frame
    menu_pos = global_position

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        emit_signal("clicked", self)

        
    
    
