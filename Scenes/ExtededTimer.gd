extends Timer

var methodRef
var begin = false

func performTimer(seconds, method: FuncRef):
	start(seconds)
	begin = true
	methodRef = method


func _process(delta):
	
	if begin:
		if is_stopped(): #is_stopped means the timer has finied to count
			if methodRef:
				methodRef.call_func()
				begin = false




