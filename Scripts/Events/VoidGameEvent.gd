extends Resource
class_name VoidGameEvent

signal OnEventHappen()

func raise_event():
	emit_signal("OnEventHappen")

