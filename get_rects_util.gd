extends Node2D

func _ready() -> void:
    for child in get_children():
        var r = child.texture.region
        print('"%s" = Rect2(%d, %d, %d, %d)' % [child.name, r.position.x, r.position.y, r.size.x, r.size.y])
