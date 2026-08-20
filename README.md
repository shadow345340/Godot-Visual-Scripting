# Godot Visual Script

A high-performance, data-driven, and class-componentized visual scripting system designed natively for **Godot Engine 4.7**. Built from scratch using structured GDScript architecture and finite state machines, eliminating the rigidity of flat resource frameworks.

## Architecture & Modular Components

The plugin isolates responsibilities into strict single-purpose modules to guarantee microsecond execution times and clean memory cycle lifecycles:

*   **`VisualScriptCanvas`**: Orchestrator that connects the interface without managing logic data layers.
*   **`VisualNodeStateMachine`**: FSM governing context visual nodes (`Idle`, `Selected`, `Dragging`).
*   **`VisualNodeStyle`**: Controls individual layout styling and isolates `StyleBox` resources using deep memory duplication (`duplicate()`), avoiding editor thread lockups.
*   **`VisualNodeFactory`**: Instantiates logical containers cleanly before injecting them into the active graph viewport tree.
*   **`VisualConnectionValidator`**: Evaluates data-type matching rules dynamically across execution wires.
*   **`VisualNodeCatalog`**: Database module scanning and registering decoupled node script definitions.
*   **`VisualScriptInterpreter`**: Core standalone engine runner that reads structured `.gvs` connections at game runtime.
*   **`VisualScriptInstance`**: Native in-game tool node attached to any object to execute loop-ticks dynamically.
*   **`VisualNodeSlotRenderer`**: Handles the physical drawing of node rows and port distribution.
*   **`VisualNodeWidgetInjector`**: Dynamically injects interactive parameter boxes (`LineEdit`, `CheckButton`) into variable configurations.

## Key Features

*   **Zero Global Performance Overhead**: Thread lockups caused by hot-reloading shared resources are entirely eliminated.
*   **Uniform Selection Theme**: Nodes maintain a sharp, uniform gray color. Focuseable elements dynamically gain a vibrant border layout without dimming background canvases.
*   **Parametric Flow Lines**: Elastic cord curved connections are flattened into rigid, straight geometric lines with custom curve variables anchored at `0.0`.
*   **Native Tree Categories**: The popup panel implements a native `Tree` node with clean `>` toggle arrows that expand or filter sub-components instantly on a single left-click.
*   **Data-Driven Logic Nodes**: Modular node definitions use standard type evaluations to execute math operators (`+`, `-`, `*`, `/`), branch conditions (`If`), and deep engine calls like central physics impulses.

## Native Tech-Friendly Class Catalog

All structural blocks use simplified friendly naming conventions for seamless beginner onboard training:

*   **`Operators`**: `Plus (+)`, `Subtract (-)`, `Multiply (*)`, `Divide (/)`, and `Equal (==)`.
*   **`Conditionals`**: `Branch`, `And (&&)`, `Or (||)`, and `Not (!)` logical blocks.
*   **`Variables`**: `Text Value`, `Whole Number`, and `Decimal Number` exposing live input UI fields.
*   **`Constants`**: `Constant Bool` toggles for static binary verification.
*   **`Math`**: Graphic directional handlers supporting native `Vector2` and `Vector3` properties.
*   **`Movement`**: `Get Velocity`, `Set Velocity`, and `Move and Slide` designed to interface directly with `CharacterBody2D`.
*   **`Events`**: Continuous execution nodes mapping to frame triggers like `On Process` and keystroke checks like `Input Press`, `Input Axis`, and `Input Just Pressed`.

## Directory Structure

```text
res://addons/godot_visual_script/
├── plugin.cfg
├── main_plugin.gd
├── core/
│   ├── visual_port_types.gd
│   ├── node_definition.gd
│   ├── visual_node_catalog.gd
│   ├── visual_node_factory.gd
│   ├── visual_node_style.gd
│   ├── visual_signal_bridge.gd
│   ├── visual_script_interpreter.gd
│   ├── visual_script_instance.gd
│   ├── visual_node_slot_renderer.gd
│   ├── visual_node_widget_injector.gd
│   └── visual_connection_validator.gd
├── ui/
│   ├── visual_script_canvas.tscn
│   ├── visual_script_canvas.gd
│   ├── search_menu.tscn
│   └── search_menu.gd
└── nodes/
    ├── base_visual_node.tscn
    ├── base_visual_node.gd
    └── components/
        ├── node_class_plus.gd
        ├── node_class_subtract.gd
        ├── node_class_multiply.gd
        ├── node_class_divide.gd
        ├── node_class_equal.gd
        ├── node_class_if.gd
        ├── node_class_logical_and.gd
        ├── node_class_logical_or.gd
        ├── node_class_logical_not.gd
        ├── node_class_print.gd
        ├── node_class_text.gd
        ├── node_class_whole_number.gd
        ├── node_class_decimal_number.gd
        ├── node_class_constant_bool.gd
        ├── node_class_vector2.gd
        ├── node_class_vector3.gd
        ├── node_class_on_process.gd
        ├── node_class_input_press.gd
        ├── node_class_input_axis.gd
        ├── node_class_input_just_pressed.gd
        ├── node_class_get_velocity.gd
        ├── node_class_set_velocity.gd
        └── node_class_move_and_slide.gd
```

## Next Milestones

*   [x] Implement `VisualScriptInterpreter` for real-time engine runtime evaluation.
*   [x] Build an independent `Print` node to stream custom string outputs onto Godot's debug console output.
*   [x] Build a dynamic multi-tab layout system mirroring native scene management to open, rename, and delete `.gvs` files natively via Godot's FileSystem dock.
*   [ ] Enhance UI/UX layout and add drag-and-drop mouse actions from categories tree items directly into the graph canvas coordinates.
*   [ ] Write a comprehensive beginner-friendly documentation user manual inside the engine.
