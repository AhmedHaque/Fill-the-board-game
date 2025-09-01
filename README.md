# Fill-the-board-game
### Program Overview
This program was made to test how Timers work in the Tiva. The program uses Arm Assembly language. The following program we have a game in a 20 by 20 grid for which the goal is to get the highest score without hitting a previously visited space or a wall. The program is controlled by the WASD keys in which the W key moves the character up, the S key moves the character down, the A key moves the character left and the D key moves the character to the left. When the game starts the character starts moving in an upward direction. With every X (the character we control) is moved a X is left behind to indicate that the space has already been visited. For every X that is placed the score goes up by 1. If we click the SW1 button on the Tiva board it pauses the game. Clicking it again would resume the game again.
### Directions to use
- Start the program
- Use WASD keys to select character directions
- Score is incremented with every valid step.
- Game ends when character hit a “ - “ or “ | “ or a previously visited square “ X ”
- To restart the game, rerun the program.
### Subroutine Description
Print_game(): The following subroutine checks prints a new character and the game board with previous game board based on the character that is pressed by the user. W prints a new grid with a character above. S prints a new grid with a character below. A prints a new grid with a character on the left of the previous character. D prints a new grid with a character right on the left of the previous character.
Timer_Handler_fail(): The following function gets called when a character overlaps with another character. It ends the game and displays the End message and ends the program.
