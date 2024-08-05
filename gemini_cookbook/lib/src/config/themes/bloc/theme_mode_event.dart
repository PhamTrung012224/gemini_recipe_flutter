import 'package:equatable/equatable.dart';

abstract class ThemeModeEvent extends Equatable {
  const ThemeModeEvent();

  @override
  List<Object?> get props => [];
}

class SwitchModeEvent extends ThemeModeEvent {}
