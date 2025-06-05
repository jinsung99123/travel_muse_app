import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/sheet/edit_profile_sheet.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/profile.png'),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '홍길동',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('기타 정보', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.teal),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfileSheet()),
            );
          },
        ),
      ],
    );
  }
}
