// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mi_task/screens/onboarding.dart';

// void main() {
//   runApp(
//     const ProviderScope( // Required by Riverpod
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Task Manager',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const OnboardingScreen(), // First screen
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_model.dart';
import 'screens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(ProgressAdapter());
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(TaskAdapter());

  // Open a box for tasks
  await Hive.openBox<Task>('tasksBox');

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingScreen(),
    );
  }
}
