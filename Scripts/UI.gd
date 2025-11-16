extends Control

@onready var energy_bar = $EnergyBar
@onready var health_bar = $HealthBar
#@onready var energy_label = $EnergyLabel
@onready var skill1_cost = $SkillPanel/Skill1/Cost1
@onready var skill2_cost = $SkillPanel/Skill2/Cost2
@onready var skill3_cost = $SkillPanel/Skill3/Cost3

var player = null
var core = null

func _ready():
	energy_bar.max_value = 100
	energy_bar.value = 0
	
	skill1_cost.text = "20 Energy"
	skill2_cost.text = "30 Energy"
	skill3_cost.text = "50 Energy"
	
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	core = get_tree().get_first_node_in_group("core")
	
func _process(delta):
	if player:
		energy_bar.value = player.energy
		#energy_label.text = "Energy: " + str(player.energy) + "/" + str(player.max_energy)
	if core:
		health_bar.value = core.health
		
	update_skill_availability()

func update_skill_availability():
	if player.energy >= 20:
		skill1_cost.modulate = Color.WHITE
	else:
		skill1_cost.modulate = Color.RED
	
	if player.energy >= 30:
		skill2_cost.modulate = Color.WHITE
	else:
		skill2_cost.modulate = Color.RED
	
	if player.energy >= 50:
		skill3_cost.modulate = Color.WHITE
	else:
		skill3_cost.modulate = Color.RED
	
	
	
