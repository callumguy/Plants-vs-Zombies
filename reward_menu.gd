extends Control

var image_texturerect: TextureRect
var description_label: Label


var reward: Variant # string or null

func _ready() -> void:
    image_texturerect = %Image
    description_label = %Description
    
    reward = LevelData.get_level_info(LevelManager.level_number, 'reward')
    
    set_texture(reward)
    if reward:
        var reward_type = reward.split("/")[0]
        var reward_name = reward.split("/")[1]
        
        var description: String
        if reward_type == "plant":
            description = PlantData.plants[reward_name]['description']
        description_label.text = description
        
func set_texture(reward: Variant) -> void:
    if not reward is String:
        return
    image_texturerect.texture = Rewards.get_texture(reward)
    
