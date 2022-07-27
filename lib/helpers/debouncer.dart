import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

// <T>    Generic because it can emmit different objects
class Debouncer<T> {

  Debouncer({ 
    required this.duration,     // Time to spend, previous to emit a value
    this.onValue                // Function to launch whenever we get a value
  });

  final Duration duration;

  void Function(T value)? onValue;

  T? _value;
  Timer? _timer;
  
  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }  
}