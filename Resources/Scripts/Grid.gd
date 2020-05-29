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
			while ( match_at(i,j, possible_pieces[rand].color) && loops < 100):
				rand = floor(rand_range(0, possible_pieces.size()));
				loops += 1;
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
	pass;
