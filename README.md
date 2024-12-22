# godot-camera-transition
A camera transition util for Godot that allows you to easily transition between two cameras with no additional setup required.

## Example
CameraTransitions can be used in a single line as shown here:
```
CameraTransition.new(self, next_cam, 1.0)
```
You can modify the duration, ease type, and transition type.
You can also run another new camera transition before the previous one finishes with no issues.
