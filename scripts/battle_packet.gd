extends SeedPacket

signal clicked(plant_scene)

func _ready() -> void:
    setup()
  
    battle_setup()
    set_cooldown(plant_recharge)
    
    var placement_manager = get_tree().current_scene.find_child("PlacementManager")
    placement_manager.tower_placed.connect(_on_tower_placed)        
    
    var currency: Currency = get_tree().current_scene.find_child("CurrencyComponent")
    currency.currency_changed.connect(_currency_changed)
    
    _currency_changed(currency.starting_amount)
    
func set_cooldown(percent: float) -> void:
    shader_material.set_shader_parameter("cooldown", percent)

func _on_tower_placed(tower: PackedScene) -> void:
    if tower == packed_plant_scene:
        timer.start()
    
func _process(delta: float) -> void:
    var cooldown_percent = timer.time_left / timer.wait_time
    set_cooldown(cooldown_percent)

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        emit_signal("clicked", packed_plant_scene)

func _currency_changed(new_amount) -> void:
    if plant_cost > new_amount:
        $TextureRect.material.set_shader_parameter("too_expensive", true)
    else:
        $TextureRect.material.set_shader_parameter("too_expensive", false)
