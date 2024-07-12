import 'dart:io';

import 'package:flutter/material.dart';
import '../models/student.dart'; // Adjust the import path based on your project structure

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  StudentDetailsPage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.file(
                    File(student.imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Text(
              'Name: ${student.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Age: ${student.age}'),
            SizedBox(height: 8),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
