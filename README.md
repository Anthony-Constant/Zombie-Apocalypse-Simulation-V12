# ZOMBIE APOCALYPSE SIMULATION V12

## WHAT IS IT?

The agents in this model are HUMANS and ZOMBIES. However, humans turn into zombies if they encounter a zombie and get bitten.

Zombies are reflex agents that always attack when confronted by a human. Humans are rational agents that make decisions based on their immediate environment and the actions they can take at that moment.

## HOW IT WORKS

There are two main agents in this model: Zombies and Humans. The environment spawns two objects randomly anywhere on the map to help assist the humans to defeat the zombies. Food is used to regain health when necessary, and weapons provide a fighting chance to kill the zombies. Food is denoted as a yellow fish icon, and weapons are denoted as yellow 'x's.

In addition, humans have the following abilities: Robustness to become strong, Speed variation to increase speed, and Vision cone to be able to see the zombies and flee.

Furthermore, there are buildings that humans can pass through. However, the zombies CANNOT pass through the buildings, which makes the buildings a sort of SAFE ZONE for the humans.

If a zombie wins a fight and reduces the human's health to 0, the human turns into a zombie. Otherwise, the human may flee from the zombie or fight and kill the zombie using their weapon to avoid becoming infected.

## HOW TO USE IT

### Buttons

- **SET-UP:** Resets the simulation and gets ready.
- **GO (FOREVER):** Runs the simulation and watches it in action.

### Sliders

- **number_of_humans:** Increases the number of humans that are placed.
- **humans_speed:** Increases the speed variation of the humans.
- **bwr:** Increases the range of the degree humans turn away from zombies.
- **vis_rad:** Increases the radius of the vision cone.
- **vis_ang:** Increases the angle of the vision cone.
- **number_of_zombies:** Increases the number of zombies placed.
- **zombie_speed:** Increases the speed variation of the zombies.
- **pwr:** Increases the range of the degree zombies turn to humans.

### Switch

- **show_col_rad:** Enables the radius around the human.
- **show_vis_cone:** Enables the vision cone function.

### Monitors

- **Zombies:** Monitors the number of zombies left.
- **Humans:** Monitors the number of humans left.
- **Food:** Monitors the amount of food left.
- **Weapon:** Monitors the number of weapons left.

Please refer to the original source for a complete understanding of the simulation.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgements

This script was developed by [Anthony Constant](https://anthonyconstant.co.uk/).

## Support My Work

If you like this repository or have used any of the code, please consider showing your support:

- Give it a star ⭐️ to acknowledge its value.
- You can also support me by [buying me a coffee ☕️](https://ko-fi.com/W7W144CAO).

