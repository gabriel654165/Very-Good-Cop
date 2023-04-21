extends Node

var targets: Array[DetectableTarget] = []

func register(target: DetectableTarget):
	targets.push_back(target)

func deregister(target: DetectableTarget):
	targets.erase(target)
