class_name SeedPacket extends Control

var plant_id: String

var display_name: String
var description: String
var icon_rect: Rect2

var cost: int
var recharge: float
var scene: PackedScene

var texturerect: TextureRect
var shader_material: ShaderMaterial
var cost_label: Label
var timer: Timer

var recharge_time_left: float:
    get: return timer.time_left

func setup() -> void:
    var plant: Dictionary = PlantData.plants.get(plant_id)
    
    display_name = plant_id # add a name section to plant data
    description = plant.get("description")
    icon_rect = plant.get("icon_region")
    
    cost = plant.get("cost")
    recharge = plant.get("recharge")
    scene = plant.get("scene")


    texturerect = $TextureRect
    shader_material = texturerect.material
    cost_label = $CostLabel
    timer = $RechargeTimer # only used during battle
    
    texturerect.texture.region = icon_rect
    
    var region = texturerect.texture.region
    var tex_size = texturerect.texture.get_atlas().get_size()
    texturerect.material.set_shader_parameter("uv_start", region.position / tex_size)
    texturerect.material.set_shader_parameter("uv_size", region.size / tex_size)
    
    cost_label.text = str(cost)
    timer.wait_time = recharge
    
    



#func setup() -> void:
    #pass
    ##texturerect.texture.region = icon_rect
    ##cost_label.text = str(cost)
    #
#func battle_setup() -> void:
    #pass
    ## timer.wait_time = recharge
    #
    ##var region = texturerect.texture.region
    ##var tex_size = texturerect.texture.get_atlas().get_size()
        ##
    ##texturerect.material.set_shader_parameter("uv_start", region.position / tex_size)
    ##texturerect.material.set_shader_parameter("uv_size", region.size / tex_size)
    ##
