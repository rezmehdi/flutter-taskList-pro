part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListSucess extends TaskListState {
  final List<TaskEntity> items;
  TaskListSucess(this.items);
}

class TaskListEmpty extends TaskListState {}

class TaskListError extends TaskListState {
  final String errorMessage;

  TaskListError(this.errorMessage);
}
