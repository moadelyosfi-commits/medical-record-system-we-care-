import 'package:uuid/uuid.dart';

abstract interface class AppClock {
  DateTime nowUtc();
  Duration get utcOffset;
}

final class SystemClock implements AppClock {
  const SystemClock();
  @override
  DateTime nowUtc() => DateTime.now().toUtc();
  @override
  Duration get utcOffset => DateTime.now().timeZoneOffset;
}

final class FixedClock implements AppClock {
  FixedClock(this._now, {this.utcOffset = const Duration(hours: 2)})
    : assert(_now.isUtc);
  DateTime _now;
  @override
  final Duration utcOffset;
  @override
  DateTime nowUtc() => _now;
  void advance(Duration d) => _now = _now.add(d);
}

abstract interface class IdGenerator {
  String newId();
}

final class UuidV7Generator implements IdGenerator {
  UuidV7Generator() : _uuid = const Uuid();
  final Uuid _uuid;
  @override
  String newId() => _uuid.v7();
}

final class SequentialIdGenerator implements IdGenerator {
  int _n = 0;
  @override
  String newId() => 'id-${++_n}';
}
