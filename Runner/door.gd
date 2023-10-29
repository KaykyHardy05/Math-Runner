extends Node3D #Door

#To help with autocompletion
class_name QuizDoor

@export var speed = 0.15

@warning_ignore("unused_parameter")
func _process(delta):
	position += Vector3 (speed, 0, 0)
#@export variables can be set from the editor, in the inspector.  
#The format is "@export var" followed by the name of the variable, then  
#separated by a ":", the type that will reside in the variable.  
#If the type is of "Node" (or a descendant of it) you can set a reference to it with the variable

#Label is a descendant from Node 
@export var labelWithAnswerOne:Label3D      
@export var labelWithAnswerTwo:Label3D
@onready var labelForAnswerOne:Label3D = $"Label3D-1"
@onready var labelForAnswerTwo:Label3D = $"Door-2/Body-2/Label3D-2"
  
#A Dictionary can contain any amount of pairs of keys and values.   
#Each element in a pair is separated by a ":" and the pair terminated with a ","    
@export var questions:Dictionary = {  
#math problem and results
"23x1?" : "23",        "100x0,5?" : "50",    "19+47?" : "66",
"32x6?" : "192",       "27-8?" : "19",       "12-4?" : "8",
"10x11,9?" : "119",    "17+11?" : "28",      "69x1?" : "69",
"77+33" : "110",       "39-39" : "0",        "65-20" : "45",
"94-66" : "28",        "81-44" : "37",       "70x18" : "1260",
"91-20" : "71",        "44x64" : "2816",     "59+75" : "134",
"61-57" : "4",         "97+48" : "145",      "71+56" : "127",
"62+12" : "74",        "75-27" : "48",       "49+76" : "125",
"19x5" : "95",         "75x48" : "3600",     "80-18" : "62",
"86-66" : "20",        "23+44" : "67",       "47+49" : "96",


}    

#Some examples of functions  
#The "->String" indicates this function equals (returns) a string (which is what you'd use it for in this case), it will warn you if it doesn't.  
func get_random_question()->String:   

	#.keys() is a function from Dictionary, it equals an Array of the keys in it  
	#.pick_random() is a function from Array, it returns a random element inside of it.
	var randomQuestion:String = questions.keys().pick_random()     

	return randomQuestion
	
  

func get_answer_to_question(question:String)->String:     

	#To get a value from a dictionary using it's key, you put the key inside []'s
	var answer:String = questions[question]          

	return answer  

func get_wrong_answer(question:String)->String:      

	#You can specify what elements an Array can contain by putting it inside []'s  

	var answers:Array = questions.values()    

	#Remove the correct answer from the list  
	answers.erase( get_answer_to_question(question) )	  
	return answers.pick_random()

func present_question( question:String ):

	#randi() % 1 equals a random number between 0 and 1 
	if randf() > 0.5: 
		labelForAnswerOne.text = get_answer_to_question( question )  
		labelForAnswerTwo.text = get_wrong_answer( question )    
	else:
		labelForAnswerTwo.text = get_answer_to_question( question )
		labelForAnswerOne.text = get_wrong_answer( question )    


func is_answer_to_question(answer:String, question:String)->bool:  
	if questions[question] == answer:   
		return true  
	else:  
		return false



#Signal that the Main node can use to know what was selected
#This signal carries the answer with it
signal answer_chosen(answer:String)

#For easy access to the areas, like with the labels
@export var labelOneDetector:Area3D
@export var labelTwoDetector:Area3D

#Connecting the areas to the labels
func _ready():
	labelOneDetector.body_entered.connect(on_label_one_chosen)

	labelTwoDetector.body_entered.connect(on_label_two_chosen)

#And functions to react to their activation
func on_label_one_chosen( _whatever ):
	answer_chosen.emit(labelWithAnswerOne.text)

func on_label_two_chosen( _whatever ):
	answer_chosen.emit(labelWithAnswerTwo.text)
