import 'package:flutter/material.dart';
import 'api/api_services.dart'; // Import the API service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Fetch and Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchData() async {
    try {
      final fetchedData = await ApiService.fetchPosts();
      setState(() {
        data = fetchedData;
        filteredData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void filterData(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = data;
    } else {
      results = data
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredData = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      filterData(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Data with Search Filter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredData[index]['title']),
                        subtitle: Text(filteredData[index]['body']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
