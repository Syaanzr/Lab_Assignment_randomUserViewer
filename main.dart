import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('! WELCOME !', style: TextStyle(fontSize: 50, color: const Color.fromARGB(221, 234, 234, 78))),
          Text('RANDOM USER APP', style: TextStyle(fontSize: 24, color: Colors.black87)),
          ], 
      )),
    );
  }
}

// Main Page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          user = data['results'][0];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load user data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random User Viewer",
        style: TextStyle(
          color: const Color.fromARGB(255, 3, 18, 177),
        ),
        )
        
        ),
        backgroundColor: Colors.cyanAccent,
      body: isLoading
          ? Center(
            child: CircularProgressIndicator())
          : error != null
              ? Center(
                child: Text(error!))
              : userWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUser,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget userWidget() {
    final name = user!['name'];
    final picture = user!['picture'];
    final email = user!['email'];

    return Center(
      child:Padding(
        padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60, 
            backgroundImage: NetworkImage(picture['large'])),
          SizedBox(height: 40),
          Text(
            '${name['title']} ${name['first']} ${name['last']}', 
            style: TextStyle(fontSize: 30)
            ),
          SizedBox(height: 10),
          Text(
            email
            ),

          SizedBox(
            height: 20),
          ElevatedButton(
            onPressed: fetchUser,
            child: Text("Fetch New User"),
          )
        ],
      ),
    ),
    );
  }
}
