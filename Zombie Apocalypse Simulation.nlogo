breed [ zombies zombie ]                    ; creating a population of zombie who will move around aimlessly
breed [ humans human ]                      ; creating a population of humans who will move around aimlessly but also seen the zombie
breed [ food fish ]                         ;creating a population of fish for food for the humans to eat to regain health!
breed [ weapon ammo ]                       ; creating a population of weapons/ammo as weapons to defend the humans!

patches-own [solid ]                        ;this creates a variable for the patches to establish if it should be percieved as solid

humans-own [ zombie_seen zombie_encounter   ;this creates 2 variables which will be used to count the total zombies seen and zombies encountered
  health robustness speed_variation         ;this creates 3 variables for health, durability and speed
  per_vis_rad per_vis_ang                   ;this creates variables for personlised vision cones
  food_around_me closest_food               ;this creates 2 variables to save the location of food
  have_weapon                               ;this creates a variable to store the amount of weapon held
  vis_rand                                  ;this creates a variable to store a stable vision cone random value
]

zombies-own [
  human_around_zombie                       ;this creates a variable for the zombie to detect a human in it's radius
  closest_human                             ;this creates a variable to detect the closest human
]

food-own [ amount ]                         ;this creates a variable for the food to establish amount of the resource

globals [rad                                ;this creates a global variable called rad
daytime starting_color current_color        ;this creates 3 global variables relating to creating day and night within our model
color_adjust color_range
  timer_reset ]                             ;this creates a global variable called for resetting the timer

to setup                                    ; this creates a function called setup
  clear-all                                 ; this clears the world of any previous activities
  reset-ticks                               ; this resets the ticks counter
  set rad 5                                 ; this sets the global variable rad to 3

  set timer_reset 1000                                     ;this sets the global variable reset_timer to 1000
  set daytime true                                         ;this sets the global variable daytime to true
  set starting_color 95                                    ;this sets the global variable starting_color to 85 which is blue
  set current_color starting_color                         ;this sets the global variable current_color to starting_color
  set color_range 5                                        ;this sets the global variable color_range to 5.
  set color_adjust ( color_range / ( timer_reset + 10 ))   ;this sets the global variable color_adjust to a range based on the variable above

  create-zombies number_of_zombie [         ; this creates the number of zombie that your global variable states
    setxy random-xcor random-ycor           ; this sets the starting position of the zombie to a random location in the world
    set color gray                          ; this sets the color of the zombie to gray
    set size 10                             ; this sets the size of the zombie to 10
    set shape "person"                      ; this sets the shape of the zombie to a person
  ]

  create-humans number_of_humans [; this creates the number of humans that your global variable states
    setxy random-xcor random-ycor           ; this sets the starting position of the humans to a random location in the world
    set color red                           ; this sets the color of the humans to blue
    set size 10                             ; this sets the size of the humans to 10
    set shape "person"                      ; this sets the shape of the humans to a human

    set health 30 + random  10              ;sets the health of the human by adding 50 + a random allocation up to 50
    adjust_vision_cone                      ;set up the vision cone
    set robustness random 10                ;sets the robustness variable to a random value up to 10
    set speed_variation random 10           ;higher the number the faster they will go
    ;set heading 0                          ; demonstrate it has impact
    ;pen-down                               ; this puts the pen down to see where the human moves (history of the human)
    set vis_rand random 5

     ifelse show-health?                    ;show-health? switch
     [ set label health ]                   ;show the health stat for humans
      [ set label "" ]                      ;set string label
]

  create-weapon 10 [                        ;this creates X number of new weapons for the humans to store and use against the zombies
    make_weapon                             ;this calls the make_weapon function
  ]

  create-food 2 [                         ;this creates X number of new food plants for the humans to feed from to regain health
  grow_food                                ;this calls the grow_food function
  ]

    draw_building                          ;this calls the draw_building function
end

to draw_building                            ;this creates a function called draw_building
  ask patches [                             ;this selects all of the patches to follow a command
    set solid false                         ;this sets the patch variable solid to false for all patches
  ]
  ask patches with [ pxcor >= -30 and pxcor <= 30 and pycor >= -30 and pycor <= 30] [   ;this selects only patches that meet the parameters

    set pcolor brown                                                                    ;this sets the color of all the patches selects to brown
    set solid true
  ]
end

to detect_wall                              ;this creates a function called detect_wall
  if [solid] of patch-ahead 1 = true [      ;if patch variable of 1 patch ahead is true then...
    right 180                               ;turn around to opposite direction
  ]
end

to convert
  ask turtles-on patch-here [ set breed zombies
    set color gray
    set size 10
    set shape "person"]
end

to make_weapon                              ;this creates a function called make_weapon
  setxy random-xcor random-ycor             ;this sets the position of the weapon to a random location in the world
  set color green                           ;this sets the color of the weapon to green
  set size 5                                ;this sets the size of the weapon to 5
  set shape "x"                             ;this sets the weapon shape to an x
end

to grow_food                               ;this creates a function called grow_food
  setxy random-xcor random-ycor            ;this sets the position of the food to a random location in the world
  set color yellow                         ;this sets the color of the food to yellow
  set size 10                              ;this sets the size of the food to 10
  set shape "fish"                        ;this sets the shape of the food to a fish
  set amount random 10                     ;this sets the amount of food per plant to a random value up to ''
  end

to go                                       ; this creates a function called go
  make_zombie_move                          ; this calls the make_zombie_move function
  reset_patch_color                         ; this calls the reset_patch_color function
  make_humans_move                          ; this calls the make_humans_move function
  draw_building                             ; calls the draw building function
  tick                                      ; this adds 1 to the tick counter
  grow_more_food                            ; this calls the grow_more_food function
if not any? humans [ stop ]                 ; exits if there are no more humans
if not any? zombies [ stop ]                ;exits if there are no more zombies

end

to make_zombie_move                         ; this creates a function called make_zombie_move
  ask zombies[                              ; this asks all of the zombie in the population to do what is in the brackets
    set color gray                          ; this sets the color of each person to gray

    let can_see_human human_functions 30       ;set can_see_human radius to 30
    ifelse ( can_see_human = true ) [          ;if can_see_human is true then...
      set heading  (towards closest_human )    ;set zombie heading towards the closest human
    ]
    [right ( random pwr - ( pwr / 2))]        ; this turns the person right relative to its current heading by a random degree number using the range set within pwr NOTE: if negative it will turn left

    detect_wall                               ;this calls the detect_wall function
    forward zombie_speed                      ; this sets the speed at which the zombie move
  ]
end

to-report human_functions [sensitivity]                                  ;this creates a reporting function called human_functions and expects a value for sensitivity
  set human_around_zombie other ( humans in-radius sensitivity )         ;this sets the human_around_zombie variable to the ID's of the human within the sensitivity radius
  set closest_human min-one-of human_around_zombie [ distance myself ]   ;this sets the closest_human variable to the ID of the closest human source
  let can_see_human [false]                                              ;set can_see_human to false

  if (closest_human != nobody ) [                                        ;if closest_human is equal to nobody then...
    set can_see_human true                                               ;set can_see_human to true
  ]
  report can_see_human                                                   ;return value of can_see_human to location where function was called
end

to reset_patch_color                                                    ;this creates a function called reset_patch_color
  ifelse daytime = true [                                               ;if global variable daytime is true...
    set current_color current_color - color_adjust                      ;adjust global variable current_color using color_adjust variable
  ][                                                                    ;otherwise...
    set current_color current_color + color_adjust                      ;adjust global variable current_color using color_adjust variable
  ]
  ask patches [                                                         ; this asks all of the patches in the population to do what is in the brackets
    if solid = false [
    set pcolor current_color                                            ; this sets the color of each patch to current_color
  ]

  ]
end

to make_humans_move                                                      ;this is defining a function called make_humans_move
  ask humans [                                                           ;this asks all of the humans in the population to do what is in the brackets
     ifelse health > 0 [                                                 ;if health is greater than 0 ( still alive)...
      show_visualisations                                                ;call the show_visualtions function
       set color red                                                     ;this sets the color of each human to red
      let have_seen_zombie human_function                                ;this creates a local variable called have_seen_zombie the fills it with the return
      let can_smell_food food_function 30                                ;this creates a local variable called can_smell_food then fills it with the return value
       pickup_weapon                                                     ;this calls the pickup_weapon function

      ifelse ( have_seen_zombie = true ) [                               ;if local variable have_seen_zombie is true...
        right 180                                                        ;set the heading of human to 180 (turn around to avoid zombie!)
      ][
        ifelse ( can_smell_food = true ) [                               ;if local variable can_smell_food is true...
          set heading ( towards closest_food )                           ;set heading towards closest food source
        ][
          right (random bwr - (bwr / 2))                                 ;this turns the human right relative to its current heading by a random degree number
      ]]

      forward humans_speed + ( speed_variation * 0.01 )                  ;moves human forward by the humans_speed variable
    ][
      set color gray                                                     ;set color to gray to indicate dead human
      convert                                                            ;this kills the human off
    ]

]

end

to show_visualisations                                                    ; this creates a new function called show_visualisation
  if show_col_rad = true [                                                ; this will switch on the visualisation of the collision radius if the switch is set to true
      ask patches in-radius rad [                                         ; this sets up a radius around the zombie to display the size of the collison radius
      if solid = false [
        set pcolor orange                                                 ; this sets the patch color to orange
      ]
    ]
  ]

    if show_vis_cone = true [                                             ; this will switch on the visualisation of the vision cone if the switch is set to true
      ask patches in-cone per_vis_rad per_vis_ang [                       ; this sets up a vision cone to display the size of the cone by changing the patch color
        if solid = false [
        set pcolor red                                                    ; this sets the patch color to red
      ]                                                                   ;++++++++++++++++++++++++++++++++++ closing if statement
    ]
  ]
end

to-report food_function [sensitivity]                                     ;this creates a reporting function called food_function abd expects a value
  set food_around_me other ( food in-radius sensitivity )
  set closest_food min-one-of food_around_me [distance myself]
  let can_smell_food [false]                                              ;this creates a local variable valled can_smell_food and sets it to false
  let eating_food [false]

  if health < 100 [                                                       ;if health is less than 100 then...
   ask food in-radius rad [                                               ;this sets up a radius around the food to the value of the global variable rad
     ifelse amount > 0 [                                                  ;if amount is greater than 0
       set eating_food true                                               ;set the local variable called eating_food to true indicating the human is eating
       set amount amount - 5                                              ;reduces 5 from the amount variable in the food
       set color color - .25                                              ;reduce the color intensity of the food by .25
      ][
       die                                                                ;there is no food left so kill the agent
      ]
    ]
  ]
 if eating_food = true [                                                 ;if eating_food is true then...
    set health health + 5                                                ;add 5 health to the human

  ]
  if (closest_food != nobody) [                                          ;if closest_food is not empty (the human can smell food in range) then...
    set can_smell_food true                                              ;set can_smell_food to true
  ]
  report can_smell_food                                                  ;return value of can_smell_food to location where function is being called
end

to-report human_function

  let seen [false]                                                          ; this creates a local variable called seen
  let hit [false]                                                           ; this creates a local variable called hit
  let zombie_hit 0                                                          ;this creates a local variable calls upon zombie_hit and sets it to 0

    ask zombies in-cone per_vis_rad per_vis_ang [                           ; this sets up a vison cone with the parameters from vis_rad vis_ang to detects zombie
      set color green                                                       ; this sets the color of the person detected within the vision code of the human to green
      set seen true                                                         ; this sets the local variable called seen to true indicating that a person has been seen
    ]

  ask zombies in-radius rad [                                               ; this sets up a radius around the human for collision detection with zombie using rad
      set hit true                                                          ; this sets the local variable called hit to true indicating that a person has collided with
      set zombie_hit who                                                    ;this sets the local variable called person_hit to the individual who
    ]

   ifelse seen = true [                                                     ; if then else statement based on the local variable seen, if seen = true then...
      set zombie_seen zombie_seen + 1                                       ; add 1 to the zombie_seen count
      set color green                                                       ; set color of human to white
      ;right 180                                                            ; set heading of the human to 180 (turn around to avoid!)
    ][                                                                      ; if seen = false...

     ;right (random bwr - (bwr / 2))                                   ; this turns the human right relative to its current heading by a random degree number using the range set within bwr NOTE: if negative it will turn left
  ]

  if hit = true [                                                           ; if statement based on the local variable hit, if seen = true then...
    ifelse have_weapon > 0 [                                                ;if have_weapon is greater than 0 then...
     ask zombie zombie_hit [die]                                            ;kills of the zombie hit
      set have_weapon have_weapon - 1                                       ; remove 1 from the have_weapon of the human
    ][
      set zombie_hit zombie_hit + 1                                         ; add 1 to the zombie_encounter count
      set color green                                                       ;if hit by a zombie set human colour to green
      set health health - robustness                                        ;+++++++++++++
      adjust_vision_cone                                                    ;+++++++++++++++++++++++++++++
    ]
  ]
  report seen ;+++++++++++++++++++++++++++++++++++++
end

to pickup_weapon                                                            ; this creates a function called pickup_weapon
  let pickup [false]                                                        ;this creates a loval variable called pickup and sets it to false
  ask weapon in-radius rad [                                                ;this sets up a radius around the human to the value of the global variable rad which we are using for collision detection with the weapons to pick it up
    set pickup true                                                         ;this sets thew local variable pickup to true
    die
  ]
  if pickup = true [                                                        ;if pick is true then...
  set have_weapon have_weapon + 1                                           ;add 1 to the have_weapon count on the human
]
end

to adjust_vision_cone                                                                                                ;if statement is to check if health drop below 0 ( error checking )
       if ((((vis_rad + vis_rand)*(health * 0.01))) - ((starting_color - current_color) * 2) > 0) [                  ;if not as healthy what they can see is being reduced
         set per_vis_rad (((vis_rad + vis_rand)*(health * 0.01)) - ((starting_color - current_color) * 2))           ;set the pesonal vision radius to factor in some randomness and health ( less health = less vision )
    ]
  if ((vis_ang + vis_rand)*(health * 0.01)) > 0 [                                                                    ;if the calculation is greater than 0 then...
    set per_vis_ang ((vis_ang + vis_rand)*(health * 0.01))                                                           ;set the personal vision angle to factor in some randomness and health ( less health = less vision)
  ]

end

to grow_more_food                                                                                               ;this creates a new function called grow_more_food
  if ticks > timer_reset [ ;+++++++++++++++++++++                                                               ;if the current numer of ticks is greater than 100 then...
    ask patch random-xcor random-ycor [                                                                         ;ask the patch to do the following...
      sprout-food 1 [grow_food]                                                                                 ;sprout (create new) food (1 in this instance) then call grow_food function to set the parametres
    ]
    ifelse daytime = true [                                                                                     ;if global variable daytime is true then...
      set daytime false                                                                                         ;set global variable daytime to false
    ][                                                                                                          ;otherwise...
      set daytime true                                                                                          ;set global variable daytime to true
    ]
    reset-ticks                                                                                                 ; this resets the tick counter back to default
  ]
end

@#$#@#$#@
GRAPHICS-WINDOW
226
10
836
621
-1
-1
2.0
1
10
1
1
1
0
1
1
1
-150
150
-150
150
1
1
1
ticks
30.0

BUTTON
21
21
90
54
setup
setup\ndraw_building\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
21
177
54
go (forever)
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
8
232
102
265
vis_rad
vis_rad
0
50
33.0
1
1
NIL
HORIZONTAL

SLIDER
110
233
204
266
vis_ang
vis_ang
0
180
137.0
1
1
NIL
HORIZONTAL

SLIDER
12
431
206
464
number_of_zombie
number_of_zombie
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
9
114
203
147
number_of_humans
number_of_humans
0
30
5.0
1
1
NIL
HORIZONTAL

SLIDER
12
509
206
542
pwr
pwr
10
180
10.0
1
1
NIL
HORIZONTAL

SLIDER
12
470
206
503
zombie_speed
zombie_speed
1
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
10
193
204
226
bwr
bwr
10
180
10.0
1
1
NIL
HORIZONTAL

SLIDER
9
154
203
187
humans_speed
humans_speed
1
10
2.0
1
1
NIL
HORIZONTAL

SWITCH
10
273
204
306
show_col_rad
show_col_rad
0
1
-1000

SWITCH
10
314
204
347
show_vis_cone
show_vis_cone
0
1
-1000

PLOT
847
16
1128
190
Model stats
Time
Quantity
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Food" 1.0 0 -1184463 true "" "plot count food"
"Humans" 1.0 0 -2674135 true "" "plot count humans"
"Zombies" 1.0 0 -4539718 true "" "plot count zombies"
"Weapons" 1.0 0 -13840069 true "" "plot count weapon"

MONITOR
365
626
444
671
Zombies
count zombies
17
1
11

MONITOR
453
626
531
671
Humans
count humans
17
1
11

MONITOR
538
627
617
672
Food
count food
17
1
11

MONITOR
626
628
706
673
Weapon
count weapon
17
1
11

TEXTBOX
912
194
1062
215
Zombies Vs Humans
16
15.0
1

TEXTBOX
38
569
188
701
Zombie Apocalypse Simulation by AC
27
15.0
1

SWITCH
11
350
204
383
show-health?
show-health?
0
1
-1000

TEXTBOX
50
398
200
420
Zombie Stats
18
15.0
1

TEXTBOX
49
77
199
99
Human Stats
18
15.0
1

TEXTBOX
263
639
413
664
Total left:
20
15.0
1

@#$#@#$#@
ZOMBIE APOCALYPSE SIMULATION V12


WHAT IS IT? 

The agents in this model are HUMANS and ZOMBIES however, humans turn into zombies if they encounter a zombie and get bitten. 

Zombies are reflex agents that always attack when confronted by a human. Humans are rational agents that make decisions based on their immediate enviroment and the actions they can take at that moment.


HOW IT WORKS 

There are two main agents in this model, Zombies and Humans. The enviroment spawns two objects randomly anywhere on the map to help assist the humans to defeat the zombies. Food to regain their health when neccesary and weapons to have a fighting chance to defeat and kill the zombies. Food are denoted as a yellow fish icon and weapons are denoted as yellow 'x's. 

In addition, the humans own the following abilities: Robustness to become strong, Speed variation to increase speed and Vision cone to be able to see the zombies and flee. 

Furthermore, there are building/s that humans can pass through however, the zombies CANNOT pass through the buildings which makes the building a sort of SAFE ZONE for the humans. 

If a zombie wins a fight and reduces the humans health to 0 then it bites the human, and the human turns into a zombie. Otherwise, the human may flee from the zombie or fight and kill the zombie using their weapon to avoid becoming infected. 


HOW TO USE IT

Buttons

SET-UP resets the simulation and to get ready
GO (FOREVER) to run the simulation and watch in action 

Sliders

number_of_humans to increase the amount of humans that are placed
humans_speed to increase the speed variation of the humans 
bwr to increase the range of the degree humans turn away from zombies
vis_rad to increase the radius of the vision cone
vis_ang to increase the angle of the vision cone 
number_of_zombie to increase the amount of zombies placed
zombie_speed to increase the speed variation of the zombies
pwr to increase the range of the degree zombies turn to humans 

Switch 

show_col_rad to enable the radius around the human 
show_vis_cone to enable the vision cone function 

Monitors

Zombies monitors the amount zombies are left
Humans monitors the amount of humans left
Food monitors the amount of food left
Weapon monitors the amount of weapons left
 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Line -7500403 true 180 30 165 30

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
setup
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
