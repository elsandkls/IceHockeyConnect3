extends Node

onready var Global = get_node("/root/Global");  

#####
var path_SharedDBs = "res://Resources/SharedDB/" 
var file_LevelSpecs = path_SharedDBs + "levelspecs.csv"
# res://Resources/SharedDB/levelspecs.csv
# var LevelSpecs  
# var LevelSpecs_matrix = [] 
#####

# Called when the node enters the scene tree for the first time.
func _ready(): 
	var delim = ","
	var newLineDelim = "\n"
	#print(Global)
	
	## open and read files  
	#print(file_LevelSpecs)
	Global.LevelSpecs  = loadDB_(file_LevelSpecs)
	var LevelSpecs_Lines  = Global.LevelSpecs.split(newLineDelim, true, 0)
	var LevelSpecs_LineEntryCount = LevelSpecs_Lines.size()
	for l in range(LevelSpecs_LineEntryCount):
		Global.LevelSpecs_matrix.append([])
		Global.LevelSpecs_Array = LevelSpecs_Lines[l].split(delim, true, 0)
		var LevelSpecs_EntryCount = Global.LevelSpecs_Array.size()
		for n in range(LevelSpecs_EntryCount):
			#id,level,width,height,goal,points,minutes,turns,color,type,reward,amount
			#print(String(l) + ":" + String(n) + ":" + Global.LevelSpecs_Array[n]) # Prints n entry		
			Global.LevelSpecs_matrix[l].append(Global.LevelSpecs_Array[n])
	saveDB_(Global.LevelSpecs, file_LevelSpecs)
	
	
func loadDB_(fileName):
	var content = loadFile( fileName) 
	return content
	
func saveDB_(content, fileName ):
	saveFILE(content, fileName ) 
	  
func saveFILE(content, fileName ):
	var file = File.new()
	file.open(fileName, File.WRITE)
	file.store_string(content)
	file.close()
	
func loadFile( fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
	
	 
#icehockey_team_database.gd_csv
