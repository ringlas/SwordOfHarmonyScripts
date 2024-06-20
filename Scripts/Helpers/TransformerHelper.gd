class_name TransformHelper

static func remove_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()


## Get an array of all the descendants of the given node, and includes the given node
static func _get_all_descendants(node: Node) -> Array:
	var all_descendants = [node]
	
	var children = node.get_children()
	for child in children:
		all_descendants.append_array(_get_all_descendants(child))

	return all_descendants


static func sort_ascending(a: Variant, b: Variant):
	if a.name[0] < b.name[0]:
		return true
	return false
