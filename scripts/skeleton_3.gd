extends Node2D


func _ready(): # make skeleton resource unique
    var skeleton_2d: Skeleton2D = $Skeleton2D
    var resource := skeleton_2d.get_modification_stack().duplicate()
    skeleton_2d.set_modification_stack(resource)
