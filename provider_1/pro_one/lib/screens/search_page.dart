import 'package:flutter/material.dart';
import 'package:pro_one/providers/student_provider.dart';
import 'package:pro_one/screens/detail_page.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                Provider.of<StudentProvider>(context, listen: false)
                    .searchStudents(query);
              },
              decoration: InputDecoration(
                hintText: 'Search Students...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, _) {
                if (studentProvider.filteredStudents.isNotEmpty) {
                  return ListView.builder(
                    itemCount: studentProvider.filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = studentProvider.filteredStudents[index];
                      // Build your list item UI here
                      return ListTile(
                        title: Text(student.name),
                        subtitle: Text(student.age),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentDetailsPage(student: student),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No students found.'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
