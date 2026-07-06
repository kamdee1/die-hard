# Die Hard - Shooting Platform Game

A Contra-style shooting platform game built with **Godot 3.x**. Fight your way through multiple levels, defeat enemies, and reach the top of the building!

## Features

- **Player Character**: Run, jump, climb, and shoot mechanics
- **Multiple Weapons**: Spread shot, laser, grenades (with pickups)
- **Enemy AI**: Patrol, alert, and attack behaviors
- **Platforms & Ladders**: Navigate vertical and horizontal level design
- **Health & Lives System**: Manage your health bar and lives
- **Power-ups**: Weapon upgrades, health restoration, ammo
- **Level Progression**: Multiple challenging levels with increasing difficulty
- **Score & HUD**: Track kills, score, and health

## Controls

| Action | Key |
|--------|-----|
| Move Left | A / Left Arrow |
| Move Right | D / Right Arrow |
| Jump | W / Up Arrow / Space |
| Climb Up | W / Up Arrow |
| Climb Down | S / Down Arrow |
| Shoot | Left Mouse / Spacebar |
| Change Weapon | E / Number Keys (1-3) |
| Pause | P / ESC |

## Project Structure

```
die-hard/
├── scenes/
│   ├── Main.tscn           # Main game scene
│   ├── Player.tscn         # Player character
│   ├── Enemy.tscn          # Enemy template
│   ├── Level.tscn          # Level layout
│   ├── UI.tscn             # HUD and UI
│   └── Weapon.tscn         # Weapon/projectile
├── scripts/
│   ├── Player.gd           # Player controller
│   ├── Enemy.gd            # Enemy AI
│   ├── Level.gd            # Level manager
│   ├── GameManager.gd      # Game state
│   ├── Weapon.gd           # Weapon system
│   └── UI.gd               # UI logic
├── assets/
│   ├── sprites/            # Character & enemy graphics
│   ├── sounds/             # SFX and music
│   └── tilesets/           # Platform tiles
└── project.godot           # Godot project file
```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/kamdee1/die-hard.git
   cd die-hard
   ```

2. **Open in Godot 3.x**:
   - Download [Godot 3.5+](https://godotengine.org/download)
   - Open Godot and import this project
   - Click "Import & Edit"

3. **Run the game**:
   - Press **F5** or click the Play button
   - Start playing!

## Gameplay

### Level Progression
- Complete each level by reaching the exit
- Defeat all enemies to progress
- Collect power-ups for weapons and health

### Combat System
- **Primary Weapon**: Unlimited ammo
- **Special Weapons**: Limited ammo, pick up from defeated enemies
- **Spread Shot**: Wide coverage, good for groups
- **Laser**: Single powerful beam
- **Grenades**: Explosive projectiles

### Health & Lives
- Start with 3 lives and 100 health
- Pick up health packs to restore health
- Lose a life when health reaches 0
- Game over when all lives are lost

## Development

### Adding New Enemies
1. Create a new scene inheriting from `Enemy.tscn`
2. Customize in the editor or extend `Enemy.gd` script
3. Add to level in `Level.gd`

### Creating New Levels
1. Duplicate `scenes/Level.tscn`
2. Design platforms using TileMap
3. Add enemies using the Enemy spawner
4. Update `Level.gd` with level-specific logic

### Custom Weapons
1. Extend `Weapon.gd` script
2. Define projectile behavior and damage
3. Add to weapon selection system in `Player.gd`

## Assets

Placeholder assets are included. For a full game, replace with:
- Character sprites (run, jump, shoot animations)
- Enemy sprites (different enemy types)
- Platform tilesets
- Sound effects and background music
- UI elements and fonts

## Future Enhancements

- [ ] More enemy types with unique behaviors
- [ ] Boss battles at level ends
- [ ] Difficulty settings (Easy, Normal, Hard)
- [ ] Combo/streak system
- [ ] Destructible environments
- [ ] Cheat codes (Konami code reference!)
- [ ] Leaderboards
- [ ] Mobile controls support
- [ ] Controller support

## Known Issues

- Placeholder assets need replacement
- Sound system needs implementation
- Controller mapping needs expansion

## License

This project is open source. Feel free to modify and distribute!

## References

Inspired by the classic Contra series and Die Hard action games.

---

**Made with Godot 3.x** 🎮
