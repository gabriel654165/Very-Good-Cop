extends Node

var level : int = 1

# Arrays of doors stored at their door bitflag index
# Every door which only has a bottom door will be stored at index [0b0001] so index [1]
var rooms_repository: Array
