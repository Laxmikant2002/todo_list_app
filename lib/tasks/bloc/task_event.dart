part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class TaskLoadRequested extends TaskEvent {
  const TaskLoadRequested();
}

final class TaskTitleChanged extends TaskEvent {
  final String title;
  const TaskTitleChanged(this.title);
  @override
  List<Object> get props => [title];
}

final class TaskDescriptionChanged extends TaskEvent {
  final String description;
  const TaskDescriptionChanged(this.description);
  @override
  List<Object> get props => [description];
}

final class TaskDueDateChanged extends TaskEvent {
  final DateTime? dueDate;
  const TaskDueDateChanged(this.dueDate);
  @override
  List<Object?> get props => [dueDate];
}

final class TaskSubmitted extends TaskEvent {
  const TaskSubmitted();
}

final class TaskUpdateRequested extends TaskEvent {
  final Task task;
  const TaskUpdateRequested(this.task);
  @override
  List<Object> get props => [task];
}

final class TaskDeleteRequested extends TaskEvent {
  final String taskId;
  const TaskDeleteRequested(this.taskId);
  @override
  List<Object> get props => [taskId];
}

final class TaskFormInitialized extends TaskEvent {
  final Task? task; // null means new task
  const TaskFormInitialized({this.task});
  @override
  List<Object?> get props => [task];
}

final class TaskToggleCompletionRequested extends TaskEvent {
  final Task task;
  const TaskToggleCompletionRequested(this.task);
  @override
  List<Object> get props => [task];
}
