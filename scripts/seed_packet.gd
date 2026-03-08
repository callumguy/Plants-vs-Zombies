extends Control
class_name SeedPacket

@export var plant_name: String = "peashooter"
@onready var plant_data: Dictionary = PlantData.plants.get(plant_name)

var plant_cost: int
var plant_recharge: float

@onready var shader_material: ShaderMaterial = $TextureRect.material
@onready var texturerect: TextureRect = $TextureRect
@onready var cost_label: Label = $CostLabel

# Battle Stuff
@onready var timer: Timer = $Timer
var packed_plant_scene: PackedScene

func setup() -> void:
    var plant_atlas_icon_rect: Rect2 = plant_data.get("icon_region")
    texturerect.texture.region = plant_atlas_icon_rect
    
    plant_cost = plant_data.get("cost")
    cost_label.text = str(plant_cost)
    
func battle_setup() -> void:
    plant_recharge = plant_data.get("recharge")
    timer.wait_time = plant_recharge
    
    var region = texturerect.texture.region
    var tex_size = texturerect.texture.get_atlas().get_size()
        
    texturerect.material.set_shader_parameter("uv_start", region.position / tex_size)
    texturerect.material.set_shader_parameter("uv_size", region.size / tex_size)
    
    packed_plant_scene = plant_data.get("scene")
