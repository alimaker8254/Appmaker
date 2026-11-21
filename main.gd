extends Control

const DESIGN := Vector2(1600, 900)
const TELEGRAM := "https://t.me/+BoZdn8swHfc3MzVk"
const CLUBS := [
	{"name":"Manchester City","short":"MCI","c1":Color("#79c9f2"),"c2":Color("#ffffff")},
	{"name":"Liverpool","short":"LFC","c1":Color("#d71920"),"c2":Color("#ffffff")},
	{"name":"Arsenal","short":"ARS","c1":Color("#db202c"),"c2":Color("#ffffff")},
	{"name":"Manchester United","short":"MUN","c1":Color("#d71920"),"c2":Color("#f5c542")},
	{"name":"Chelsea","short":"CHE","c1":Color("#1746a2"),"c2":Color("#ffffff")},
	{"name":"Tottenham Hotspur","short":"TOT","c1":Color("#ffffff"),"c2":Color("#1746a2")},
	{"name":"Newcastle United","short":"NEW","c1":Color("#111111"),"c2":Color("#ffffff")},
	{"name":"Aston Villa","short":"AVL","c1":Color("#7b1d45"),"c2":Color("#80b9e8")},
	{"name":"West Ham United","short":"WHU","c1":Color("#7d263e"),"c2":Color("#8bc7e8")},
	{"name":"Everton","short":"EVE","c1":Color("#1746a2"),"c2":Color("#ffffff")},
	{"name":"Brighton & Hove Albion","short":"BHA","c1":Color("#1746a2"),"c2":Color("#ffffff")},
	{"name":"Nottingham Forest","short":"NFO","c1":Color("#e51c2a"),"c2":Color("#ffffff")},
	{"name":"Barcelona","short":"FCB","c1":Color("#a50044"),"c2":Color("#004d98")},
	{"name":"Real Madrid","short":"RMA","c1":Color("#ffffff"),"c2":Color("#e8c54a")},
	{"name":"Atlético Madrid","short":"ATM","c1":Color("#d71920"),"c2":Color("#1746a2")}
]

var screen := "select"
var selected_club := 0
var euros := 25000
var lp := 15
var level := 1
var music_volume := 0.58
var music_muted := false
var toast := ""
var toast_time := 0.0
var font: Font

func _ready() -> void:
	get_viewport().size_changed.connect(queue_redraw)
	font = ThemeDB.fallback_font
	_load_save()
	if FileAccess.file_exists("user://save.cfg"):
		screen = "home"
	else:
		screen = "select"
	queue_redraw()

func _load_save() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://save.cfg") == OK:
		selected_club = clampi(int(cfg.get_value("club", "index", 0)), 0, CLUBS.size() - 1)
		euros = int(cfg.get_value("economy", "euros", 25000))
		lp = int(cfg.get_value("economy", "lp", 15))
		level = int(cfg.get_value("progress", "level", 1))
		music_volume = float(cfg.get_value("settings", "volume", 0.58))
		music_muted = bool(cfg.get_value("settings", "muted", false))

func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("club", "index", selected_club)
	cfg.set_value("economy", "euros", euros)
	cfg.set_value("economy", "lp", lp)
	cfg.set_value("progress", "level", level)
	cfg.set_value("settings", "volume", music_volume)
	cfg.set_value("settings", "muted", music_muted)
	cfg.save("user://save.cfg")

func _process(delta: float) -> void:
	if toast_time > 0.0:
		toast_time -= delta
		if toast_time <= 0.0:
			toast = ""
			queue_redraw()

func _draw() -> void:
	var scale_factor: float = minf(size.x / DESIGN.x, size.y / DESIGN.y)
	var offset: Vector2 = (size - DESIGN * scale_factor) * 0.5
	draw_set_transform(offset, 0.0, Vector2.ONE * scale_factor)
	_draw_background()
	if screen == "select":
		_draw_select()
	elif screen == "home":
		_draw_home()
	elif screen == "settings":
		_draw_settings()
	if toast != "":
		_panel(Rect2(500, 790, 600, 68), Color("#071a38"), Color("#00dfff"), 3)
		_text(toast, Vector2(800, 835), 25, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, DESIGN), Color("#030824"))
	for i in range(-900, 1900, 115):
		var pts := PackedVector2Array([Vector2(i, 0), Vector2(i + 48, 0), Vector2(i - 470, 900), Vector2(i - 518, 900)])
		draw_colored_polygon(pts, Color(0.02, 0.12, 0.48, 0.23))
		draw_line(Vector2(i, 0), Vector2(i - 470, 900), Color(0.03, 0.23, 0.95, 0.12), 3)
	if screen != "select":
		for i in range(0, 900, 48):
			draw_line(Vector2(0, i), Vector2(1600, i - 260), Color(0.0, 0.9, 0.18, 0.025), 22)

func _panel(rect: Rect2, fill: Color, edge: Color, width: float = 3.0) -> void:
	draw_rect(rect, Color(edge.r, edge.g, edge.b, 0.10), true)
	draw_rect(rect.grow(-5), fill, true)
	for n in range(3, 0, -1):
		draw_rect(rect.grow(float(n * 2)), Color(edge.r, edge.g, edge.b, 0.035 * float(4 - n)), false, 5)
	draw_rect(rect, edge, false, width)

func _text(value: String, pos: Vector2, px: int, color: Color = Color.WHITE, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var shaped := TextLine.new()
	shaped.add_string(value, font, px)
	var w := shaped.get_line_width()
	var x := pos.x
	if align == HORIZONTAL_ALIGNMENT_CENTER:
		x -= w * 0.5
	elif align == HORIZONTAL_ALIGNMENT_RIGHT:
		x -= w
	draw_string(font, Vector2(x, pos.y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, px, color)

func _club_badge(index: int, center: Vector2, radius: float = 43.0) -> void:
	var club: Dictionary = CLUBS[index]
	var c1: Color = club.c1
	var c2: Color = club.c2
	draw_circle(center, radius + 5, Color("#f5c52c"))
	draw_circle(center, radius, Color("#071b48"))
	draw_circle(center, radius - 5, c1)
	draw_arc(center, radius - 8, 0, TAU, 64, c2, 3)
	draw_colored_polygon(PackedVector2Array([center + Vector2(-radius * .48, -radius * .52), center + Vector2(radius * .48, -radius * .52), center + Vector2(radius * .37, radius * .45), center + Vector2(0, radius * .72), center + Vector2(-radius * .37, radius * .45)]), Color(0.02, 0.04, 0.12, 0.72))
	_text(str(club.short), center + Vector2(0, 8), int(radius * .48), c2, HORIZONTAL_ALIGNMENT_CENTER)
	_text("★", center + Vector2(0, -radius * .48), int(radius * .27), Color("#ffe36a"), HORIZONTAL_ALIGNMENT_CENTER)

func _draw_topbar() -> void:
	_panel(Rect2(25, 20, 870, 108), Color("#061a32"), Color("#00ed8a"), 4)
	_club_badge(selected_club, Vector2(100, 72), 48)
	_text(CLUBS[selected_club].name, Vector2(440, 65), 34, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT)
	_text("My Club", Vector2(440, 100), 23, Color("#ffe82c"), HORIZONTAL_ALIGNMENT_RIGHT)
	draw_line(Vector2(475, 35), Vector2(475, 112), Color.WHITE, 3)
	_text("Lv. %d" % level, Vector2(515, 78), 31)
	_panel(Rect2(640, 48, 220, 44), Color("#06142d"), Color("#009dff"), 3)
	draw_rect(Rect2(649, 56, 140, 28), Color("#ffe000"), true)
	_panel(Rect2(915, 22, 490, 104), Color("#061a32"), Color("#00ed8a"), 4)
	_text("€", Vector2(968, 91), 53, Color("#ffd12c"), HORIZONTAL_ALIGNMENT_CENTER)
	_text("%s" % _format_number(euros), Vector2(1110, 84), 31, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	draw_line(Vector2(1180, 35), Vector2(1180, 112), Color.WHITE, 3)
	_text("LP", Vector2(1245, 88), 43, Color("#e83dff"), HORIZONTAL_ALIGNMENT_CENTER)
	_text("%d LP" % lp, Vector2(1340, 82), 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_panel(Rect2(1420, 22, 145, 104), Color("#071b3b"), Color("#008cff"), 4)
	_text("⚙", Vector2(1492, 93), 66, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)

func _format_number(value: int) -> String:
	var s := str(value)
	var out := ""
	for i in range(s.length()):
		out += s[i]
		if (s.length() - i - 1) % 3 == 0 and i != s.length() - 1:
			out += ","
	return out

func _draw_select() -> void:
	_panel(Rect2(365, 15, 870, 82), Color("#061431"), Color("#008dff"), 4)
	_text("لطفا یک تیم را انتخاب کنید", Vector2(800, 72), 43, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	var card_w := 286.0
	var card_h := 198.0
	var gap := 18.0
	for i in range(CLUBS.size()):
		var row := i / 5
		var col := i % 5
		var rect := Rect2(25 + col * (card_w + gap), 120 + row * 216, card_w, card_h)
		var chosen := selected_club == i
		_panel(rect, Color("#061638"), Color("#00d9ff") if chosen else Color("#0879ee"), 4 if chosen else 3)
		_club_badge(i, rect.position + Vector2(card_w * .5, 77), 52)
		_panel(Rect2(rect.position.x + 7, rect.position.y + 145, card_w - 14, 43), Color("#07142d"), Color("#008cff"), 2)
		var label: String = CLUBS[i].name
		_text(label, Vector2(rect.position.x + card_w * .5, rect.position.y + 175), 20 if label.length() > 17 else 23, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
		if chosen:
			draw_circle(rect.position + Vector2(card_w - 18, 17), 10, Color("#53ff24"))
	_panel(Rect2(1240, 790, 315, 88), Color("#061a39"), Color("#00dfff"), 4)
	_text("تأیید  ✓", Vector2(1397, 849), 43, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_home() -> void:
	_draw_topbar()
	# Main dashboard cards: two rows, with a league table in the center.
	_draw_tile(Rect2(28, 155, 420, 360), Color("#087b20"), Color("#35ff22"), "مسابقات", "Matches", "⚽")
	_draw_league_table(Rect2(466, 155, 612, 360))
	_draw_tile(Rect2(1095, 155, 477, 360), Color("#8a4c00"), Color("#ffd21b"), "ارتقا بازیکنان", "Player Upgrade", "↗")
	_draw_tile(Rect2(28, 535, 510, 330), Color("#087b20"), Color("#35ff22"), "خرید بازیکن", "Buy Player", "♙")
	_draw_tile(Rect2(558, 535, 484, 330), Color("#6500a0"), Color("#ef28ff"), "تاکتیک‌ها", "Tactics", "⚑")
	_draw_tile(Rect2(1062, 535, 510, 330), Color("#a34b00"), Color("#ffca18"), "خرید مربی", "Hire Coach", "♟")

func _draw_tile(rect: Rect2, base: Color, edge: Color, title: String, subtitle: String, symbol: String) -> void:
	_panel(rect, base.darkened(0.55), edge, 5)
	draw_rect(rect.grow(-12), Color(base.r, base.g, base.b, 0.30), true)
	_text(symbol, Vector2(rect.get_center().x, rect.position.y + rect.size.y * .48), 112, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text(title, Vector2(rect.get_center().x, rect.position.y + rect.size.y - 78), 42, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text(subtitle, Vector2(rect.get_center().x, rect.position.y + rect.size.y - 36), 27, Color("#ffeb29"), HORIZONTAL_ALIGNMENT_CENTER)
	draw_circle(Vector2(rect.end.x - 38, rect.end.y - 42), 28, edge)
	_text("❯", Vector2(rect.end.x - 38, rect.end.y - 29), 36, Color.BLACK, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_league_table(rect: Rect2) -> void:
	_panel(rect, Color("#061b43"), Color("#087fff"), 5)
	_text("🏆  جدول لیگ", Vector2(rect.get_center().x, rect.position.y + 58), 43, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_panel(Rect2(rect.position.x + 15, rect.position.y + 80, rect.size.x - 30, 43), Color("#06112c"), Color("#008bff"), 2)
	_text("رتبه", Vector2(rect.end.x - 55, rect.position.y + 111), 23, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("تیم", Vector2(rect.get_center().x + 15, rect.position.y + 111), 23, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("امتیاز", Vector2(rect.position.x + 85, rect.position.y + 111), 23, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	var names := ["رئال مادرید", "بارسلونا", CLUBS[selected_club].name, "اتلتیکو مادرید", "سویا"]
	var points := [32, 31, 0, 28, 26]
	var order := [1, 2, selected_club + 1, 4, 5]
	for i in range(5):
		var y := rect.position.y + 160 + i * 39
		if i == 2:
			draw_rect(Rect2(rect.position.x + 14, y - 26, rect.size.x - 28, 35), Color("#39e91d"), true)
		var col := Color("#071d45") if i != 2 else Color("#071c12")
		_text(str(order[i]), Vector2(rect.end.x - 55, y), 24, Color.WHITE if i != 2 else Color.BLACK, HORIZONTAL_ALIGNMENT_CENTER)
		_text(names[i], Vector2(rect.get_center().x + 15, y), 23, Color.WHITE if i != 2 else Color.BLACK, HORIZONTAL_ALIGNMENT_CENTER)
		_text(str(points[i]), Vector2(rect.position.x + 85, y), 24, Color.WHITE if i != 2 else Color.BLACK, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_settings() -> void:
	_draw_topbar()
	_panel(Rect2(28, 170, 1544, 690), Color("#04152e"), Color("#3bff3b"), 5)
	_panel(Rect2(420, 150, 760, 122), Color("#06183b"), Color("#00dfff"), 5)
	_text("⚙   تنظیمات", Vector2(800, 222), 54, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("Settings", Vector2(800, 255), 25, Color("#ffe82b"), HORIZONTAL_ALIGNMENT_CENTER)
	# Music volume row
	draw_line(Vector2(65, 480), Vector2(1535, 480), Color(0.0, 0.7, 1.0, 0.4), 2)
	_text("♫", Vector2(175, 430), 100, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("صدای موسیقی", Vector2(420, 397), 42, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("Music Volume", Vector2(420, 438), 25, Color("#ffe82b"), HORIZONTAL_ALIGNMENT_CENTER)
	_panel(Rect2(620, 372, 700, 48), Color("#06132d"), Color("#007cff"), 3)
	var fill_w := 680.0 * (0.0 if music_muted else music_volume)
	draw_rect(Rect2(630, 381, fill_w, 30), Color("#4bff12"), true)
	draw_circle(Vector2(630 + fill_w, 396), 26, Color("#f5f7ff"))
	draw_arc(Vector2(630 + fill_w, 396), 25, 0, TAU, 48, Color("#c5dfff"), 3)
	_text("🔇" if music_muted else "🔊", Vector2(1415, 420), 58, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	# Telegram row
	draw_circle(Vector2(220, 610), 78, Color("#139de5"))
	_text("➤", Vector2(220, 640), 90, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("کانال تلگرام سازنده", Vector2(540, 585), 38, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_text("برای دریافت اخبار و آپدیت ها", Vector2(540, 630), 27, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_panel(Rect2(900, 535, 500, 135), Color("#0759c8"), Color("#00dfff"), 5)
	_text("➤  ورود به کانال تلگرام", Vector2(1150, 615), 37, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_panel(Rect2(550, 735, 500, 100), Color("#061a39"), Color("#50ff18"), 5)
	_text("↶   بازگشت", Vector2(800, 802), 43, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)

func _point(event_position: Vector2) -> Vector2:
	var scale_factor: float = minf(size.x / DESIGN.x, size.y / DESIGN.y)
	var offset: Vector2 = (size - DESIGN * scale_factor) * 0.5
	return (event_position - offset) / scale_factor

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_handle_click(_point(event.position))
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_click(_point(event.position))

func _handle_click(p: Vector2) -> void:
	if screen == "select":
		if p.y >= 115 and p.y < 775 and p.x >= 20 and p.x <= 1560:
			var col := int((p.x - 25) / 304.0)
			var row := int((p.y - 120) / 216.0)
			if col >= 0 and col < 5 and row >= 0 and row < 3:
				var idx := row * 5 + col
				if idx < CLUBS.size():
					selected_club = idx
					queue_redraw()
					return
		if p.x >= 1200 and p.y >= 770:
			screen = "home"
			_save()
			queue_redraw()
	elif screen == "home":
		if p.x > 1400 and p.y < 140:
			screen = "settings"
			queue_redraw()
		elif p.y > 140:
			_show_toast("این بخش در مرحله بعدی توسعه فعال می‌شود")
	elif screen == "settings":
		if p.y >= 350 and p.y <= 445 and p.x >= 600 and p.x <= 1330:
			music_volume = clampf((p.x - 630) / 680.0, 0.0, 1.0)
			music_muted = false
			_save()
			queue_redraw()
		elif p.x > 1350 and p.y > 340 and p.y < 465:
			music_muted = not music_muted
			_save()
			queue_redraw()
		elif p.x > 850 and p.y > 520 and p.y < 690:
			OS.shell_open(TELEGRAM)
		elif p.y > 720 and p.y < 870:
			screen = "home"
			queue_redraw()

func _show_toast(message: String) -> void:
	toast = message
	toast_time = 2.5
	queue_redraw()
