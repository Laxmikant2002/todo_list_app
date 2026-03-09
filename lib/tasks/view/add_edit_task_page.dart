import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/core/constants/app_colors.dart';
import '../bloc/task_bloc.dart';
import 'package:formz/formz.dart';
import '../view/validation/title_input.dart';
import '../model/task.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;
  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskBloc>().add(TaskFormInitialized(task: widget.task));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.status == TaskStatus.success) {
            Navigator.pop(context);
          } else if (state.status == TaskStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    controller: _titleController,
                    onChanged: (value) =>
                        context.read<TaskBloc>().add(TaskTitleChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      errorText:
                          state.titleInput.error == TitleValidationError.empty
                          ? 'Title is required'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    onChanged: (value) => context.read<TaskBloc>().add(
                      TaskDescriptionChanged(value),
                    ),
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: state.dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        context.read<TaskBloc>().add(TaskDueDateChanged(date));
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date (optional)',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.dueDate == null
                                ? 'Select date'
                                : '${state.dueDate!.day}/${state.dueDate!.month}/${state.dueDate!.year}',
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.status == TaskStatus.loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: state.formStatus == FormzStatus.valid
                          ? () {
                              if (isEditing) {
                                final updatedTask = widget.task!.copyWith(
                                  title: state.titleInput.value,
                                  description:
                                      state.descriptionInput.value.isNotEmpty
                                      ? state.descriptionInput.value
                                      : null,
                                  dueDate: state.dueDate,
                                );
                                context.read<TaskBloc>().add(
                                  TaskUpdateRequested(updatedTask),
                                );
                              } else {
                                context.read<TaskBloc>().add(
                                  const TaskSubmitted(),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(isEditing ? 'Update' : 'Create'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
