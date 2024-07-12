import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_one/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;
  final int? index;

  const StudentFormPage({super.key, this.student, this.index});

  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _ageController.text = widget.student!.age;
      Provider.of<StudentProvider>(context, listen: false)
          .setImagePath(widget.student!.imagePath);
    } else {
      // Clear image path if adding a new student
      Provider.of<StudentProvider>(context, listen: false).clearSelectedImage();
    }
  }

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
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        age: _ageController.text,
        imagePath:
            Provider.of<StudentProvider>(context, listen: false).imagePath!,
      );
      if (widget.student == null) {
        Provider.of<StudentProvider>(context, listen: false).addStudent(
          newStudent.name,
          newStudent.age,
          newStudent.imagePath,
        );
      } else {
        Provider.of<StudentProvider>(context, listen: false).updateStudent(
          widget.index!,
          newStudent.name,
          newStudent.age,
          newStudent.imagePath,
        );
      }

      // Clear selected image path after submission
      Provider.of<StudentProvider>(context, listen: false).clearSelectedImage();

      // Navigate back after submission
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.orange2,
        title: Text(
          widget.student == null ? 'Add Student' : 'Edit Student',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 218, 96, 96)
                : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 218, 96, 96)
                : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                        ? CircleAvatar(
                            backgroundColor: themeProvider.orange2,
                            radius: 50,
                            child: const Icon(Icons.person),
                          )
                        : CircleAvatar(
                            backgroundColor: themeProvider.primaryColor,
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 218, 96, 96),
                        backgroundColor: themeProvider.isDarkMode
                            ? themeProvider.orange2
                            : Colors.white,
                      ),
                      child: const Text('Pick Camera'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 218, 96, 96),
                        backgroundColor: themeProvider.isDarkMode
                            ? themeProvider.orange2
                            : Colors.white,
                      ),
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  shadowColor: themeProvider.orange,
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
                  shadowColor: themeProvider.orange,
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 218, 96, 96),
                    backgroundColor: themeProvider.isDarkMode
                        ? themeProvider.orange2
                        : Colors.white,
                  ),
                  onPressed: () => _submitForm(context),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
