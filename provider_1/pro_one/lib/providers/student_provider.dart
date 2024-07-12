import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../models/student.dart';

class StudentProvider with ChangeNotifier {
  final Box<Student> _studentBox;
  String? _selectedImagePath;
  List<Student> _filteredStudents = [];
  String _searchQuery = '';

  StudentProvider() : _studentBox = Hive.box<Student>('students');

  List<Student> get students => _studentBox.values.toList();
  List<Student> get filteredStudents => _filteredStudents;
  String? get imagePath => _selectedImagePath;
  String get searchQuery => _searchQuery;

  void setImagePath(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void addStudent(String name, String age, String imagePath) {
    _studentBox.add(Student(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      age: age,
      imagePath: imagePath,
    ));
    notifyListeners();
  }

  void updateStudent(int index, String name, String age, String imagePath) {
    _studentBox.putAt(
        index,
        Student(
          id: students[index].id,
          name: name,
          age: age,
          imagePath: imagePath,
        ));
    notifyListeners();
  }

  void deleteStudent(int index) {
    _studentBox.deleteAt(index);
    notifyListeners();
  }

  void searchStudents(String query) {
    if (query.isEmpty) {
      _filteredStudents = students;
    } else {
      _filteredStudents = students.where((student) {
        return student.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      _selectedImagePath = pickedImage.path;
      notifyListeners();
    }
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
    notifyListeners();
  }
}
