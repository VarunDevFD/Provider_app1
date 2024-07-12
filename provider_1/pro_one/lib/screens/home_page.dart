import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pro_one/models/student.dart';
import 'package:pro_one/screens/detail_page.dart';
import 'package:pro_one/screens/search_page.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/theme_provider.dart';
import 'student_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final studentProvider = Provider.of<StudentProvider>(context);

    void navigateToSearchPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    }

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.orange2,
        title: Text(
          'Students',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 218, 96, 96)
                : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: navigateToSearchPage,
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          List<Student> studentsToShow = provider.students;

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 3 / 4,
            ),
            itemCount: studentsToShow.length,
            itemBuilder: (context, index) {
              final student = studentsToShow[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage(
                      student: student,
                    ),
                  ),
                ),
                child: Card(
                  color: themeProvider.orange2,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Name: ',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: themeProvider.isDarkMode
                                      ? const Color.fromARGB(255, 218, 96, 96)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: student.name,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Age: ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: themeProvider.isDarkMode
                                      ? const Color.fromARGB(255, 218, 96, 96)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: student.age,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentFormPage(
                                    student: student,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            color: themeProvider.isDarkMode
                                ? const Color.fromARGB(255, 218, 96, 96)
                                : Colors.black,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text(
                                        "Are you sure you want to delete this student?"),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          provider.deleteStudent(index);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            color: const Color.fromARGB(186, 236, 32, 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormPage()),
          );
        },
        backgroundColor: themeProvider.orange2,
        child: Icon(
          Icons.person_4_rounded,
          size: 30,
          color: themeProvider.isDarkMode
              ? const Color.fromARGB(255, 218, 96, 96)
              : themeProvider.secondaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
