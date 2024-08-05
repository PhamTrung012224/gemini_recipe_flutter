import 'package:equatable/equatable.dart';

class ThemeModeState extends Equatable {
  final bool isOnSwitch;
  const ThemeModeState({this.isOnSwitch = false});

  ThemeModeState copyWith({bool? isOnSwitch}) {
    return ThemeModeState(isOnSwitch: isOnSwitch ?? this.isOnSwitch);
  }

  @override
  List<Object?> get props => [isOnSwitch];
}
