# Gemini Development & Testing Guide 🚀

Welcome to the **Space Defenders** developer guidelines. This document is designed for developers and AI agents (specifically Antigravity / Gemini) to understand the codebase structure, how recent critical bugs were resolved, and how to write and run tests so that these errors never regress.

---

## 🛠️ Core Architecture & Viewport

- **Canvas Dimensions**: The internal resolution is designed at a high-definition **2048 × 1152** coordinate space.
- **Window Display Scaling**: Configured in `project.godot` with overrides to fit typical displays without cropping:
  - Width Override: `1280`
  - Height Override: `720`
  - Stretch Mode: `canvas_items` (Aspect: `expand`)
- **Autoloads**: 
  - `GameManager`: Controls game states (Active, Repositioning, Paused) and round speed cycles (1x, 2x, 3x).
  - `EconomyManager`: Centralizes all mineral, refund, and fee logic.
  - `RoundManager`: Stores compositions for all 10 rounds.
- **Freeform Ship Placement**: Ship placement operates on smooth continuous (float) coordinates rather than a grid:
  - **Path Clearance**: Ships must clear the path center line by **48 pixels** (`pos.distance_to(closest_path_point) >= 48.0`).
  - **Overlap Prevention**: Ships cannot be placed closer than **48 pixels center-to-center** from other ships (`pos.distance_to(other_ship) >= 48.0`).
  - **Screen Boundaries**: Ships are kept at least **24 pixels** inside screen borders (`pos.x` in `[24, 2024]`, `pos.y` in `[24, 1128]`) to avoid clipping.
  - **HUD Clearance**: Ships must stay between **100 pixels** and **990 pixels** on the Y-axis (`pos.y > 100.0` and `pos.y < 990.0`) to avoid overlapping the top bar and bottom shop HUD interfaces.

---

## 🧪 Automated Testing Framework

To avoid heavy external dependencies like GUT, Space Defenders features a custom, lightweight **Test Runner** located at [test_runner.gd](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/tests/test_runner.gd). 

This script loads mock scenes, runs assertions, and prints/renders a clean visual UI log directly in Godot.

### How to Run the Tests
1. Open the project in the **Godot Editor**.
2. Locate `res://tests/test_runner.tscn` in the FileSystem dock.
3. Right-click the file and select **Play Scene** (or press `F6` with the scene open).
4. A window will launch, run all tests, and display a color-coded success/failure report (Green for Pass, Red for Fail).

---

## 🐞 Recent Bug Fixes & Regression Protection

We added explicit automated regression tests for every single error encountered to ensure they never happen again. Below is the breakdown:

### 1. HUD Type Mismatch Error
- **Error**: `Script inherits from native type 'Control', so it can't be assigned to an object of type: 'CanvasLayer'`
- **Root Cause**: The UI scene `hud.tscn` root was a `CanvasLayer`, but the attached script `hud.gd` inherited from `Control`.
- **Resolution**: Updated `hud.gd` to `extends CanvasLayer` and dynamically created the layout root `Control` under it in `_ready()` to handle full-screen margins.
- **Regression Test**: Added **Regression 3** in `test_runner.gd` to instantiate the HUD and assert `mock_hud is CanvasLayer`.

### 2. GDScript Integer Division Warning
- **Error**: `Integer division. Decimal part will be discarded. hud.gd:127 @ GDScript::reload()`
- **Root Cause**: GUI positioning math used integer division (`2048 / 2 - 1360 / 2`) which discards the fractional part.
- **Resolution**: Converted all division calculations in HUD layout to floats (`2048.0 / 2.0 - 1360.0 / 2.0`).

### 3. Array Type Assignment Error
- **Error**: `start_round: Trying to assign an array of type "Array" to a variable of type "Array[int]" @ round_manager.gd:66`
- **Root Cause**: Godot 4 typed arrays (`Array[int]`) reject direct assignments of generic untyped `Array` values parsed from JSON configurations.
- **Resolution**: Switched to a type-safe conversion loop that appends items using explicit casting (`s as int`).
- **Regression Test**: Added **Regression 1** in `test_runner.gd` to verify loading configuration spawns into a typed `Array[int]`.

### 4. Input Swallowing / Cannot Place Towers
- **Error**: *Clicking works on UI, but mouse left-clicks do not place towers on the field.*
- **Root Cause**: The full-screen root `Control` node inside `CanvasLayer` HUD defaulted to swallowing mouse actions, intercepting them before they could reach `_unhandled_input` in `main.gd`.
- **Resolution**: Explicitly set the HUD root's mouse filter to ignore mouse events: `root.mouse_filter = Control.MOUSE_FILTER_IGNORE`.
- **Regression Test**: Added **Regression 2** in `test_runner.gd` which checks that `hud_root.mouse_filter` is equal to `Control.MOUSE_FILTER_IGNORE`.

### 5. Unused Parameter Warning in Projectile Explode
- **Warning**: `The parameter "primary_target" is never used in the function "_explode()". If this is intended, prefix it with an underscore: "_primary_target".`
- **Root Cause**: The visual/radius explosion helper function signature `_explode(primary_target: Node2D)` in `projectile.gd` did not use `primary_target` inside the body since it handles full AoE damage scanning.
- **Resolution**: Prefixed with an underscore: `_primary_target` to denote an explicitly ignored parameter and silence the GDScript lint engine.

### 6. Physics Server flushing_queries Crash
- **Error**: `Can't change this state while flushing queries. Use call_deferred() or set_deferred() to change monitoring state instead. Condition "area->get_space() && flushing_queries" is true.`
- **Root Cause**: Splitting an asteroid (`take_damage()`) inside a physics collision callback (`_on_area_entered` in `projectile.gd`) immediately instantiates and adds child asteroids to the scene tree via direct synchronous calls. Their `_ready()` runs, adding shapes to Area2Ds and mutating the physics state while the physics engine is still busy flushing query structures.
- **Resolution**: Modified splitting in `asteroid.gd` to invoke child spawning on the main nodes using **`call_deferred("spawn_asteroid", ...)`** which safely pushes child node creation and physics setup to the idle/next frame.

### 7. Sticky Red Indicator & HUD Event Swallowing
- **Error**: *Ghost placement ship becomes permanently red when hovering over HUD menus at normal mouse speed, only escaping with a fast cursor flick.*
- **Root Cause**: Two issues combined:
  1. The layout panels, containers, and margins in `hud.gd` defaulted to `mouse_filter = MOUSE_FILTER_STOP`, swallowing mouse motion events and freezing cursor tracking inside unbuildable coordinates.
  2. The ghost ship's programmatically drawn range circle properties were modified in `_process()`, but because `queue_redraw()` was not called on the ghost ship node every frame, Godot did not refresh the visuals. The indicator only redrew when the mouse exited/entered the ship's Area2D collision bounds (which occurs when flicking rapidly).
- **Resolution**:
  1. Set `mouse_filter = Control.MOUSE_FILTER_IGNORE` on the HBoxContainer and PanelContainers in `hud.gd` and the root node of `ship_panel.gd` to propagate motion events smoothly.
  2. Implemented a top boundary check (`pos.y <= 100.0`) in `main.gd` to prevent placement behind the top HUD bar.
  3. Added **`ghost_ship.queue_redraw()`** inside `main.gd`'s `_process()` to guarantee pixel-perfect color indicator updates on every frame.
- **Regression Test**: Added **Regression 4** in `test_runner.gd` to instantiate the HUD and assert that `top_bar`, `lives_panel`, and `shop_panel_container` are set to `Control.MOUSE_FILTER_IGNORE`.

---

## 📝 How to Write Tests for New Errors

Whenever you identify or receive reports of a new bug, follow this workflow to write a test and maintain high stability:

### Step 1: Diagnose and Fix the Bug
Fix the bug in the relevant file (e.g., `entities/ships/ship.gd`, `autoloads/economy_manager.gd`, etc.).

### Step 2: Open the Test Runner Script
Navigate to [test_runner.gd](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/tests/test_runner.gd).

### Step 3: Add a New Regression Block
Under the `# Test 3: Regression Tests` section, add a clear, isolated assertion.

**Use this template for new regression tests**:
```gdscript
	# Regression X: [Brief description of the bug, e.g. Missile Splash Area scaling]
	var test_success = true
	
	# 1. Setup mock environments/nodes (if required)
	var mock_node = Node2D.new()
	add_child(mock_node)
	
	# 2. Perform actions / calculations
	var result = mock_node.some_method_to_test()
	
	# 3. Assert correct values
	if result != EXPECTED_VALUE:
		log_text += "  [FAIL] Regression X: Detailed error message (got %s, expected %s)\n" % [result, EXPECTED_VALUE]
		passed = false
	else:
		log_text += "  [PASS] Regression X: Bug verification description\n"
		
	# 4. Clean up mock nodes
	mock_node.queue_free()
```

### Step 4: Run and Verify
Play the `test_runner.tscn` scene in Godot and ensure that your new test passes seamlessly!

---

## 📚 Documentation Maintenance Guidelines

> [!IMPORTANT]
> **CRITICAL RULE**: Whenever you make a balance change, adjust gameplay values (e.g., ship costs, ranges, swarm density), refactor architecture, or resolve bugs, you **MUST** proactively update the corresponding documentation:
> 1. **GDD Files**: Keep the modular Game Design Documents located in the [gdd/](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/gdd) folder (e.g., [04_spaceships.md](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/gdd/04_spaceships.md), [06_round_system.md](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/gdd/06_round_system.md)) fully synchronized with the actual variables.
> 2. **Project README**: Make sure the root [README.md](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/README.md) is updated if core game concepts or terms change.
> 3. **Developer Guide**: Keep this [gemini.md](file:///wsl.localhost/Ubuntu/home/vitor/projects/games/tower-defense/gemini.md) guide updated with changes to layouts, coordinate bounds, or testing protocols.
> 
> Failing to keep the GDD and specs in sync with code is not allowed. Always verify and document changes immediately.

---

*Keep the codebase robust, clean, and bug-free!* 🌌

