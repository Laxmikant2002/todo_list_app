import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/task_repository.dart';
import '../model/task.dart';
import '../view/validation/title_input.dart';
import '../view/validation/description_input.dart';
import 'package:formz/formz.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  void _onFormInitialized(TaskFormInitialized event, Emitter<TaskState> emit) {
    final titleInput = TitleInput.dirty(event.task?.title ?? '');
    final descriptionInput = DescriptionInput.dirty(
      event.task?.description ?? '',
    );
    final dueDate = event.task?.dueDate;
    final formStatus = Formz.validate([titleInput, descriptionInput]);
    emit(
      state.copyWith(
        titleInput: titleInput,
        descriptionInput: descriptionInput,
        dueDate: dueDate,
        formStatus: formStatus,
        status: TaskStatus.initial,
        errorMessage: null,
      ),
    );
  }

  TaskBloc({required TaskRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TaskState()) {
    on<TaskLoadRequested>(_onLoadRequested);
    on<TaskFormInitialized>(_onFormInitialized);
    on<TaskTitleChanged>(_onTitleChanged);
    on<TaskDescriptionChanged>(_onDescriptionChanged);
    on<TaskDueDateChanged>(_onDueDateChanged);
    on<TaskSubmitted>(_onSubmitted);
    on<TaskUpdateRequested>(_onUpdateRequested);
    on<TaskDeleteRequested>(_onDeleteRequested);
    on<TaskToggleCompletionRequested>(_onToggleCompletionRequested);
  }

  final TaskRepository _taskRepository;
  StreamSubscription<List<Task>>? _tasksSubscription;

  Future<void> _onLoadRequested(
    TaskLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _taskRepository.fetchTasks();
      emit(state.copyWith(status: TaskStatus.success, tasks: tasks));
      _tasksSubscription?.cancel();
      _tasksSubscription = _taskRepository.tasksStream().listen((updatedTasks) {
        add(const TaskLoadRequested());
      });
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _onTitleChanged(TaskTitleChanged event, Emitter<TaskState> emit) {
    final titleInput = TitleInput.dirty(event.title);
    final formStatus = Formz.validate([titleInput, state.descriptionInput]);
    emit(state.copyWith(titleInput: titleInput, formStatus: formStatus));
  }

  void _onDescriptionChanged(
    TaskDescriptionChanged event,
    Emitter<TaskState> emit,
  ) {
    final descriptionInput = DescriptionInput.dirty(event.description);
    final formStatus = Formz.validate([state.titleInput, descriptionInput]);
    emit(
      state.copyWith(
        descriptionInput: descriptionInput,
        formStatus: formStatus,
      ),
    );
  }

  void _onDueDateChanged(TaskDueDateChanged event, Emitter<TaskState> emit) {
    emit(state.copyWith(dueDate: event.dueDate));
  }

  Future<void> _onSubmitted(
    TaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    if (state.formStatus != FormzStatus.valid) {
      emit(state.copyWith(errorMessage: 'Please fill all required fields.'));
      return;
    }
    emit(state.copyWith(status: TaskStatus.loading, errorMessage: null));
    try {
      await _taskRepository.addTask(
        Task(
          id: '',
          title: state.titleInput.value,
          description: state.descriptionInput.value.isNotEmpty
              ? state.descriptionInput.value
              : null,
          isCompleted: false,
          createdAt: DateTime.now(),
          dueDate: state.dueDate,
        ),
      );
      emit(state.copyWith(status: TaskStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTask(event.task);
      add(const TaskLoadRequested());
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.deleteTask(event.taskId);
      add(const TaskLoadRequested());
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onToggleCompletionRequested(
    TaskToggleCompletionRequested event,
    Emitter<TaskState> emit,
  ) async {
    final updatedTask = event.task.copyWith(
      isCompleted: !event.task.isCompleted,
    );
    add(TaskUpdateRequested(updatedTask));
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
