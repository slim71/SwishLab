class DropdownController<T> {
  T? value;
  void Function()? _listener;

  DropdownController({this.value});

  /// Internal use: attach a listener to update the widget
  void addListener(void Function() listener) {
    _listener = listener;
  }

  /// Call this to notify the widget that value changed
  void notify() {
    _listener?.call();
  }

  /// Change value programmatically
  void setValue(T? newValue) {
    value = newValue;
    notify();
  }
}
