import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: AppColors.seed.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r)
      ),
      child: Slidable(
          key: ValueKey(todo.id),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: AppColors.lightBackground,
                icon: CupertinoIcons.delete_solid,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
              title: Text(
                todo.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                  todo.description,
                style: Theme.of(context).textTheme.titleSmall
              ),
              trailing: Checkbox(
                  value: todo.isDone,
                onChanged: (_) => onToggle(),
                  activeColor: AppColors.lightBackground,
                checkColor: AppColors.darkBackground,
              ),
            // trailing: IconButton(
            //   icon: const Icon(Icons.delete_outline),
            //   onPressed: onDelete,
            // ),
          )
      ),
    );
    //   Dismissible(
    //   key: ValueKey(todo.id),
    //   background: Container(
    //     color: Colors.red,
    //     alignment: Alignment.centerLeft,
    //     padding: EdgeInsets.only(left: 16),
    //     child: const Icon(Icons.delete, color: Colors.white),
    //   ),
    //   direction: DismissDirection.startToEnd,
    //   onDismissed: (_) => onDelete(),
    //   child: ListTile(
    //     tileColor: Theme.of(context).cardColor,
    //     title: Text(
    //       todo.title,
    //       style: TextStyle(
    //         decoration: todo.isDone ? TextDecoration.lineThrough : null,
    //       ),
    //     ),
    //     subtitle: Text(todo.description),
    //     leading: Checkbox(value: todo.isDone, onChanged: (_) => onToggle()),
    //     trailing: IconButton(
    //       icon: const Icon(Icons.delete_outline),
    //       onPressed: onDelete,
    //     ),
    //   ),
    // );
  }
}
