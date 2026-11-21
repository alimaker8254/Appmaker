extends Control
## Football Manager — Neon Glass UI
## Designed for a 1600x900 landscape viewport. All controls are created in code.

const DESIGN_SIZE := Vector2(1600.0, 900.0)
const C_BG := Color("#050b18")
const C_BG_2 := Color("#07172a")
const C_GLASS := Color(0.035, 0.105, 0.18, 0.94)
const C_GLASS_2 := Color(0.055, 0.16, 0.26, 0.96)
const C_GLASS_HOVER := Color(0.06, 0.24, 0.37, 1.0)
const C_CYAN := Color("#22d7ff")
const C_BLUE := Color("#168bff")
const C_WHITE := Color("#eaf7ff")
const C_MUTED := Color("#83a9c4")
const C_GREEN := Color("#42e6a4")
const C_GOLD := Color("#ffd166")
const C_RED := Color("#ff6685")
const C_LINE := Color(0.10, 0.66, 0.95, 0.48)

var page := "clubs"
var selected_club_index := 0
var music_volume := 70
var sound_volume := 80
var season_year := 2026
var club_budget := 25000
var league_points := 15
var wins := 4
var draws := 3
var losses := 2
var current_tab := "overview"

var clubs: Array[Dictionary] = [
	{"name":"FC Barcelona", "short":"BAR", "country":"SPAIN", "primary":Color("#a51d43"), "secondary":Color("#17469e"), "budget":25000, "rating":"★★★★☆"},
	{"name":"Real Madrid", "short":"RMA", "country":"SPAIN", "primary":Color("#e6e9f2"), "secondary":Color("#c6a34d"), "budget":25000, "rating":"★★★★★"},
	{"name":"Manchester City", "short":"MCI", "country":"ENGLAND", "primary":Color("#6cbee8"), "secondary":Color("#ffffff"), "budget":25000, "rating":"★★★★★"},
	{"name":"Liverpool FC", "short":"LIV", "country":"ENGLAND", "primary":Color("#c6283d"), "secondary":Color("#f1d35b"), "budget":25000, "rating":"★★★★☆"}
]

var players: Array[Dictionary] = [
	{"name":"A. Navarro","position":"GK","number":1,"rating":82,"condition":94,"value":"€2.4M"},
	{"name":"M. Costa","position":"RB","number":2,"rating":79,"condition":88,"value":"€1.8M"},
	{"name":"J. Keller","position":"CB","number":4,"rating":84,"condition":91,"value":"€3.1M"},
	{"name":"D. Silva","position":"CB","number":5,"rating":81,"condition":86,"value":"€2.7M"},
	{"name":"R. Moreno","position":"LB","number":3,"rating":80,"condition":92,"value":"€2.2M"},
	{"name":"L. Martin","position":"CM","number":8,"rating":86,"condition":90,"value":"€4.8M"},
	{"name":"E. Brooks","position":"CM","number":6,"rating":83,"condition":84,"value":"€3.5M"},
	{"name":"F. Rossi","position":"CAM","number":10,"rating":88,"condition":96,"value":"€6.2M"},
	{"name":"T. Adams","position":"RW","number":7,"rating":85,"condition":89,"value":"€4.4M"},
	{"name":"K. Mensah","position":"ST","number":9,"rating":87,"condition":93,"value":"€5.9M"},
	{"name":"P. Novak","position":"LW","number":11,"rating":82,"condition":87,"value":"€3.2M"}
]

var root_ui: Control
var content_area: Control
var toast_layer: Control
var selected_player := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_app()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_node_ready():
		_build_app()


func _build_app() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	root_ui = Control.new()
	root_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root_ui)

	var background := ColorRect.new()
	background.color = C_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_ui.add_child(background)

	_add_ambient_glow(root_ui, Vector2(260, -220), Vector2(760, 520), Color(0.0, 0.35, 0.72, 0.13))
	_add_ambient_glow(root_ui, Vector2(1050, 520), Vector2(650, 460), Color(0.0, 0.55, 0.85, 0.08))

	if page == "clubs":
		_build_club_selection()
	else:
		_build_shell()

	toast_layer = Control.new()
	toast_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	toast_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_ui.add_child(toast_layer)


func _add_ambient_glow(parent: Control, pos: Vector2, dimensions: Vector2, tint: Color) -> void:
	var glow := ColorRect.new()
	glow.position = pos
	glow.size = dimensions
	glow.color = tint
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(glow)


func _style_panel(panel: Panel, highlighted := false) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = C_GLASS_2 if highlighted else C_GLASS
	style.border_color = C_CYAN if highlighted else C_LINE
	style.set_border_width_all(1)
	style.set_corner_radius_all(18)
	style.shadow_color = Color(0.0, 0.55, 1.0, 0.17)
	style.shadow_size = 12
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	panel.add_theme_stylebox_override("panel", style)


func _panel(parent: Control, pos: Vector2, dimensions: Vector2, highlighted := false) -> Panel:
	var panel := Panel.new()
	panel.position = pos
	panel.size = dimensions
	_style_panel(panel, highlighted)
	parent.add_child(panel)
	return panel


func _label(parent: Control, value: String, pos: Vector2, dimensions: Vector2 = Vector2(420, 34),
	font_size := 18, color: Color = C_WHITE, align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	parent.add_child(label)
	return label


func _make_button(parent: Control, value: String, pos: Vector2, dimensions: Vector2,
	action: String, primary := false) -> Button:
	var button := Button.new()
	button.text = value
	button.position = pos
	button.size = dimensions
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", C_BG if primary else C_WHITE)

	var normal := StyleBoxFlat.new()
	normal.bg_color = C_CYAN if primary else Color(0.045, 0.17, 0.28, 0.96)
	normal.border_color = C_CYAN if primary else Color(0.08, 0.56, 0.83, 0.72)
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(12)
	normal.shadow_color = Color(0.0, 0.65, 1.0, 0.18)
	normal.shadow_size = 7

	var hover := StyleBoxFlat.new()
	hover.bg_color = Color("#50e4ff") if primary else C_GLASS_HOVER
	hover.border_color = C_WHITE if primary else C_CYAN
	hover.set_border_width_all(2)
	hover.set_corner_radius_all(12)
	hover.shadow_color = Color(0.0, 0.7, 1.0, 0.30)
	hover.shadow_size = 12

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	button.pressed.connect(_on_action.bind(action))
	parent.add_child(button)
	return button


func _section_title(parent: Control, icon_text: String, title_text: String, pos: Vector2) -> void:
	_label(parent, icon_text, pos, Vector2(42, 38), 24, C_CYAN)
	_label(parent, title_text, pos + Vector2(48, 0), Vector2(500, 38), 21, C_WHITE)


func _build_shell() -> void:
	_build_sidebar()
	content_area = Control.new()
	content_area.position = Vector2(270, 0)
	content_area.size = Vector2(1310, 900)
	root_ui.add_child(content_area)
	_build_topbar()
	match page:
		"home": _page_home()
		"squad": _page_squad()
		"matches": _page_matches()
		"finances": _page_finances()
		"tactics": _page_tactics()
		"settings": _page_settings()


func _build_sidebar() -> void:
	var sidebar := _panel(root_ui, Vector2(18, 18), Vector2(232, 864), true)
	_label(sidebar, "N E O N", Vector2(18, 18), Vector2(180, 28), 13, C_CYAN)
	_label(sidebar, "FOOTBALL", Vector2(18, 48), Vector2(195, 36), 25, C_WHITE)
	_label(sidebar, "MANAGER", Vector2(18, 82), Vector2(195, 27), 17, C_CYAN)

	var divider := ColorRect.new()
	divider.position = Vector2(18, 125)
	divider.size = Vector2(180, 2)
	divider.color = C_LINE
	sidebar.add_child(divider)

	var entries: Array[Array] = [
		["⌂", "OVERVIEW", "home"],
		["♟", "SQUAD", "squad"],
		["⚽", "MATCH CENTER", "matches"],
		["▤", "FINANCES", "finances"],
		["⌘", "TACTICS", "tactics"],
		["⚙", "SETTINGS", "settings"]
	]
	for i in range(entries.size()):
		var entry := entries[i]
		var active: bool = page == str(entry[2])
		var button := _make_button(sidebar, str(entry[0]) + "    " + str(entry[1]),
			Vector2(12, 150 + i * 68), Vector2(200, 52), str(entry[2]), active)
		if active:
			button.add_theme_color_override("font_color", C_BG)

	var club := clubs[selected_club_index]
	_draw_crest(sidebar, Vector2(20, 600), Vector2(54, 54), club.primary, club.secondary, club.short)
	_label(sidebar, club.name, Vector2(82, 603), Vector2(115, 25), 14, C_WHITE)
	_label(sidebar, "FIRST TEAM", Vector2(82, 628), Vector2(115, 20), 11, C_MUTED)
	_label(sidebar, "SEASON " + str(season_year), Vector2(20, 780), Vector2(180, 24), 13, C_MUTED)
	_label(sidebar, "●  SYSTEM ONLINE", Vector2(20, 812), Vector2(190, 24), 12, C_GREEN)


func _build_topbar() -> void:
	_label(content_area, page.to_upper().replace("_", " ") + "  /  " + clubs[selected_club_index].name.to_upper(),
		Vector2(18, 22), Vector2(850, 35), 13, C_MUTED)
	_label(content_area, _page_heading(), Vector2(18, 56), Vector2(800, 46), 30, C_WHITE)
	_label(content_area, "● LIVE CLUB SYSTEM", Vector2(1030, 35), Vector2(220, 28), 12, C_GREEN, HORIZONTAL_ALIGNMENT_RIGHT)
	var line := ColorRect.new()
	line.position = Vector2(18, 112)
	line.size = Vector2(1260, 1)
	line.color = C_LINE
	content_area.add_child(line)


func _page_heading() -> String:
	var headings := {
		"home":"Club overview",
		"squad":"First team squad",
		"matches":"Match centre",
		"finances":"Club finances",
		"tactics":"Tactical board",
		"settings":"Game settings"
	}
	return str(headings.get(page, "Football Manager"))


func _draw_crest(parent: Control, pos: Vector2, dimensions: Vector2,
	primary: Color, secondary: Color, initials: String) -> void:
	var crest := Panel.new()
	crest.position = pos
	crest.size = dimensions
	var style := StyleBoxFlat.new()
	style.bg_color = primary
	style.border_color = secondary
	style.set_border_width_all(3)
	style.set_corner_radius_all(13)
	crest.add_theme_stylebox_override("panel", style)
	parent.add_child(crest)
	var mark := Label.new()
	mark.text = initials
	mark.position = Vector2(2, 3)
	mark.size = dimensions - Vector2(4, 6)
	mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mark.add_theme_font_size_override("font_size", 15)
	mark.add_theme_color_override("font_color", Color("#ffffff"))
	crest.add_child(mark)


func _metric_card(pos: Vector2, icon_text: String, caption: String, value: String,
	footnote: String, accent: Color = C_CYAN) -> void:
	var card := _panel(content_area, pos, Vector2(292, 132))
	_label(card, icon_text, Vector2(18, 12), Vector2(42, 40), 25, accent)
	_label(card, caption.to_upper(), Vector2(66, 15), Vector2(200, 25), 12, C_MUTED)
	_label(card, value, Vector2(20, 53), Vector2(245, 42), 27, C_WHITE)
	_label(card, footnote, Vector2(20, 96), Vector2(250, 20), 11, accent)


func _page_home() -> void:
	_metric_card(Vector2(18, 135), "◈", "Transfer budget", "€" + _format_number(club_budget), "AVAILABLE BALANCE")
	_metric_card(Vector2(324, 135), "♜", "League points", str(league_points), "9 MATCHES PLAYED", C_GREEN)
	_metric_card(Vector2(630, 135), "♟", "First team", "25 Players", "11 STARTING · 14 BENCH", C_GOLD)
	_metric_card(Vector2(936, 135), "⚽", "Next fixture", "SAT 15:00", "HOME · LEAGUE ROUND 10", C_BLUE)

	var news := _panel(content_area, Vector2(18, 290), Vector2(700, 330))
	_section_title(news, "▣", "Club intelligence", Vector2(20, 18))
	_label(news, "WELCOME BACK, MANAGER", Vector2(24, 88), Vector2(600, 28), 12, C_CYAN)
	_label(news, "Your next chapter starts here.", Vector2(24, 120), Vector2(620, 38), 25, C_WHITE)
	_label(news, "Review the squad, prepare your tactics and keep the board informed.", Vector2(24, 170), Vector2(630, 55), 15, C_MUTED)
	_label(news, "SEASON OBJECTIVE", Vector2(24, 245), Vector2(200, 22), 11, C_MUTED)
	_label(news, "Finish in the top four", Vector2(24, 270), Vector2(400, 28), 17, C_GOLD)

	var form_panel := _panel(content_area, Vector2(742, 290), Vector2(536, 330))
	_section_title(form_panel, "⌁", "Recent form", Vector2(20, 18))
	var form_values := ["W", "D", "W", "L", "W"]
	for i in range(form_values.size()):
		var color := C_GREEN if form_values[i] == "W" else (C_GOLD if form_values[i] == "D" else C_RED)
		var tile := _panel(form_panel, Vector2(24 + i * 94, 105), Vector2(68, 68), true)
		_label(tile, form_values[i], Vector2(0, 5), Vector2(68, 55), 25, color, HORIZONTAL_ALIGNMENT_CENTER)
	_label(form_panel, "4 wins   ·   1 draw   ·   1 loss", Vector2(24, 205), Vector2(430, 28), 16, C_MUTED)
	_label(form_panel, "Momentum", Vector2(24, 250), Vector2(110, 22), 12, C_MUTED)
	_label(form_panel, "GOOD", Vector2(380, 250), Vector2(100, 22), 13, C_GREEN, HORIZONTAL_ALIGNMENT_RIGHT)

	var quick := _panel(content_area, Vector2(18, 642), Vector2(1260, 190))
	_section_title(quick, "⚡", "Command centre", Vector2(20, 14))
	_make_button(quick, "♟  MANAGE SQUAD", Vector2(24, 78), Vector2(225, 62), "squad")
	_make_button(quick, "⚽  MATCH CENTRE", Vector2(270, 78), Vector2(225, 62), "matches")
	_make_button(quick, "▤  CLUB FINANCES", Vector2(516, 78), Vector2(225, 62), "finances")
	_make_button(quick, "⌘  TACTICS", Vector2(762, 78), Vector2(225, 62), "tactics")
	_make_button(quick, "⚙  SETTINGS", Vector2(1008, 78), Vector2(225, 62), "settings")


func _page_squad() -> void:
	var summary := _panel(content_area, Vector2(18, 135), Vector2(1260, 105))
	_label(summary, "FIRST TEAM", Vector2(22, 16), Vector2(200, 22), 12, C_CYAN)
	_label(summary, "25 registered players", Vector2(22, 44), Vector2(350, 32), 22, C_WHITE)
	_label(summary, "FORMATION  4 - 3 - 3", Vector2(780, 43), Vector2(400, 30), 17, C_GOLD, HORIZONTAL_ALIGNMENT_RIGHT)

	var list := _panel(content_area, Vector2(18, 260), Vector2(1260, 560))
	_label(list, "PLAYER", Vector2(25, 15), Vector2(330, 28), 12, C_MUTED)
	_label(list, "POS", Vector2(470, 15), Vector2(80, 28), 12, C_MUTED)
	_label(list, "OVR", Vector2(610, 15), Vector2(80, 28), 12, C_MUTED)
	_label(list, "FITNESS", Vector2(750, 15), Vector2(130, 28), 12, C_MUTED)
	_label(list, "MARKET VALUE", Vector2(1010, 15), Vector2(180, 28), 12, C_MUTED)
	for i in range(players.size()):
		var player: Dictionary = players[i]
		var y := 58.0 + i * 43.0
		var row := ColorRect.new()
		row.position = Vector2(15, y)
		row.size = Vector2(1225, 38)
		row.color = Color(0.08, 0.22, 0.33, 0.45) if i % 2 == 0 else Color(0.02, 0.10, 0.18, 0.35)
		list.add_child(row)
		_label(list, str(player.number).pad_zeros(2) + "   " + str(player.name), Vector2(28, y + 2), Vector2(390, 32), 14, C_WHITE)
		_label(list, str(player.position), Vector2(470, y + 2), Vector2(80, 32), 14, C_CYAN)
		_label(list, str(player.rating), Vector2(610, y + 2), Vector2(80, 32), 14, C_GOLD)
		_label(list, str(player.condition) + "%", Vector2(750, y + 2), Vector2(100, 32), 14, C_GREEN if int(player.condition) >= 85 else C_GOLD)
		_label(list, str(player.value), Vector2(1010, y + 2), Vector2(180, 32), 14, C_MUTED)


func _page_matches() -> void:
	var fixture := _panel(content_area, Vector2(18, 135), Vector2(1260, 265), true)
	_label(fixture, "UPCOMING FIXTURE  ·  LEAGUE ROUND 10", Vector2(25, 20), Vector2(700, 25), 12, C_CYAN)
	_draw_crest(fixture, Vector2(230, 82), Vector2(82, 82), clubs[selected_club_index].primary, clubs[selected_club_index].secondary, clubs[selected_club_index].short)
	_label(fixture, clubs[selected_club_index].name, Vector2(130, 174), Vector2(280, 30), 17, C_WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_label(fixture, "VS", Vector2(570, 100), Vector2(100, 50), 28, C_GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_crest(fixture, Vector2(920, 82), Vector2(82, 82), Color("#e1e7f2"), C_BLUE, "OPP")
	_label(fixture, "OPPONENT FC", Vector2(820, 174), Vector2(280, 30), 17, C_WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_label(fixture, "SATURDAY  ·  15:00", Vector2(465, 220), Vector2(300, 24), 12, C_MUTED, HORIZONTAL_ALIGNMENT_CENTER)

	var history := _panel(content_area, Vector2(18, 425), Vector2(1260, 390))
	_section_title(history, "▤", "Recent results", Vector2(22, 18))
	var results := [["Round 09","W","2 - 0","Home"],["Round 08","D","1 - 1","Away"],["Round 07","W","3 - 1","Home"],["Round 06","L","0 - 1","Away"]]
	for i in range(results.size()):
		var y := 82 + i * 70
		_label(history, results[i][0], Vector2(30, y), Vector2(200, 38), 15, C_MUTED)
		var result_color := C_GREEN if results[i][1] == "W" else (C_GOLD if results[i][1] == "D" else C_RED)
		_label(history, results[i][1], Vector2(330, y), Vector2(70, 38), 18, result_color)
		_label(history, results[i][2], Vector2(540, y), Vector2(150, 38), 18, C_WHITE)
		_label(history, results[i][3], Vector2(850, y), Vector2(150, 38), 14, C_MUTED)


func _page_finances() -> void:
	_metric_card(Vector2(18, 135), "◈", "Available balance", "€" + _format_number(club_budget), "TRANSFER BUDGET", C_GREEN)
	_metric_card(Vector2(324, 135), "↗", "Weekly income", "€48,500", "SPONSORS + TICKETS", C_CYAN)
	_metric_card(Vector2(630, 135), "↘", "Weekly expenses", "€32,200", "WAGES + OPERATIONS", C_GOLD)
	_metric_card(Vector2(936, 135), "▣", "Net balance", "+€16,300", "THIS WEEK", C_GREEN)
	var ledger := _panel(content_area, Vector2(18, 290), Vector2(1260, 510))
	_section_title(ledger, "▤", "Financial activity", Vector2(22, 18))
	var entries := [["Matchday revenue","Income","+€22,500"],["Main sponsor","Income","+€18,000"],["Player wages","Expense","-€24,000"],["Merchandise sales","Income","+€8,000"],["Training facilities","Expense","-€8,200"]]
	for i in range(entries.size()):
		var y := 88 + i * 72
		_label(ledger, entries[i][0], Vector2(28, y), Vector2(470, 36), 15, C_WHITE)
		_label(ledger, entries[i][1], Vector2(650, y), Vector2(180, 36), 13, C_MUTED)
		var amount_color := C_GREEN if entries[i][1] == "Income" else C_RED
		_label(ledger, entries[i][2], Vector2(950, y), Vector2(220, 36), 16, amount_color, HORIZONTAL_ALIGNMENT_RIGHT)


func _page_tactics() -> void:
	var board := _panel(content_area, Vector2(18, 135), Vector2(850, 680), true)
	_section_title(board, "⌘", "Tactical formation", Vector2(20, 15))
	var pitch := ColorRect.new()
	pitch.position = Vector2(28, 75)
	pitch.size = Vector2(790, 560)
	pitch.color = Color("#0a513f")
	board.add_child(pitch)
	var outline := ColorRect.new()
	outline.position = Vector2(18, 18)
	outline.size = Vector2(754, 2)
	outline.color = Color(0.75, 1, 0.9, 0.65)
	pitch.add_child(outline)
	var centre := ColorRect.new()
	centre.position = Vector2(377, 0)
	centre.size = Vector2(2, 560)
	centre.color = Color(0.75, 1, 0.9, 0.55)
	pitch.add_child(centre)
	var formation_positions := [
		Vector2(390, 495), Vector2(145, 390), Vector2(315, 410), Vector2(485, 410), Vector2(655, 390),
		Vector2(250, 270), Vector2(390, 300), Vector2(530, 270),
		Vector2(190, 130), Vector2(390, 95), Vector2(590, 130)
	]
	for i in range(formation_positions.size()):
		var dot := Panel.new()
		dot.position = formation_positions[i]
		dot.size = Vector2(38, 38)
		var dot_style := StyleBoxFlat.new()
		dot_style.bg_color = C_CYAN
		dot_style.border_color = C_WHITE
		dot_style.set_border_width_all(2)
		dot_style.set_corner_radius_all(19)
		dot.add_theme_stylebox_override("panel", dot_style)
		pitch.add_child(dot)
		var number := Label.new()
		number.text = str(i + 1)
		number.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		number.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		number.add_theme_font_size_override("font_size", 13)
		number.add_theme_color_override("font_color", C_BG)
		dot.add_child(number)
	var options := _panel(content_area, Vector2(890, 135), Vector2(388, 680))
	_section_title(options, "⚙", "Match instructions", Vector2(18, 18))
	_label(options, "FORMATION", Vector2(20, 90), Vector2(300, 24), 12, C_MUTED)
	_make_button(options, "4 - 3 - 3  ▾", Vector2(20, 122), Vector2(340, 52), "formation")
	_label(options, "MENTALITY", Vector2(20, 205), Vector2(300, 24), 12, C_MUTED)
	_make_button(options, "Balanced  ▾", Vector2(20, 237), Vector2(340, 52), "mentality")
	_label(options, "PRESSING", Vector2(20, 320), Vector2(300, 24), 12, C_MUTED)
	_make_button(options, "Standard  ▾", Vector2(20, 352), Vector2(340, 52), "pressing")
	_label(options, "TACTICAL PRESET", Vector2(20, 435), Vector2(300, 24), 12, C_MUTED)
	_label(options, "Possession with quick wide attacks", Vector2(20, 470), Vector2(330, 55), 14, C_WHITE)


func _page_settings() -> void:
	var audio := _panel(content_area, Vector2(18, 135), Vector2(610, 330))
	_section_title(audio, "♫", "Audio & sound", Vector2(20, 18))
	_label(audio, "Music volume", Vector2(25, 92), Vector2(240, 28), 15, C_WHITE)
	_label(audio, str(music_volume) + "%", Vector2(490, 92), Vector2(75, 28), 14, C_CYAN, HORIZONTAL_ALIGNMENT_RIGHT)
	_make_button(audio, "−", Vector2(25, 137), Vector2(65, 48), "music_down")
	_make_button(audio, "+", Vector2(105, 137), Vector2(65, 48), "music_up")
	_label(audio, "Sound effects", Vector2(25, 210), Vector2(240, 28), 15, C_WHITE)
	_label(audio, str(sound_volume) + "%", Vector2(490, 210), Vector2(75, 28), 14, C_CYAN, HORIZONTAL_ALIGNMENT_RIGHT)
	_make_button(audio, "−", Vector2(25, 255), Vector2(65, 48), "sound_down")
	_make_button(audio, "+", Vector2(105, 255), Vector2(65, 48), "sound_up")

	var community := _panel(content_area, Vector2(655, 135), Vector2(623, 330))
	_section_title(community, "◎", "Community", Vector2(20, 18))
	_label(community, "Join the club community", Vector2(25, 100), Vector2(520, 32), 19, C_WHITE)
	_label(community, "News, updates and announcements", Vector2(25, 140), Vector2(520, 28), 14, C_MUTED)
	_make_button(community, "OPEN TELEGRAM COMMUNITY", Vector2(25, 205), Vector2(530, 58), "telegram", true)

	var about := _panel(content_area, Vector2(18, 495), Vector2(1260, 320))
	_section_title(about, "ⓘ", "About this game", Vector2(20, 18))
	_label(about, "FOOTBALL MANAGER · NEON GLASS EDITION", Vector2(25, 90), Vector2(800, 28), 15, C_CYAN)
	_label(about, "Landscape interface  ·  Touch-friendly controls  ·  Season " + str(season_year),
		Vector2(25, 130), Vector2(900, 30), 14, C_MUTED)
	_label(about, "Build your club. Shape your squad. Own your story.", Vector2(25, 190), Vector2(900, 35), 20, C_WHITE)


func _format_number(value: int) -> String:
	var raw := str(value)
	var output := ""
	var count := 0
	for i in range(raw.length() - 1, -1, -1):
		output = raw.substr(i, 1) + output
		count += 1
		if count % 3 == 0 and i > 0:
			output = "," + output
	return output


func _show_toast(message: String) -> void:
	if toast_layer == null:
		return
	for child in toast_layer.get_children():
		child.queue_free()
	var panel := _panel(toast_layer, Vector2(1050, 790), Vector2(480, 62), true)
	_label(panel, message, Vector2(12, 8), Vector2(440, 42), 14, C_WHITE)


func _on_action(action: String) -> void:
	if action.begins_with("select_"):
		_on_club_selected(int(action.trim_prefix("select_")))
		return
	if action in ["home", "squad", "matches", "finances", "tactics", "settings"]:
		page = action
	elif action == "music_up":
		music_volume = mini(music_volume + 10, 100)
	elif action == "music_down":
		music_volume = maxi(music_volume - 10, 0)
	elif action == "sound_up":
		sound_volume = mini(sound_volume + 10, 100)
	elif action == "sound_down":
		sound_volume = maxi(sound_volume - 10, 0)
	elif action == "telegram":
		OS.shell_open("https://t.me/+BoZdn8swHfc3MzVk")
	elif action == "formation":
		_show_toast("Formation preset selector will be added next.")
	elif action == "mentality":
		_show_toast("Mentality selector will be added next.")
	elif action == "pressing":
		_show_toast("Pressing selector will be added next.")
	_build_app()


func _build_club_selection() -> void:
	var heading := _label(root_ui, "FOOTBALL MANAGER", Vector2(72, 48), Vector2(700, 52), 34, C_WHITE)
	_label(root_ui, "NEON GLASS EDITION  /  CHOOSE YOUR CLUB", Vector2(76, 105), Vector2(800, 30), 14, C_CYAN)
	_label(root_ui, "SELECT YOUR DESTINATION", Vector2(76, 185), Vector2(700, 38), 22, C_WHITE)
	_label(root_ui, "Four clubs are ready for a new season. Choose your badge to begin.",
		Vector2(76, 225), Vector2(900, 30), 14, C_MUTED)

	for i in range(clubs.size()):
		var club: Dictionary = clubs[i]
		var x := 76.0 + i * 365.0
		var card := _panel(root_ui, Vector2(x, 300), Vector2(330, 430), i == selected_club_index)
		_draw_crest(card, Vector2(111, 35), Vector2(108, 108), club.primary, club.secondary, club.short)
		_label(card, club.name, Vector2(18, 165), Vector2(294, 38), 21, C_WHITE, HORIZONTAL_ALIGNMENT_CENTER)
		_label(card, str(club.country), Vector2(18, 205), Vector2(294, 24), 12, C_CYAN, HORIZONTAL_ALIGNMENT_CENTER)
		_label(card, "STARTING BUDGET", Vector2(20, 270), Vector2(290, 22), 11, C_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		_label(card, "€" + _format_number(int(club.budget)), Vector2(20, 296), Vector2(290, 35), 22, C_GOLD, HORIZONTAL_ALIGNMENT_CENTER)
		_label(card, "CLUB RATING  " + str(club.rating), Vector2(20, 344), Vector2(290, 24), 13, C_CYAN, HORIZONTAL_ALIGNMENT_CENTER)
		_make_button(card, "SELECT CLUB", Vector2(25, 378), Vector2(280, 42), "select_" + str(i), true)

	_label(root_ui, "LANDSCAPE EXPERIENCE  ·  TOUCH OPTIMIZED  ·  SEASON " + str(season_year),
		Vector2(76, 790), Vector2(1000, 28), 12, C_MUTED)


func _on_club_selected(index: int) -> void:
	selected_club_index = clampi(index, 0, clubs.size() - 1)
	club_budget = int(clubs[selected_club_index].budget)
	page = "home"
	_build_app()
