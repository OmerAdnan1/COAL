# Maze Game (IAPX 8088 Assembly)

## Overview

This is a maze game developed in Assembly (IAPX 8088) as part of a COAL project. The game dynamically generates a maze using an algorithm that removes walls (right, down, or both) and allows the player to navigate to a randomly generated endpoint.

## Features

- **Maze Generation:** Walls are removed strategically to form a solvable maze.
- **Player Navigation:** Move through the maze to reach the endpoint.
- **Scoring System:** Points are awarded based on collected hearts and time taken.
- **Lives System:** Players have a limited number of lives.
- **Enemy Movement:** An enemy moves randomly throughout the maze.

## How to Play

1. **Start the Game:** The maze is generated upon launching.
2. **Navigate:** Use the keyboard to move through the maze.
3. **Collect Hearts:** Increases your score.
4. **Avoid the Enemy:** The enemy moves randomly; avoid getting caught.
5. **Reach the Endpoint:** Complete the maze before losing all lives.
6. **Superman Mode:** Press 'M' to activate, allowing the player to move to the furthest open space in the chosen direction (W, A, S, D) until reaching a boundary.

## Controls

- **W** - Move Up
- **S** - Move Down
- **A** - Move Left
- **D** - Move Right
- **M** - Activate and Deactivate Superman Mode

## Technical Details

- **Platform:** Assembly (IAPX 8088)
- **Algorithm:** Wall removal for maze generation
- **Game Elements:** Player, enemy, hearts, endpoint

## Future Improvements

- Smarter enemy movement
- Additional obstacles
- Enhanced scoring mechanics

## Credits

- Developed as part of a COAL project.
- Contributors: Omer Adnan, Ali Adnan

Notes

This game runs on an x86 emulator supporting IAPX 8088 Assembly. Ensure compatibility before running.

