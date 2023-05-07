extends Tree

func _ready():
	#var tree = Tree.new()
	var root = create_item()
	hide_root = true
	columns = 2
	
	var resolution = create_item(root)
	resolution.set_text(0, "Resolution")
	resolution.set_editable(1, true)
	resolution.set_cell_mode(1, TreeItem.CELL_MODE_RANGE)
	resolution.set_text(1, "1600x1200,1200x1024,800x600")
	
	var v_sync = create_item(root)
	v_sync.set_text(0, "Vertical Sync")
	v_sync.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	v_sync.set_editable(1, true)
	
	var editable = create_item(root)
	editable.set_text(0, "Editable item"  )
	editable.set_text(1, "Placeholder")
	editable.set_editable(1, true)
	
	var spin = create_item(root)
	spin.set_text(0, "Spinner"  )
	spin.set_editable(1, true)
	spin.set_cell_mode(1, TreeItem.CELL_MODE_RANGE)
	spin.set_range_config(1, -2, 10, 1)
	
	item_edited.connect(on_item_edited)

func on_item_edited():	
	var editedItem = get_edited()

	if editedItem.get_cell_mode(1) == TreeItem.CELL_MODE_RANGE:
		print("Selected option index: ",editedItem.get_range(1))

		
	

