class_name EnemyState
extends State

# Typed reference to the entity node.
var entity: Enemy

func _ready() -> void:
	# The states are children of the `entity` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `entity` type.
	# If the `owner` is not a `entity`, we'll get `null`.
	entity = owner as Enemy
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `entity.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(entity != null)
