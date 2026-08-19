# Godot Visual Script

A high-performance, data-driven, and class-componentized visual scripting system designed natively for **Godot Engine 4.x**. Built from scratch using structured GDScript architecture and finite state machines, eliminating the rigidity of flat resource frameworks.

## Architecture & Modular Components

The plugin isolates responsibilities into strict single-purpose modules to guarantee microsecond execution times and clean memory cycle lifecycles:

*   **`VisualScriptCanvas`**: Orchestrator that connects the interface without managing logic data layers.
*   **`VisualNodeStateMachine`**: FSM governing context visual nodes (`Idle`, `Selected`, `Dragging`).
*   **`VisualNodeStyle`**: Controls individual layout styling and isolates `StyleBox` resources using deep memory duplication (`duplicate()`), avoiding editor thread lockups.
*   **`VisualNodeFactory`**: Instantiates logical containers cleanly before injecting them into the active graph viewport tree.
*   **`VisualConnectionValidator`**: Evaluates data-type matching rules dynamically across execution wires.
*   **`VisualNodeCatalog`**: Database module scanning and registering decoupled node script definitions.

## Key Features

*   **Zero Global Performance Overhead**: Thread lockups caused by hot-reloading shared resources are entirely eliminated.
*   **Uniform Selection Theme**: Nodes maintain a sharp, uniform gray color. Focuseable elements dynamically gain a vibrant border layout without dimming background canvases.
*   **Parametric Flow Lines**: Elastic cord curved connections are flattened into rigid, straight geometric lines with custom curve variables anchored at `0.0`.
*   **Native Tree Categories**: The popup panel implements a native `Tree` node with clean `>` toggle arrows that expand or filter sub-components instantly on a single left-click.
*   **Data-Driven Logic Nodes**: Modular node definitions use standard type evaluations to execute math operators (`+`, `==`), branch conditions (`If`), and deep engine calls like central physics impulses.

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
        ├── node_class_equal.gd
        ├── node_class_if.gd
        ├── node_class_impulse.gd
        ├── node_class_print.gd
        ├── node_class_text.gd
        ├── node_class_whole_number.gd
        ├── node_class_decimal_number.gd
        ├── node_class_on_process.gd
        └── node_class_input_press.gd
```

## Next Milestones

*   [x] Implement `VisualScriptInterpreter` for real-time engine runtime evaluation.
*   [x] Build an independent `Print` node to stream custom string outputs onto Godot's debug console output.
*   [ ] Build a dynamic multi-tab layout system mirroring native scene management to open, rename, and delete `.gvs` files natively via Godot's FileSystem dock.
*   [ ] Add drag-and-drop mouse actions from categories tree items directly into the graph canvas coordinates.
