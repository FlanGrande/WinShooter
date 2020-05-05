extends Control

export var label = "label"

# Called when the node enters the scene tree for the first time.
func _ready():
	$lbl.text = label

func set_debug_label(lbl):
	$lbl.text = lbl

func set_debug_value(txt):
	$txt.text = txt

func set_debug_line(lbl, txt):
	$lbl.text = lbl
	$txt.text = txt
