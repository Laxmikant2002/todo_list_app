part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

final class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.errorMessage,
    this.titleInput = const TitleInput.pure(),
    this.descriptionInput = const DescriptionInput.pure(),
    this.dueDate,
    this.formStatus = FormzStatus.pure,
  });

  final TaskStatus status;
  final List<Task> tasks;
  final String? errorMessage;
  final TitleInput titleInput;
  final DescriptionInput descriptionInput;
  final DateTime? dueDate;
  final FormzStatus formStatus;

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    String? errorMessage,
    TitleInput? titleInput,
    DescriptionInput? descriptionInput,
    DateTime? dueDate,
    FormzStatus? formStatus,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
      titleInput: titleInput ?? this.titleInput,
      descriptionInput: descriptionInput ?? this.descriptionInput,
      dueDate: dueDate ?? this.dueDate,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    errorMessage,
    titleInput,
    descriptionInput,
    dueDate,
    formStatus,
  ];
}
