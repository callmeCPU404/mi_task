
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';
import 'package:mi_task/screens/category_detail_screen.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';


class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  String _searchQuery = "";
  Priority? _filterPriority;
 

  late PageController _pageController;
  Timer? _timer;

   @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    // 🔹 Auto slide every 4s
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage =
            (_pageController.page?.round() ?? 0) + 1; 
        if (nextPage < 3) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }
@override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    // 🔹 Apply search + filter
    final filteredTasks = tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPriority =
          _filterPriority == null || task.priority == _filterPriority;
      return matchesSearch && matchesPriority;
    }).toList();

    // 🔹 Get recent 3 by priority
    final recentPriorityTasks = filteredTasks
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
    final topThree = recentPriorityTasks.take(3).toList();

    // 🔹 Group counts by progress
    final planningCount =
        tasks.where((t) => t.progress == Progress.planning).length;
    final inProcessCount =
        tasks.where((t) => t.progress == Progress.inProcess).length;
    final onHoldCount =
        tasks.where((t) => t.progress == Progress.onHold).length;
    final completeCount =
        tasks.where((t) => t.progress == Progress.complete).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Greeting
             // Greeting section
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Hello there 👋",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
      SizedBox(height: 4),
      Text(
        "Let me organize your tasks",
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic, 
          color: Colors.grey[600],
        ),
      ),
    ],
  ),
),


              SizedBox(width: 12),
              
              const SizedBox(height: 25),

// 🔹 Recent Priority Tasks
const Text("Recent Priority Tasks",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 12),

SizedBox(
  height: 190, // enough for card + dots
  child: Builder(
    builder: (context) {
      if (topThree.isEmpty) {
        return Column(
          children: [
         DottedBorder(
  options: RoundedRectDottedBorderOptions(
    color: Colors.grey,
    strokeWidth: 1,
    radius: const Radius.circular(12),
    dashPattern: [6, 4],
  ),
  child: Container(
    height: 140,
    width: double.infinity,
    alignment: Alignment.center,
    child: Text(
      "No priority tasks yet.\nThey will appear here.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.withOpacity(0.6),
        fontStyle: FontStyle.italic,
      ),
    ),
  ),
),
          ],
        );
      }

      return Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: topThree.length,
              itemBuilder: (context, index) {
                final task = topThree[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(task: task),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            "Priority: ${task.priority.name}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SmoothPageIndicator(
            controller: _pageController,
            count: topThree.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotColor: Colors.blue,
              dotColor: Colors.grey.shade400,
            ),
          ),
        ],
      );
    },
  ),
),


              // 🔹 Categories Section
              const Text("Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: [
                  _buildCategoryCard(
                    "Planning",
                    planningCount,
                    Icons.event_note,
                    Progress.planning,
                    Colors.blue,
                  ),
                  _buildCategoryCard(
                    "In Process",
                    inProcessCount,
                    Icons.work,
                    Progress.inProcess,
                    Colors.orange,
                  ),
                  _buildCategoryCard(
                    "On Hold",
                    onHoldCount,
                    Icons.pause_circle,
                    Progress.onHold,
                    Colors.purple,
                  ),
                  _buildCategoryCard(
                    "Completed",
                    completeCount,
                    Icons.check_circle,
                    Progress.complete,
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: "Add Task",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

   Widget _buildCategoryCard(
    String title, int count, IconData icon, Progress progress, Color color) {
  return Card(
    color: color.withOpacity(0.15), // faded background
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, size: 28, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text("$count tasks"),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(category: progress),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.remove_red_eye, size: 18, color: Colors.blue),
                    SizedBox(width: 4),
                    Text("View",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 14, 14, 14),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



}