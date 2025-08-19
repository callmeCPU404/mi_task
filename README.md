## MiTask — Flutter Task Manager

MiTask is a lightweight, offline-first task manager built with Flutter. It helps you plan, track, and complete tasks with priorities, progress categories, and subtasks. Data is stored locally using Hive, and app state is managed with Riverpod for a responsive and maintainable architecture.

### Key Features
- **Onboarding**: Friendly, image-driven intro with Next/Get Started flow.
- **Task CRUD**: Create tasks with title, description, priority, progress, and subtasks.
- **Priorities**: High, Medium, Low — color-coded throughout the UI.
- **Progress Categories**: Planning, In Process, On Hold, Completed — browse tasks by category.
- **Subtasks**: Checklist inside each task with live toggle and strike-through on completion.
- **Local Persistence**: Offline storage via Hive with generated type adapters.
- **State Management**: Riverpod `StateNotifier` for clear, testable updates and UI reactivity.

### Tech Stack
- **Flutter** (Material)
- **Riverpod** (`flutter_riverpod`) for state management
- **Hive** and **hive_flutter** for local storage
- **build_runner** and **hive_generator** for type adapters
- **smooth_page_indicator** for onboarding and quotes carousel
- **dotted_border** (available for UI accents)

---

## App Structure

```
lib/
  main.dart                     # App entry: Hive init, adapter registration, box open, ProviderScope
  models/
    task_model.dart             # Hive models: Priority, Progress, SubTask, Task (+ copyWith)
    task_model.g.dart           # Generated Hive type adapters
  providers/
    task_provider.dart          # TaskNotifier (add/update/delete/toggle/progress) + persistence
  screens/
    onboarding.dart             # 3-step onboarding → Homescreen
    homescreen.dart             # Greeting, quotes carousel, categories grid, FAB to add task
    add_task_screen.dart        # Create task (live input feedback, dropdowns, subtasks)
    category_detail_screen.dart # Filter by progress + priority tabs, list with view/delete
    task_detail_screen.dart     # View task, change progress, toggle subtasks
  utils/
    colors.dart                 # Priority → Color extension
  widgets/
    custom_button.dart          # Reusable filled button
    task_card.dart              # Task list item with priority badge, progress, view/delete
assets/
  achieve.png, organised.png, smart.png  # Onboarding illustrations
```

---

## Data Model

- **Priority**: `high`, `medium`, `low` (Hive `typeId: 0`)
- **Progress**: `planning`, `inProcess`, `onHold`, `complete` (Hive `typeId: 1`)
- **SubTask**: `{ title: String, isDone: bool }` (Hive `typeId: 2`)
- **Task** (Hive `typeId: 3`):
  - `id: String` (UUID)
  - `title: String`
  - `description: String`
  - `priority: Priority` (default: `medium`)
  - `progress: Progress` (default: `planning`)
  - `subTasks: List<SubTask>` (default: empty)
  - `createdAt: DateTime` (auto-assigned)

All models are Hive-annotated and include `copyWith` helpers for immutable updates.

---

## State Management & Persistence

- `TaskNotifier extends StateNotifier<List<Task>>`
  - `addTask`, `updateTask`, `deleteTask`, `toggleSubTask`, `updateProgress`
  - Persists after every mutation via a private `_saveToHive()`
- `taskProvider` exposes the task list for UI consumption.
- Hive box name: `tasksBox`
- Adapter registration and box opening occurs in `main.dart`:
  - `PriorityAdapter`, `ProgressAdapter`, `SubTaskAdapter`, `TaskAdapter`
  - `await Hive.openBox<Task>('tasksBox')`

---

## Getting Started

### Prerequisites
- Flutter SDK installed and configured
- A recent Dart SDK (project targets Dart `^3.7.2`)
- Platform tooling (Android Studio/Xcode) if running on mobile

### Install dependencies
```bash
flutter pub get
```

### Generate/refresh Hive adapters (only needed if you change model annotations)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run the app
```bash
flutter run
```

### Choose a device (examples)
```bash
flutter run -d chrome     # Web
flutter run -d windows    # Windows desktop
flutter run -d macos      # macOS desktop
flutter run -d ios        # iOS simulator/device
flutter run -d android    # Android emulator/device
```

### Build for release (examples)
```bash
flutter build apk --release
flutter build ios --release
flutter build web
```

---

## How to Use
- **Onboard**: Swipe through the intro and tap Get Started.
- **Add a Task**: Tap the FAB on the home screen. Provide title, description, pick priority/progress, add optional subtasks, then Save.
- **Browse by Category**: Tap a category card (Planning, In Process, On Hold, Completed). Use the tabs to filter by priority.
- **View & Update**: Open a task to change its progress, and check subtasks on/off.
- **Delete**: From the category list, tap the trash icon on a task card.

---

## Notable UI Details
- Greeting with a rotating quotes carousel (auto-advances every 4s) using `PageView` + `SmoothPageIndicator`.
- Category cards show task counts per progress state.
- Priority badges and AppBar colors reflect High/Medium/Low.
- Input fields show lightweight live helper feedback in the Add Task screen.

---

## Troubleshooting
- **Adapter not found / Type not registered**
  - Ensure `part 'task_model.g.dart';` exists and imports are correct in `task_model.dart`.
  - Ensure adapters are registered in `main.dart` before opening or using the box.
  - If you changed models or typeIds, rerun:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
- **TypeId conflicts**
  - Keep `typeId`s stable and unique: Priority=0, Progress=1, SubTask=2, Task=3.
- **Box not open**
  - `Hive.openBox<Task>('tasksBox')` must complete before the provider is used; this is done in `main.dart` prior to `runApp`.
- **Data lost unexpectedly**
  - `TaskNotifier` currently clears and re-writes the box on each save to keep it consistent. If you need large datasets, consider key-based incremental writes for performance.

---

## Scripts & Testing
- Run all tests:
```bash
flutter test
```

---

## Acknowledgements
- `flutter_riverpod`
- `hive` / `hive_flutter` / `hive_generator`
- `build_runner`
- `smooth_page_indicator`
- `dotted_border`

---

## License
No license file was provided in this repository. Add one (e.g., MIT) if you plan to distribute.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
