part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();
}

final class HomeScreenInitial extends HomeScreenState {
  @override
  List<Object> get props => [];
}
