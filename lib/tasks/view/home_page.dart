import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/core/constants/app_colors.dart';
import '../bloc/task_bloc.dart';
import '../repository/task_repository.dart';
import '../../auth/repository/auth_repository.dart';
import '../view/widgets/task_tile.dart';
import 'add_edit_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: RepositoryProvider.of<TaskRepository>(context),
      )..add(const TaskLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out
              await RepositoryProvider.of<AuthRepository>(context).signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.status == TaskStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a new task',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskTile(
                task: task,
                onToggle: () {
                  context.read<TaskBloc>().add(
                    TaskToggleCompletionRequested(task),
                  );
                },
                onDelete: () {
                  context.read<TaskBloc>().add(TaskDeleteRequested(task.id));
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditTaskPage(task: task),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskPage()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
