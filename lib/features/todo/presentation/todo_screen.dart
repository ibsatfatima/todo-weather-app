import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_weather_app/core/theme/app_colors.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../core/widgets/custom_text_field_widget.dart';
import '../../weather/presentation/weather_screen.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import 'widgets/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    context.read<TodoBloc>().add(TodoLoadRequested());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_buildTodoTab(), const WeatherScreen()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.seed.withOpacity(0.4),
        title: Text(
          'Dashboard',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          final inAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(position: inAnimation, child: child);
        },
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.checklist,), label: 'Todos'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud,), label: 'Weather'),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddTodo,
              child: Icon(CupertinoIcons.add),
            )
          : null,
    );
  }

  Widget _buildTodoTab() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodoLoadSuccess) {
          final todos = state.todos;
          if (todos.isEmpty) {
            return Center(
              child: Text(
                'No todos. Tap + to add task.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TodoBloc>().add(TodoLoadRequested());
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.0.h),
              itemCount: todos.length,
              separatorBuilder: (_, __) => SizedBox(height: 5.0.h),
              itemBuilder: (context, index) {
                final todoId = todos[index];
                return Hero(
                  tag: todoId.id,
                  child: Material(
                    child: TodoItemWidget(
                      todo: todoId,
                      onToggle: () => context.read<TodoBloc>().add(
                        TodoToggleRequested(todoId.id),
                      ),
                      onDelete: () => context.read<TodoBloc>().add(
                        TodoDeleteRequested(todoId.id),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is TodoFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _showAddTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFieldWidget(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                borderColor: AppColors.darkGrey,
                hintText: 'Task Title...',
                maxLines: 1,
              ),
              SizedBox(height: 10.h),
              CustomTextFieldWidget(
                controller: _descController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                borderColor: AppColors.darkGrey,
                hintText: 'Task Description...',
                maxLines: 1,
              ),
            ],
          ),
          actions: [
            CustomButtonWidget(
              height: 40.0.h,
              title: 'Add',
              onPressed: () {
                final title = _titleController.text.trim();
                final desc = _descController.text.trim();
                if (title.isEmpty) return;
                context.read<TodoBloc>().add(TodoAddRequested(title, desc));
                _titleController.clear();
                _descController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
