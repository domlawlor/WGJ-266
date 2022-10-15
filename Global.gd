extends Node

func _ready():
	randomize()
	
# enum
enum Death {
	HIT,
	BURN,
	SPIKES
}

# global variables
var Daytime = false

#1 is burn free, 0 is completely burnt
var Burn = 1.0


# helper functions
func normalize(minVal, maxVal, val):
	var inverse = minVal > maxVal
	if inverse:
		var tmp = maxVal
		maxVal = minVal
		minVal = tmp
	var r = abs(maxVal - minVal)
	var rVal = val - minVal
	var res = rVal / maxVal
	if inverse:
		return 1 - res
	else:
		return res
