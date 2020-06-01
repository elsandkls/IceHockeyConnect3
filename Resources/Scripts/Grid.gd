extends Node2D

# Grid Variables
export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

# variables for pieces
var possible_pieces = [
	preload("res://Scenes/Reg_Blue_Piece.tscn"),
	preload("res://Scenes/Reg_Green_Piece.tscn"),
	preload("res://Scenes/Reg_Orange_Piece.tscn"),
	preload("res://Scenes/Reg_Yellow_Piece.tscn"),
	preload("res://Scenes/Reg_Pink_Piece.tscn"),
	preload("res://Scenes/Reg_Chartuse_Piece.tscn")
];

#Two dimensional array to hold coordinates x,y plane
var all_pieces = [];

# Touch variables
var first_touch = Vector2(0,0);
var final_touch = Vector2(0,0);
var controlling =false;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	all_pieces = make_2d_array();
	spawn_pieces();
	print(all_pieces); 

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;
		
	
func spawn_pieces():
	for i in width:
		for j in height:
			# choose a random number and store it
			var rand = floor(rand_range(0,possible_pieces.size()));
			var piece = possible_pieces[rand].instance();
			var loops = 0;
			while ( match_at(i,j, piece.color) && loops < 100):
				rand = floor(rand_range(0, possible_pieces.size()));
				loops += 1;
				piece = possible_pieces[rand].instance();
			# instance that piece from the array 
			add_child(piece);
			piece.position = grid_to_pixel(i,j);
			all_pieces[i][j] = piece;
	

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start + -offset * row;
	return Vector2(new_x, new_y);

func match_at(i, j, color):
	if i > 1:
		if all_pieces[i-1][j] != null && all_pieces[i-2][j] != null:
			if all_pieces[i-1][j].color == color && all_pieces[i-2][j]. color == color:
				return true;
	if j > 1:
		if all_pieces[i][j-1] != null && all_pieces[i][j-2] != null:
			if all_pieces[i][j-1].color == color && all_pieces[i][j-2]. color == color:
				return true;
	

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset);
	var new_y = round((pixel_y - y_start) / -offset);
	return Vector2(new_x, new_y); 

func is_in_grid(column, row):
	if column >=0 && column < width:
		if row >= 0 && row < height:
			return true;
	return false;
	
func is_in_grid_single(grid_position):
	if grid_position.x >=0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true;
	return false;
		

func touch_input(): 
	
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid_single(pixel_to_grid( (get_global_mouse_position().x), (get_global_mouse_position().y) )): 
			first_touch = pixel_to_grid( (get_global_mouse_position().x), (get_global_mouse_position().y) ); 
			controlling = true; 
			
	if Input.is_action_just_released("ui_touch"):		
		if is_in_grid_single( pixel_to_grid( (get_global_mouse_position().x), (get_global_mouse_position().y) )) && controlling == true:
			print ("swipe");
			controlling = false;
			final_touch = pixel_to_grid( (get_global_mouse_position().x), (get_global_mouse_position().y) ); 
			touch_difference(first_touch, final_touch);
			

func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row];
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	if first_piece != null && other_piece !=null:
		all_pieces[column][row] = other_piece;
		all_pieces[column + direction.x][row + direction.y] = first_piece;
		#first_piece.position = grid_to_pixel(column+direction.x,row+direction.y);
		first_piece.move(grid_to_pixel(column+direction.x,row+direction.y));
		#other_piece.position = grid_to_pixel(column,row);
		other_piece.move(grid_to_pixel(column,row));
		find_matches();
	
func touch_difference(grid_1, grid_2):
	var difference = grid_2 - grid_1;
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1,0));
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1,0));
	if abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0,1));
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0,-1));

func _process(delta):
	touch_input();
	
func find_matches():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				var current_color = all_pieces[i][j].color;
				if i > 0 && i < width -1:
					if all_pieces[i - 1][j] != null && all_pieces[i + 1][j] != null:
						if all_pieces[i - 1][j].color == current_color && all_pieces[i + 1][j].color == current_color:
							all_pieces[i - 1][j].matched = true;
							all_pieces[i - 1][j].dim(); 
							all_pieces[i + 1][j].matched = true;
							all_pieces[i + 1][j].dim();
							all_pieces[i][j].matched = true;
							all_pieces[i][j].dim();
							get_parent().get_node("Destroy_Timer").start();
				if j > 0 && j < height -1:
					if all_pieces[i][j - 1] != null && all_pieces[i][j + 1] != null:
						if all_pieces[i][j - 1].color == current_color && all_pieces[i][j + 1].color == current_color:
							all_pieces[i][j - 1].matched = true;
							all_pieces[i][j - 1].dim();
							all_pieces[i][j + 1].matched = true;
							all_pieces[i][j + 1].dim();
							all_pieces[i][j].matched = true;
							all_pieces[i][j].dim();
							get_parent().get_node("Destroy_Timer").start();

func destroy_matched():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if all_pieces[i][j].matched:
					all_pieces[i][j].queue_free(); 
					all_pieces[i][j] = null;
	get_parent().get_node("Collapse_Timer").start();
	get_parent().get_node("Fill_Timer").start();

func _on_Destroy_Timer_timeout():
	destroy_matched(); 


func _on_Collapse_Timer_timeout():
	collapse_columns(); 	
	pass # Replace with function body.
	
func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				for k in range(j+1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i,j));
						all_pieces[i][j] = all_pieces[i][k];
						all_pieces[i][k] = null;
						break;

func fill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				var rand = floor(rand_range(0,possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while ( match_at(i,j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					loops += 1;
					piece = possible_pieces[rand].instance();
				# instance that piece from the array 
				add_child(piece);
				piece.position = grid_to_pixel(i,j);
				all_pieces[i][j] = piece;


func _on_Fill_Timer_timeout():
	fill_columns();
	pass # Replace with function body.
