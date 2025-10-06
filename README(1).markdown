# Qbox Carry Script

This is a simple carry script for Qbox Framework (QBCore fork) integrated with `ox_target`. It allows players to carry other players using a fireman carry animation. Players can target another player (within 2 meters) to start carrying, and press `E` to stop.

## Features
- **ox_target Integration**: Right-click on a player and select "Carry".
- **Animations**: Uses GTA V fireman carry animations.
- **Server-Side Validation**: Checks distance and prevents conflicts (e.g., can't carry someone already being carried).
- **QBX Notifications**: Uses Qbox's notification system for feedback.
- **Cleanup**: Handles player disconnects to prevent stuck states.
- **Key Binding**: Press `E` to stop carrying.

## Dependencies
- `qbx_core` (Qbox Framework)
- `ox_target`
- `ox_lib` (for notifications)

## Installation

1. **Download the Script**:
   - Create a folder named `qbx_carry` in your server's `resources` directory.
   - Place the provided files (`fxmanifest.lua`, `client.lua`, `server.lua`) in the `qbx_carry` folder.

2. **Ensure Dependencies**:
   - Install `ox_target`, `qbx_core`, and `ox_lib` if not already present.

3. **Add to Server.cfg**:
   - Add the following line to your `server.cfg` file:
     ```
     ensure qbx_carry
     ```

4. **Restart Server**:
   - Restart your FiveM server, or run `refresh` followed by `start qbx_carry` in the server console.

## Usage
- **Start Carrying**: Approach another player (within 2 meters), right-click them, and select "Carry" from the ox_target menu.
- **Stop Carrying**: Press `E` while carrying to drop the player.
- **Notifications**: You'll see QBX notifications like "You are now carrying [Name]!" or "You are too far away!".

## Configuration
- **Distance**: Adjust the interaction distance in `client.lua` (line ~70: `distance = 2.0`).
- **Key Binding**: Change the stop key in `client.lua` (line ~95: `IsControlJustPressed(0, 38)` for E key).
- **Animations**: Modify animation dicts/names in `client.lua` (lines ~8-9) for custom animations.
- **Permissions**: Currently open to all players. Add ACL checks in `server.lua` if needed (e.g., job requirements).

## Troubleshooting
- **No Target Option**: Ensure `ox_target` is running and players are in range (2 meters).
- **Animations Not Playing**: Check console for errors; ensure animation dicts load correctly.
- **Stuck Carrying**: Restart the resource (`restart qbx_carry`) or reconnect. The script handles disconnects automatically.
- **Notifications Missing**: Verify `ox_lib` and `qbx_core` are up to date.
- **Errors**: Check F8 (client console) or server console for Lua errors. Common issues: missing dependencies or incorrect paths.

## Notes
- **Compatibility**: Tested with Qbox v1.x and ox_target v1.x. Uses standard GTA V animations.
- **Performance**: Lightweight; no loops beyond necessary checks.
- **Customization**: For advanced features (e.g., carry limits, job restrictions, or drag instead of carry), extend the events in `server.lua`.
- **Support**: If you encounter issues, provide console logs. Contributions via pull requests are welcome!

## License
MIT License - Feel free to modify and distribute.