extends Node2D

enum MOVEMENT_TYPE {stopped, normalspeed, slow}

var timer = 0
export var waitTime = 5.0
var isTime = false


func setTimeOut(seconds):
    waitTime = seconds

func reSetTimer():
    timer = 0

func onTime():
    return isTime

func getSeconds():
    return timer

func _process(delta):
    timer += delta

    if timer >= waitTime:
        isTime = true
    else:
        isTime = false
    

