import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class LocalizedText extends Equatable {
  const LocalizedText({required this.ar, required this.en});
  const LocalizedText.same(String value) : ar = value, en = value;

  final String ar;
  final String en;

  String resolve(String languageCode) {
    final primary = languageCode == 'ar' ? ar : en;
    final fallback = languageCode == 'ar' ? en : ar;
    return primary.isNotEmpty ? primary : fallback;
  }

  @override
  List<Object?> get props => [ar, en];
}
