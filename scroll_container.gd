extends ScrollContainer

const DRAG_SENSITIVITY: float = 0.35

var dragging: bool = false
var drag_start: Vector2

func _ready() -> void:
    connections()
    
func connections() -> void:
    self.gui_input.connect(_gui_input)
    
func _gui_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        dragging = event.pressed
        drag_start = event.position
    
    if event is InputEventMouseMotion and dragging:
        scroll_horizontal -= event.relative.x * DRAG_SENSITIVITY
        scroll_vertical -= event.relative.y * DRAG_SENSITIVITY
