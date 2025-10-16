import 'package:flutter/material.dart';

class InstructorDashboard extends StatelessWidget {
  const InstructorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Instructor Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(Icons.upload_file, "Upload Tasks", Colors.blueAccent),
          _buildCard(Icons.assignment_turned_in, "View Submissions", Colors.teal),
          _buildCard(Icons.people_alt, "Track Students", Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(title,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) => Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Center(
                child: Text('Instructor Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false),
            ),
          ],
        ),
      );
}
