class_name BattlePacket extends SeedPacket
signal clicked(battle_packet: BattlePacket)

func _ready() -> void:
    setup()
    timer.start(recharge)
    set_cooldown(recharge)
    
    # connections
    var placement_manager = get_tree().current_scene.find_child("PlacementManager")
    placement_manager.tower_placed.connect(_on_tower_placed)        
    var currency: Currency = get_tree().current_scene.find_child("CurrencyComponent")
    currency.currency_changed.connect(_currency_changed)

func set_cooldown(percent: float) -> void:
    shader_material.set_shader_parameter("cooldown", percent)
    
func _on_tower_placed(tower: PackedScene) -> void:
    if tower == scene:
        timer.start()
    
func _process(delta: float) -> void:
    var cooldown_percent = timer.time_left / timer.wait_time
    set_cooldown(cooldown_percent)

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        emit_signal("clicked", self)

func _currency_changed(new_amount) -> void:
    if cost > new_amount:
        texturerect.material.set_shader_parameter("too_expensive", true)
    else:
        texturerect.material.set_shader_parameter("too_expensive", false)
