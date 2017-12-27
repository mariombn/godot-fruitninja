extends Node2D

onready var limit = get_node("Limit")
onready var inter = get_node("Inter")

var pressed = false
var drag = false
var curpos = Vector2(0, 0)
var prepos = Vector2(0, 0)

var acabou = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	update()
	if drag and curpos !=  prepos and  prepos != Vector2(0,0) and not acabou:
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(prepos, curpos)
		if not result.empty():
			result.collider.cut()

func _input(event):
	event = make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

func pressed(pos):
	pressed = true
	prepos = pos
	limit.start()
	inter.start()
	
func released():
	pressed = false
	drag = false
	limit.stop()
	inter.stop()
	prepos = Vector2(0,0)
	curpos = Vector2(0,0) 

func drag(pos):
	curpos = pos
	drag = true

func _on_Inter_timeout():
	prepos = curpos


func _on_Limit_timeout():
	released()

func _draw():
	if drag and curpos !=  prepos and  prepos != Vector2(0,0) and not acabou:
		draw_line(curpos, prepos, Color(1, 0,0), 10)