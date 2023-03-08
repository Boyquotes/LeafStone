extends Resource
class_name GameEvent

signal OnEventHappen()

func raise_event():
	emit_signal("OnEventHappen")

