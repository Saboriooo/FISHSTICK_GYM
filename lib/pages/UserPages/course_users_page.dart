import 'package:fishstick_gym/models/token.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';

class CourseUsersPage extends StatelessWidget {
  final int courseId;
  final String courseName;

  const CourseUsersPage({super.key, required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE67E22),
                width: 2.0,
              ),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            ),
            title: Text(
              courseName,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: CourseService().getParticipantsForCourse(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay participantes en este curso'));
          } else {
            final participants = snapshot.data!;
            return ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final user = participants[index];
                return UserItem(user: user);
              },
            );
          }
        },
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  final User user;

  const UserItem({super.key, required this.user});

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool isPresent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE67E22),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.user.email ?? 'No email',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isPresent ? 'Presente' : 'Ausente',
                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Switch(
                value: isPresent,
                onChanged: (value) {
                  setState(() {
                    isPresent = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFFE67E22),
                inactiveThumbColor: const Color(0xFFE67E22),
                inactiveTrackColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
