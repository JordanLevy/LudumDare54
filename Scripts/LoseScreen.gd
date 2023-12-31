extends CenterContainer

var label: Label

var underfill_phrases = ["You ran out of {i}!", "What kind of burrito doesn't have {i}?!"]
var overfill_phrases = ["That extra scoop of {i} was too much!", "I'm gonna have to eat this with a fork! Too much {i}", "{i} is leaking everywhere!"]

func _ready():
	label = get_node("VBoxContainer/Label")
	if GlobalManager.loss_method == GlobalManager.LossMethod.UNDERFILL:
		label.text = underfill_phrases[randi() % underfill_phrases.size()].format({"i": GlobalManager.get_ingredient_name(GlobalManager.loss_ingredient)})
	elif GlobalManager.loss_method == GlobalManager.LossMethod.OVERFILL:
			label.text = overfill_phrases[randi() % overfill_phrases.size()].format({"i": GlobalManager.get_ingredient_name(GlobalManager.loss_ingredient)})
