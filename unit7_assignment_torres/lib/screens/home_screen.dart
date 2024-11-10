import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Create a stateful widget for HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future function to fetch data
  late Future<List<dynamic>> _apiData;

  @override
  void initState() {
    super.initState();
    _apiData = fetchAPIData();
  }

  // Fetch data from the API
  Future<List<dynamic>> fetchAPIData() async {
    final response = await http.get(
      Uri.parse('https://hp-api.onrender.com/api/characters/staff'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ExpandedTileList.builder(
              itemCount: data.length,
              itemBuilder: (context, index, controller) {
                return ExpandedTile(
                  controller: controller,
                  title: Text(data[index]['name'] ?? 'No Name'),
                  leading: data[index]['image'] != null
                      ? Image.network(
                          data[index]['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data[index]['house'] ?? 'No Description'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}


