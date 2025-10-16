import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final List<Map<String, dynamic>> tasks = [
    {"title": "Task 1: Setup Flutter", "desc": "Install SDK & run first app", "done": false},
    {"title": "Task 2: Learn Widgets", "desc": "Understand Scaffold, Column, Row", "done": false},
    {"title": "Task 3: UI Practice", "desc": "Design a basic dashboard", "done": true},
    {"title": "Task 4: Navigation", "desc": "Use Navigator & Routes", "done": false},
    {"title": "Task 5: State Management", "desc": "Learn setState basics", "done": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: Icon(
                  task["done"] ? Icons.check_circle : Icons.hourglass_empty,
                  color: task["done"] ? Colors.green : Colors.orange,
                  size: 30,
                ),
                title: Text(
                  task["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(task["desc"]),
                trailing: Checkbox(
                  value: task["done"],
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      task["done"] = val!;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) => Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text(
                  'Student Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              ),
            ),
          ],
        ),
      );
}
