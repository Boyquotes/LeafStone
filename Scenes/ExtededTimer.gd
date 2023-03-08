extends Timer

var methodRef
var begin = false

func performTimer(seconds, method: Callable):
	start(seconds)
	begin = true
	methodRef = method

func _process(_delta):
	
	if begin:
		if is_stopped(): #is_stopped means the timer has finied to count
			if methodRef:
				methodRef.call()
				begin = false




