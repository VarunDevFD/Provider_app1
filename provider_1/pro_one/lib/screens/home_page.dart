import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import 'student_form_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(57, 255, 153, 0),
        title: const Text('Students'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, index) {
              final student = provider.students[index];
              return ListTile(
                leading: Image.file(File(student.imagePath)),
                title: Text(student.name),
                subtitle: Text(student.age),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => provider.deleteStudent(index),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentFormPage(
                      student: student,
                      index: index,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_4_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentFormPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
