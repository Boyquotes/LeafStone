extends Resource
class_name IntGameEvent

signal OnEventRaised(value: int)
var value : int = 0

func raise_event(value: int):
	if OnEventRaised != null:
		self.value = value
		emit_signal("OnEventRaised", value)
