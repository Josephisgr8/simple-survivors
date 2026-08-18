# 🚀 Simple Spell Brigade

> A 2D roguelike starter game built to learn the foundations of Godot. Features player movement, attack management, enemy tracking, experience orb merging, and player progression.

---

## 🛠 Features Included

* **Player System:** `CharacterBody2D` controller with movement, input handling, state-driven behaviors, and weapon arsenal growth.
* **Architecture:** Component-based node structure managing discrete entities (`EnemyManager`, `Enemy`, `XpManager`, `XpOrb`).
* **State Machine:** Finite State Machine pattern for decoupled player behavior and action transitions.
* **Enemy Logic:** Pathfinding targeted at the player, featuring soft separation behavior so units push apart without remaining rigid.
* **Performance Optimization:** Leverages GDScript static typing, `distance_squared_to()` calculations over square-root operations, and spatial grid hashing on a timed interval to merge nearby XP orbs efficiently.

---

## 📂 Folder Structure

```
res://
├── assets/                # Visual graphics and art
│   ├── Backgrounds/
│   └── Sprites/
├── Scenes/                # Game scene files (.tscn)
├── Scripts/               # GDScript logic files (.gd)
│   ├── PlayerStates/      # Concrete player state implementations
│   └── StateBaseScripts/  # Abstract base classes for the FSM pattern
├── README.md
└── project.godot
```

---

## ⚙️ Key Autoloads (Singletons)

*No global singletons are configured at this stage of the project.*

---

## 🚦 Getting Started

### Prerequisites

* **Godot Engine:** `v4.x` (Forward+ renderer)

### Quickstart

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/Josephisgr8/simple-spell-brigade.git](https://github.com/Josephisgr8/simple-spell-brigade.git)
   ```
2. **Open Godot Engine, click Import, and select the 'project.godot' file in the project root directory**
3. **Press F5 (or click 'Run Project' in the top right by default) to launch the main game scene (res://Scenes/game.tscn)**
