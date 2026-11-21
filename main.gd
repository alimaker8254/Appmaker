
extends Control

const BG = Color("#080e20")
const PANEL = Color("#111c34")
const PANEL_LIGHT = Color("#192744")
const GOLD = Color("#f4c45e")
const WHITE = Color("#f4f6fc")
const MUTED = Color("#91a0ba")
const GREEN = Color("#36c98a")
const BLUE = Color("#4388ed")

var screen := "clubs"
var selected_club := 0
var music_volume := 70
var club_name := "FC Barcelona"
var club_budget := "€25,000"
var club_points := 15

var clubs := [
	{"name": "FC Barcelona", "short": "BAR", "color": Color("#a52345")},
	{"name": "Real Madrid", "short": "RMA", "color": Color("#d8dce8")},
	{"name": "Manchester City", "short": "MCI", "color": Color("#55a9dc")},
	{"name": "Liverpool", "short": "LIV", "color": Color("#c83242")}
]

var buttons: Array[Dictionary] = []


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()


func _draw() -> void:
	buttons.clear()
	draw_rect(Rect2(Vector2.ZERO, size), BG)

	if screen == "clubs":
		draw_club_selection()
	elif screen == "home":
		draw_dashboard()
	elif screen == "settings":
		draw_settings()


func add_button(label: String, rect: Rect2, action: String, color: Color = PANEL_LIGHT) -> void:
	draw_rect(rect, color, true, 12.0)
	draw_string(
		ThemeDB.fallback_font,
		rect.position + Vector2(16, rect.size.y / 2 + 6),
		label,
		HORIZONTAL_ALIGNMENT_CENTER,
		rect.size.x - 32,
		20,
		WHITE
	)
	buttons.append({"rect": rect, "action": action})


func draw_header(title: String, subtitle: String) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(65, 65), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 34, WHITE)
	draw_string(ThemeDB.fallback_font, Vector2(65, 100), subtitle, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, MUTED)


func draw_club_selection() -> void:
	draw_header("FOOTBALL MANAGER", "BUILD YOUR CLUB. CREATE YOUR LEGACY.")

	draw_string(
		ThemeDB.fallback_font,
		Vector2(65, 175),
		"CHOOSE YOUR CLUB",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		25,
		GOLD
	)

	var card_width := 340.0
	var gap := 30.0
	var start_x := 65.0

	for i in range(clubs.size()):
		var x := start_x + i * (card_width + gap)
		var card := Rect2(x, 225, card_width, 365)
		var club: Dictionary = clubs[i]

		draw_rect(card, PANEL, true, 18.0)

		var crest := Rect2(x + 115, 255, 110, 110)
		draw_rect(crest, club["color"], true, 55.0)
		draw_string(
			ThemeDB.fallback_font,
			Vector2(x + 115, 323),
			club["short"],
			HORIZONTAL_ALIGNMENT_CENTER,
			110,
			27,
			WHITE
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(x + 20, 420),
			club["name"],
			HORIZONTAL_ALIGNMENT_CENTER,
			card_width - 40,
			23,
			WHITE
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(x + 20, 465),
			"Starting budget: €25,000",
			HORIZONTAL_ALIGNMENT_CENTER,
			card_width - 40,
			16,
			MUTED
		)

		var action := "club_" + str(i)
		add_button(
			"SELECT CLUB",
			Rect2(x + 35, 515, card_width - 70, 55),
			action,
			GOLD
		)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(65, 680),
		"Choose your team and begin your football journey.",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		MUTED
	)


func draw_sidebar() -> void:
	draw_rect(Rect2(0, 0, 255, 900), Color("#0d172c"))

	draw_string(
		ThemeDB.fallback_font,
		Vector2(30, 65),
		"FOOTBALL",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		25,
		GOLD
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(30, 95),
		"MANAGER",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		19,
		WHITE
	)

	var items := [
		["HOME", "home"],
		["SQUAD", "squad"],
		["MATCHES", "matches"],
		["FINANCES", "finances"],
		["SETTINGS", "settings"]
	]

	for i in range(items.size()):
		var y := 160.0 + i * 75.0
		add_button(
			items[i][0],
			Rect2(20, y, 215, 55),
			items[i][1],
			PANEL_LIGHT if (items[i][1] == screen or (screen == "home" and items[i][1] == "home")) else Color("#0d172c")
		)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(30, 835),
		"SEASON 2026",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		15,
		MUTED
	)


func draw_dashboard() -> void:
	draw_sidebar()

	draw_string(
		ThemeDB.fallback_font,
		Vector2(300, 65),
		"CLUB OVERVIEW",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		32,
		WHITE
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(300, 100),
		club_name,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		17,
		MUTED
	)

	var card_y := 145.0
	var card_w := 285.0
	var gap := 22.0

	var stats := [
		["CLUB BUDGET", club_budget, GOLD],
		["LEAGUE POINTS", str(club_points), GREEN],
		["SQUAD", "25 Players", BLUE],
		["NEXT MATCH", "Not scheduled", WHITE]
	]

	for i in range(stats.size()):
		var x := 300.0 + i * (card_w + gap)
		var rect := Rect2(x, card_y, card_w, 135)
		draw_rect(rect, PANEL, true, 15.0)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(x + 22, card_y + 38),
			stats[i][0],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			15,
			MUTED
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(x + 22, card_y + 91),
			stats[i][1],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			25,
			stats[i][2]
		)

	draw_rect(Rect2(300, 325, 640, 330), PANEL, true, 16.0)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(330, 370),
		"CLUB NEWS",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		22,
		GOLD
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(330, 430),
		"Welcome to your new club.",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		19,
		WHITE
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(330, 470),
		"Build your squad and prepare for the season.",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		16,
		MUTED
	)

	draw_rect(Rect2(975, 325, 565, 330), PANEL, true, 16.0)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(1005, 370),
		"QUICK ACTIONS",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		22,
		GOLD
	)

	add_button("MANAGE SQUAD", Rect2(1005, 405, 505, 55), "squad")
	add_button("VIEW MATCHES", Rect2(1005, 475, 505, 55), "matches")
	add_button("CLUB SETTINGS", Rect2(1005, 545, 505, 55), "settings")

	draw_string(
		ThemeDB.fallback_font,
		Vector2(300, 730),
		"YOUR CLUB. YOUR DECISIONS. YOUR LEGACY.",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		17,
		MUTED
	)


func draw_settings() -> void:
	draw_sidebar()

	draw_string(
		ThemeDB.fallback_font,
		Vector2(300, 65),
		"SETTINGS",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		32,
		WHITE
	)

	draw_rect(Rect2(300, 130, 900, 570), PANEL, true, 18.0)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(345, 195),
		"AUDIO",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		23,
		GOLD
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(345, 255),
		"Music volume",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		19,
		WHITE
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(1000, 255),
		str(music_volume) + "%",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		19,
		GOLD
	)

	draw_rect(Rect2(345, 285, 700, 12), PANEL_LIGHT, true, 6.0)
	draw_rect(Rect2(345, 285, 700.0 * music_volume / 100.0, 12), GOLD, true, 6.0)

	add_button("VOLUME -", Rect2(345, 325, 180, 50), "volume_down")
	add_button("VOLUME +", Rect2(545, 325, 180, 50), "volume_up")

	draw_string(
		ThemeDB.fallback_font,
		Vector2(345, 450),
		"COMMUNITY",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		23,
		GOLD
	)

	add_button("TELEGRAM COMMUNITY", Rect2(345, 485, 400, 55), "telegram", BLUE)
	add_button("BACK TO HOME", Rect2(345, 590, 250, 55), "home")


func _gui_input(event: InputEvent) -> void:
	var click_position := Vector2.ZERO
	var pressed := false

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click_position = event.position
			pressed = true

	elif event is InputEventScreenTouch:
		if event.pressed:
			click_position = event.position
			pressed = true

	if pressed:
		handle_click(click_position)


func handle_click(pos: Vector2) -> void:
	for button in buttons:
		var rect: Rect2 = button["rect"]

		if rect.has_point(pos):
			handle_action(button["action"])
			return

	if screen == "settings":
		if pos.x >= 345 and pos.x <= 1045 and pos.y >= 270 and pos.y <= 315:
			music_volume = int(clamp((pos.x - 345.0) / 700.0 * 100.0, 0, 100))
			queue_redraw()


func handle_action(action: String) -> void:
	if action.begins_with("club_"):
		selected_club = int(action.trim_prefix("club_"))
		club_name = clubs[selected_club]["name"]
		screen = "home"

	elif action == "home":
		screen = "home"

	elif action == "settings":
		screen = "settings"

	elif action == "volume_up":
		music_volume = mini(music_volume + 10, 100)

	elif action == "volume_down":
		music_volume = maxi(music_volume - 10, 0)

	elif action == "telegram":
		OS.shell_open("https://t.me/+BoZdn8swHfc3MzVk")

	elif action == "squad":
		screen = "home"

	elif action == "matches":
		screen = "home"

	elif action == "finances":
		screen = "home"

	queue_redraw()
