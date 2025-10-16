import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, String>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('users');
    if (data != null) {
      users = List<Map<String, String>>.from(json.decode(data));
    } else {
      users = [
        {"name": "Ali", "role": "Student"},
        {"name": "Sara", "role": "Instructor"},
        {"name": "Ahmed", "role": "Admin"},
      ];
      await _saveUsers();
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', json.encode(users));
  }

  /// Opens a dialog to add or edit a user.
  /// Uses a Form with validation so empty names are not allowed and show an error.
  void _addOrEditUser({Map<String, String>? existingUser, int? index}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: existingUser?['name'] ?? '');
    String selectedRole = existingUser?['role'] ?? 'Student';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Use StatefulBuilder to update dialog-local state (e.g., selectedRole)
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title:
                Text(existingUser == null ? "Add User" : "Edit User"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name field with validator -> shows inline error if empty
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Role dropdown
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Admin", child: Text("Admin")),
                      DropdownMenuItem(value: "Instructor", child: Text("Instructor")),
                      DropdownMenuItem(value: "Student", child: Text("Student")),
                    ],
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedRole = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  // Validate form and only proceed if valid
                  if (formKey.currentState!.validate()) {
                    final name = nameController.text.trim();
                    if (existingUser != null && index != null) {
                      // Update existing
                      setState(() {
                        users[index] = {"name": name, "role": selectedRole};
                      });
                    } else {
                      // Add new
                      setState(() {
                        users.add({"name": name, "role": selectedRole});
                      });
                    }
                    await _saveUsers();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // If invalid, trigger UI update to show validation messages
                    setState(() {});
                  }
                },
                child: Text(existingUser == null ? "Add" : "Update"),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Are you sure you want to delete ${users[index]['name']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() => users.removeAt(index));
              await _saveUsers();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Admin Dashboard"),
            const SizedBox(width: 10),
            // badge for total users
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                users.length.toString(),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No users available."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      color: Colors.redAccent,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: Text(
                          user["name"]!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          user["role"]!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _addOrEditUser(existingUser: user, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _deleteUser(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => _addOrEditUser(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) => Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Center(
                child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            ),
          ],
        ),
      );
}
