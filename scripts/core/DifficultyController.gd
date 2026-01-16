extends Node

enum Difficulty {
	Easy,
	Normal,
	Hard
}
	

var difficulty := Difficulty.Easy


func multiplier() -> float:
	match difficulty:
		Difficulty.Easy:
			return 1
		Difficulty.Normal:
			return 1.33
		Difficulty.Hard:
			return 2
	return 1