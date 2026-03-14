int _counter = 0;

String generateId(String prefix) {
  final now = DateTime.now().microsecondsSinceEpoch;
  final count = _counter++;
  return '$prefix-$now-$count';
}
