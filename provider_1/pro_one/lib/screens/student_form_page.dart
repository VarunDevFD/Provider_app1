import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';

class StudentFormPage extends StatelessWidget {
  final Student? student;
  final int? index;

  StudentFormPage({super.key, this.student, this.index});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _pickCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Provider.of<StudentProvider>(context, listen: false)
          .setImagePath(pickedFile.path);
    }
  }

  void _pickImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<StudentProvider>(context, listen: false)
          .setImagePath(pickedFile.path);
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        Provider.of<StudentProvider>(context, listen: false).imagePath !=
            null) {
      final newStudent = Student(
        id: student?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        age: _ageController.text,
        imagePath:
            Provider.of<StudentProvider>(context, listen: false).imagePath!,
      );
      if (student == null) {
        Provider.of<StudentProvider>(context, listen: false).addStudent(
          newStudent.name,
          newStudent.age,
          newStudent.imagePath,
        );
      } else {
        Provider.of<StudentProvider>(context, listen: false).updateStudent(
          index!,
          newStudent.name,
          newStudent.age,
          newStudent.imagePath,
        );
      }

      // ---Clear selected image path after submission---
      Provider.of<StudentProvider>(context, listen: false).clearSelectedImage();

      // ---Navigate back after submission---
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ---Initialize form fields if editing an existing student---
    if (student != null) {
      _nameController.text = student!.name;
      _ageController.text = student!.age;
      Provider.of<StudentProvider>(context, listen: false)
          .setImagePath(student!.imagePath);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(57, 255, 153, 0),
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Display selected image
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    return provider.imagePath == null
                        ? const CircleAvatar(
                            backgroundColor: Color.fromARGB(57, 255, 153, 0),
                            radius: 50,
                            child: Icon(Icons.person),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(57, 255, 153, 0),
                            radius: 100,
                            child: ClipOval(
                              child: Image.file(
                                File(provider.imagePath!),
                                fit: BoxFit.cover,
                                width: 190,
                                height: 190,
                              ),
                            ),
                          );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickCamera(context),
                      child: const Text('Pick Camera'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(context),
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  shadowColor: Colors.orange,
                  child: SizedBox(
                    height: 50,
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  shadowColor: Colors.orange,
                  child: SizedBox(
                    height: 50,
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Age',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: const ButtonStyle(),
                  onPressed: () => _submitForm(context),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
