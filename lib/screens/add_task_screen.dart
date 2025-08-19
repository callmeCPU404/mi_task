import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  Priority _selectedPriority = Priority.medium;
  Progress _selectedProgress = Progress.planning;

  final List<TextEditingController> _subTaskControllers = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (var controller in _subTaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSubTaskField() {
    setState(() {
      _subTaskControllers.add(TextEditingController());
    });
  }

  void _removeSubTaskField(int index) {
    setState(() {
      _subTaskControllers.removeAt(index);
    });
  }

  void _saveTask() {
  if (_formKey.currentState!.validate()) {
    final subTasks = _subTaskControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .map((controller) => SubTask(title: controller.text.trim()))
        .toList();

    ref.read(taskProvider.notifier).addTask(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          priority: _selectedPriority,
          progress: _selectedProgress,
          subTasks: subTasks,
        );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task created successfully "),
        backgroundColor: Colors.green,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: const Text("Add Task"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // 🔹 Title Field with live feedback
                ValueListenableBuilder(
                  valueListenable: _titleController,
                  builder: (context, TextEditingValue value, _) {
                    final length = value.text.trim().length;
                    final isValid = length >= 5;
                    return TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: const OutlineInputBorder(),
                        helperText: isValid
                            ? "Looks good "
                            : "At least 5 characters required",
                        helperStyle: TextStyle(
                          color: isValid ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 🔹 Description Field with live feedback
                ValueListenableBuilder(
                  valueListenable: _descController,
                  builder: (context, TextEditingValue value, _) {
                    final length = value.text.trim().length;
                    final isValid = length >= 10;
                    return TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: const OutlineInputBorder(),
                        helperText: isValid
                            ? "Looks good "
                            : "At least 10 characters required",
                        helperStyle: TextStyle(
                          color: isValid ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Priority Dropdown
                DropdownButtonFormField<Priority>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(),
                  ),
                  items: Priority.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.name.toLowerCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPriority = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Progress Dropdown
                DropdownButtonFormField<Progress>(
                  value: _selectedProgress,
                  decoration: const InputDecoration(
                    labelText: "Progress",
                    border: OutlineInputBorder(),
                  ),
                  items: Progress.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedProgress = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Subtasks Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Subtasks",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: _addSubTaskField,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(_subTaskControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _subTaskControllers[index],
                              decoration: const InputDecoration(
                                hintText: "Subtask",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeSubTaskField(index),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: _saveTask,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("Save Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
