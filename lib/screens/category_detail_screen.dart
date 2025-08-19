// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mi_task/models/task_model.dart';
// import 'package:mi_task/providers/task_provider.dart';
// import 'package:mi_task/utils/colors.dart';
// import 'package:mi_task/widgets/task_card.dart';
// import 'task_detail_screen.dart';


// class CategoryDetailScreen extends ConsumerStatefulWidget {
//   final Progress category;

//   const CategoryDetailScreen({super.key, required this.category});

//   @override
//   ConsumerState<CategoryDetailScreen> createState() =>
//       _CategoryDetailScreenState();
// }

// class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final List<Priority> priorities = Priority.values;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: priorities.length, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tasks = ref.watch(taskProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category.name.toUpperCase()),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: TabBar(
//             controller: _tabController,
//             indicator: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               color: priorities[_tabController.index].color,
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.black,
//             indicatorSize: TabBarIndicatorSize.tab,
//             tabs: priorities.map((priority) {
//               return Tab(
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: priority.color, width: 1.5),
//                     borderRadius: BorderRadius.circular(25),
//                     color: _tabController.index == priorities.indexOf(priority)
//                         ? priority.color
//                         : Colors.transparent,
//                   ),
//                   child: Text(
//                     priority.name.toUpperCase(),
//                     style: TextStyle(
//                       color: _tabController.index == priorities.indexOf(priority)
//                           ? Colors.white
//                           : priority.color,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//             onTap: (index) {
//               setState(() {}); // rebuild to update tab styling
//             },
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: priorities.map((priority) {
//           final filtered = tasks
//               .where((t) =>
//                   t.progress == widget.category && t.priority == priority)
//               .toList();

//           if (filtered.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No tasks here.",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: filtered.length,
//             itemBuilder: (context, i) {
//               final task = filtered[i];
//               return TaskCard(
//                 task: task,
//                 onView: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => TaskDetailScreen(task: task),
//                   ),
//                 ),
//                 onDelete: () =>
//                     ref.read(taskProvider.notifier).deleteTask(task.id),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';
import 'package:mi_task/utils/colors.dart';
import 'package:mi_task/widgets/task_card.dart';
import 'task_detail_screen.dart';
class CategoryDetailScreen extends ConsumerStatefulWidget {
  final Progress category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Priority> priorities = Priority.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: priorities.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category.name.toLowerCase()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔹 Custom pill-like tabs BELOW the AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: priorities[_tabController.index].color, // active tab fill
              ),
              indicatorSize: TabBarIndicatorSize.tab, // 👈 fill entire tab
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: priorities.map((priority) {
                return Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: priority.color, width: 1.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    priority.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _tabController.index ==
                              priorities.indexOf(priority)
                          ? Colors.white
                          : priority.color,
                    ),
                  ),
                );
              }).toList(),
              onTap: (index) => setState(() {}),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: priorities.map((priority) {
                final filtered = tasks
                    .where((t) =>
                        t.progress == widget.category &&
                        t.priority == priority)
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "Your tasks will display here.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final task = filtered[i];
                    return TaskCard(
                      task: task,
                      onView: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      ),
                      onDelete: () =>
                          ref.read(taskProvider.notifier).deleteTask(task.id),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

