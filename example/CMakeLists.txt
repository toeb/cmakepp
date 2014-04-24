cmake_minimum_required(VERSION 2.8)
# include standalone version of oo-cmake
# when not using cutil this  includes the function files as well as
# the dependent functions
include("../oo-cmake.cmake")

message("creating a simple inheritance example")

#create animal object
obj_create(animal)

# set object method eat
# this method prints out which food the animal is eating
# existing functions can also be appliead via obj_bindcall(${ref} func arg1 arg2 arg3)
obj_setfunction(
	${animal}  	#reference to animal object
	" function( eat ) \n obj_get(\${this}  food) \n ans(food) \n message(\"I am eating \${food}\") \n	 endfunction()"
)


# create mamal object
obj_create(mamal)
obj_setprototype(${mamal} ${animal})

#create bird object
obj_create(bird)					#create instance
obj_setprototype(${bird} ${animal})	#set prototype animal
obj_set(${bird} food Birdfood)		#set bird's food property to "Birdfood"

#create dog object
obj_create(dog)						#create instance
obj_setprototype(${dog} ${mamal})	#set prototype mamal
obj_set(${dog} food Dogfood)		#set dogs food property to "Dogfood"

#create cat object
obj_create(cat)						#create instance
obj_setprototype(${cat} ${mamal})	#set prototype mamal
obj_set(${cat} food Catfood)		#set cat's food property to "Catfood"


# call eat function for different objects
obj_callmember(${bird} eat) 
obj_callmember(${dog} eat)
obj_callmember(${cat} eat)

#output should be
#I am eating Birdfood
#I am eating Dogfood
#I am eating Catfood
