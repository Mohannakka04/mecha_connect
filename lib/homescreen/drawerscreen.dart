import 'package:flutter/material.dart';
import 'package:mecha_connect/Starting_screen/Login.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        children: [
          Row(
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'User',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Student in THUB',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Divider(height: 2, thickness: 1),
                ],
              ),
            ],
          ),

          _buildInfoTile(Icons.location_on, 'Village', 'Andhra Pradesh'),
          _buildInfoTile(Icons.history, 'History', '1 year in service'),
          _buildInfoTile(Icons.cake, 'Date of Birth', '2 MAY 2005'),
          _buildInfoTile(Icons.phone_android, 'Phone Number', '+91 8341178134'),
          _buildInfoTile(Icons.person_outline, 'Age', '20'),
          _buildInfoTile(Icons.work_outline, 'Profession', 'TRAINEE'),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context,MaterialPageRoute(builder: (context)=>UserLoginScreen())); // Optional: closes drawer
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.blueGrey.shade200),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}