extends Control

var options: Array[UpgradeOption]
var buttons: Array[Button]

func _ready():
	options.append(UpgradeOption.new("[Upgrade0]", 1))
	options.append(UpgradeOption.new("[Upgrade1]", 2))
	options.append(UpgradeOption.new("[Upgrade2]", 3))
	buttons.append(get_node("VBoxContainer/HBoxContainer/Upgrade0"))
	buttons.append(get_node("VBoxContainer/HBoxContainer/Upgrade1"))
	buttons.append(get_node("VBoxContainer/HBoxContainer/Upgrade2"))

func begin_upgrade():
	for i in range(len(options)):
		buttons[i].text = options[i].text + "\n" + str(options[i].cost)
		buttons[i].disabled = false
	show()
	
func on_upgrade_pressed(button_id: int):
	options[button_id].purchase()
	buttons[button_id].disabled = true

class UpgradeOption:
	var text: String
	var cost: int

	func _init(text: String, cost: int):
		self.text = text
		self.cost = cost

	func purchase():
		print("Purchased " + text + " for " + str(cost))
