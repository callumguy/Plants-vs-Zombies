extends TextureButton

signal clicked

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        clicked.emit()
