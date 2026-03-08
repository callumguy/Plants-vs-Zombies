extends SeedPacket

signal clicked(seed_packet)

var is_picked: bool = false
var menu_pos: Vector2

func _ready() -> void:
    setup()
    
    await get_tree().process_frame
    menu_pos = global_position

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        emit_signal("clicked", self)

        
#func picked() -> void:
    #mouse_filter = Control.MOUSE_FILTER_IGNORE
    #var tween = create_tween()
    #
    #if is_picked:
        #tween.tween_property(self, "global_position", menu_pos, 0.1)
    #else:
        #tween.tween_property(self, "global_position", seed_bar.position, 0.1)
        #
    #is_picked = not is_picked
    #
    #emit_signal("clicked", self)
    #await tween.finished
    #mouse_filter = Control.MOUSE_FILTER_STOP
    
    
