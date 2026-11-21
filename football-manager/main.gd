extends Control

const PLAYERS := [
	{"name":"Bukayo Saka", "pos":"RW", "ovr":88, "nation":"ENG"},
	{"name":"Erling Haaland", "pos":"ST", "ovr":94, "nation":"NOR"},
	{"name":"Kylian Mbappe", "pos":"LW", "ovr":95, "nation":"FRA"},
	{"name":"Jude Bellingham", "pos":"CM", "ovr":92, "nation":"ENG"},
	{"name":"Rodri", "pos":"CDM", "ovr":91, "nation":"ESP"},
	{"name":"Kevin De Bruyne", "pos":"CM", "ovr":90, "nation":"BEL"},
	{"name":"Andrew Robertson", "pos":"LB", "ovr":86, "nation":"SCO"},
	{"name":"Virgil van Dijk", "pos":"CB", "ovr":91, "nation":"NED"},
	{"name":"William Saliba", "pos":"CB", "ovr":89, "nation":"FRA"},
	{"name":"Trent Alexander", "pos":"RB", "ovr":88, "nation":"ENG"},
	{"name":"Thibaut Courtois", "pos":"GK", "ovr":90, "nation":"BEL"},
	{"name":"Phil Foden", "pos":"CAM", "ovr":89, "nation":"ENG"},
	{"name":"Harry Kane", "pos":"ST", "ovr":92, "nation":"ENG"},
	{"name":"Declan Rice", "pos":"CDM", "ovr":89, "nation":"ENG"},
	{"name":"Cole Palmer", "pos":"RW", "ovr":87, "nation":"ENG"}
]

var selected_index := 1
var formation := "4-3-3"
var detail_label: Label
var formation_button: OptionButton
var status_label: Label

class PlayerCard extends Button:
	var data: Dictionary = {}
	var is_selected := false

	func _ready() -> void:
		custom_minimum_size = Vector2(104, 116)
		focus_mode = Control.FOCUS_NONE
		flat = true
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	func _draw() -> void:
		var w := size.x
		var h := size.y
		var cut := 19.0
		var pts := PackedVector2Array([
			Vector2(cut, 2), Vector2(w-cut, 2), Vector2(w-2, cut),
			Vector2(w-2, h-cut), Vector2(w-cut, h-2),
			Vector2(cut, h-2), Vector2(2, h-cut), Vector2(2, cut)
		])
		var rating := int(data.get("ovr", 60))
		var edge := _rating_color(rating)
		draw_colored_polygon(pts, Color(0.025, 0.07, 0.14, 0.97))
		var inner := pts.duplicate()
		for i in range(inner.size()):
			inner[i] = inner[i] * 0.91 + Vector2(w, h) * 0.045
		draw_colored_polygon(inner, Color(edge.r, edge.g, edge.b, 0.18))
		var outline := pts.duplicate()
		outline.append(pts[0])
		draw_polyline(outline, Color.WHITE if is_selected else edge, 4.0 if is_selected else 2.5, true)
		var font := ThemeDB.fallback_font
		draw_string(font, Vector2(13, 32), str(rating), HORIZONTAL_ALIGNMENT_LEFT, -1, 25, Color.WHITE)
		draw_string(font, Vector2(13, 51), str(data.get("pos", "")), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, edge)
		draw_line(Vector2(12, 59), Vector2(w-12, 59), edge, 1.2)
		draw_string(font, Vector2(w/2, 78), str(data.get("nation", "")), HORIZONTAL_ALIGNMENT_CENTER, -1, 10, Color(0.8,0.88,1))
		var player_name := str(data.get("name", ""))
		var words := player_name.split(" ")
		var short_name := words[0] if words.size() == 1 else words[words.size()-1]
		draw_string(font, Vector2(w/2, 96), short_name, HORIZONTAL_ALIGNMENT_CENTER, w-8, 11, Color.WHITE)
		draw_string(font, Vector2(w/2, 108), "PLAYER", HORIZONTAL_ALIGNMENT_CENTER, -1, 8, Color(0.62,0.73,0.88))

	func _pressed() -> void:
		pass

	func _rating_color(rating: int) -> Color:
		if rating >= 95: return Color("#b66cff")
		if rating >= 90: return Color("#e6bd43")
		if rating >= 80: return Color("#cbd5e1")
		if rating >= 70: return Color("#c9824a")
		return Color("#718096")


func _ready() -> void:
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	_build_interface()
	_load_save()


func _build_interface() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#07152a")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var header := _panel(Color("#102b4d"), Rect2(0, 0, 1280, 82))
	_add_label(header, "REAL MADRID  |  CLUB MANAGER", Rect2(28, 15, 410, 34), 25, Color.WHITE)
	_add_label(header, "LEVEL 1     •     COINS  5,000     •     ENERGY  100/100", Rect2(700, 23, 550, 30), 16, Color("#f3d36a"))

	var nav := _panel(Color("#0d2442"), Rect2(0, 82, 116, 638))
	var nav_items := ["SQUAD", "TACTICS", "TRANSFERS", "LEAGUE", "CLUB"]
	for i in range(nav_items.size()):
		_add_label(nav, nav_items[i], Rect2(8, 30 + i*92, 100, 35), 13, Color("#d9e7f7"), HORIZONTAL_ALIGNMENT_CENTER)

	var pitch := _panel(Color("#17613d"), Rect2(128, 100, 824, 570))
	_draw_pitch(pitch)
	_add_label(pitch, "STARTING XI", Rect2(18, 8, 180, 24), 14, Color("#e5ffed"))

	var coords := [
		Vector2(135, 70), Vector2(360, 45), Vector2(585, 70),
		Vector2(155, 205), Vector2(360, 190), Vector2(565, 205),
		Vector2(80, 345), Vector2(260, 345), Vector2(440, 345), Vector2(620, 345),
		Vector2(360, 445)
	]
	for i in range(11):
		var card := PlayerCard.new()
		card.data = PLAYERS[i]
		card.position = coords[i]
		card.pressed.connect(_on_card_pressed.bind(i))
		pitch.add_child(card)

	var side := _panel(Color("#102744"), Rect2(970, 100, 300, 570))
	_add_label(side, "PLAYER DETAILS", Rect2(18, 16, 260, 30), 18, Color("#f3d36a"))
	detail_label = _add_label(side, "", Rect2(18, 70, 264, 180), 17, Color.WHITE)
	_add_label(side, "FORMATION", Rect2(18, 275, 250, 28), 15, Color("#b9d3f1"))
	formation_button = OptionButton.new()
	formation_button.position = Vector2(18, 310)
	formation_button.size = Vector2(260, 44)
	formation_button.add_item("4-3-3")
	formation_button.add_item("4-4-2")
	formation_button.add_item("3-5-2")
	formation_button.item_selected.connect(_on_formation_changed)
	side.add_child(formation_button)
	var save_button := Button.new()
	save_button.text = "SAVE LINEUP"
	save_button.position = Vector2(18, 390)
	save_button.size = Vector2(260, 52)
	save_button.pressed.connect(_save_game)
	side.add_child(save_button)
	status_label = _add_label(side, "Offline save ready", Rect2(18, 465, 264, 45), 13, Color("#8fe3a7"))
	_add_label(side, "BENCH", Rect2(18, 520, 260, 24), 14, Color("#f3d36a"))
	_add_label(side, "Foden 89  •  Kane 92\nRice 89  •  Palmer 87", Rect2(18, 548, 264, 55), 12, Color("#d9e7f7"))
	_update_details()


func _panel(color: Color, rect: Rect2) -> Control:
	var p := Panel.new()
	p.position = rect.position
	p.size = rect.size
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("#31577d")
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	p.add_theme_stylebox_override("panel", style)
	add_child(p)
	return p


func _add_label(parent: Control, text: String, rect: Rect2, font_size: int, color: Color, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = text
	label.position = rect.position
	label.size = rect.size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)
	return label


func _draw_pitch(pitch: Control) -> void:
	var lines := Line2D.new()
	lines.points = PackedVector2Array([Vector2(20,285), Vector2(804,285)])
	lines.default_color = Color(0.72, 0.95, 0.78, 0.55)
	lines.width = 2
	pitch.add_child(lines)
	var box_line := Line2D.new()
	box_line.points = PackedVector2Array([Vector2(230,20),Vector2(594,20),Vector2(594,540),Vector2(230,540),Vector2(230,20)])
	box_line.default_color = Color(0.72,0.95,0.78,0.45)
	box_line.width = 2
	pitch.add_child(box_line)


func _on_card_pressed(index: int) -> void:
	selected_index = index
	_update_details()
	for child in get_children():
		_refresh_cards(child)


func _refresh_cards(node: Node) -> void:
	if node is PlayerCard:
		node.is_selected = PLAYERS.find(PLAYERS[selected_index]) == PLAYERS.find(node.data)
		node.queue_redraw()
	for child in node.get_children():
		_refresh_cards(child)


func _update_details() -> void:
	if detail_label == null:
		return
	var p: Dictionary = PLAYERS[selected_index]
	detail_label.text = "%s\n\nOVR: %d\nPOSITION: %s\nNATION: %s\n\nTap another card to inspect it." % [p.name, p.ovr, p.pos, p.nation]


func _on_formation_changed(index: int) -> void:
	formation = formation_button.get_item_text(index)
	status_label.text = "Formation selected: " + formation


func _save_game() -> void:
	var data := {"formation": formation, "selected_player": selected_index}
	var file := FileAccess.open("user://team_save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		status_label.text = "Lineup saved on this device"
	else:
		status_label.text = "Could not save lineup"


func _load_save() -> void:
	if not FileAccess.file_exists("user://team_save.json"):
		return
	var file := FileAccess.open("user://team_save.json", FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Dictionary:
			formation = str(parsed.get("formation", "4-3-3"))
			selected_index = int(parsed.get("selected_player", 1))
			if formation_button:
				for i in range(formation_button.item_count):
					if formation_button.get_item_text(i) == formation:
						formation_button.select(i)
			_update_details()
