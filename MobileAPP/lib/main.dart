import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zjflooqiypnrqvcbfisy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpqZmxvb3FpeXBucnF2Y2JmaXN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgwMTk4MjYsImV4cCI6MjAzMzU5NTgyNn0.jQvsKl0aN8TCICavH0TT0U5j_cClEu7gMsiqJpzgG0E',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class FirstPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                image: AssetImage('images/logo.png'),
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Connectez-vous!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Entrer votre email et password',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Email TextField
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Entrez votre email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Entrez votre mot de passe',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Color(0xFF2E5014),
                ),
                onPressed: () => _login(context),
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('images/logo.png', height: 69),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tableau analytique'),
              Tab(text: 'Live'),
              Tab(text: 'Commandes'),
            ],
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(122, 107, 151, 90),
                ),
                child: Image.asset('images/logo.png', height: 69),
              ),
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Exporté les données'),
                onTap: () {},
              ),
              ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Profile'),
                  onTap: () {}),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Paramètres'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('À propos de nous'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Déconnexion'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AnalyticDashboard(),
            Live(),
            Container(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class AnalyticDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          DateSelector(),
          GraphCard(title: 'CO2', color: Colors.blue),
          GraphCard(title: 'Humidité', color: Colors.lightBlue),
          GraphCard(title: 'O2', color: Colors.lightBlue),
          GraphCard(title: 'Température', color: Colors.lightBlue),
        ],
      ),
    );
  }
}

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate = DateTime.now(); // Default date is today's date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000), // Adjust this to the earliest allowed date
      lastDate: DateTime(2100), // Adjust this to the latest allowed date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => _selectDate(context),
            child: Center(
              child: Text(
                '${selectedDate.toLocal()}'
                    .split(' ')[0], // Formats the date to YYYY-MM-DD
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}

class GraphCard extends StatelessWidget {
  final String title;
  final Color color;

  GraphCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Graph data will be here',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  // Valeurs des paramètres
  double co2Value = 800;
  double temperatureValue = 20;
  double humidityValue = 50;
  double o2Value = 21;

  // Détermine la couleur du cercle central en fonction des paramètres
  Color _getStatusColor() {
    if (temperatureValue < 0 || temperatureValue > 4) {
      return Colors.red;
    } else if (co2Value > 1000 || humidityValue > 900 || o2Value < 19) {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildParameterCard('CO2',
                      '${co2Value.toStringAsFixed(2)} ppm', 'images/co2.png'),
                ),
                Expanded(
                  child: _buildParameterCard(
                      'Temperature',
                      '${temperatureValue.toStringAsFixed(2)}°C',
                      'images/cold.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildParameterCard(
                      'Humidité',
                      '${humidityValue.toStringAsFixed(2)}%',
                      'images/humidity.png'),
                ),
                Expanded(
                  child: _buildParameterCard(
                      'O2', '${o2Value.toStringAsFixed(2)}%', 'images/o2.png'),
                ),
              ],
            ),
            SizedBox(height: 90),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/logo2.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width:
                            50, // Réduire la taille pour visibilité de l'image
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _buildStatusItem(Colors.green, 'État Normal'),
                SizedBox(height: 8),
                _buildStatusItem(Colors.orange, 'État Avertissement'),
                SizedBox(height: 8),
                _buildStatusItem(Colors.red, 'État Anormal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard(String title, String value, String assetPath) {
    return Card(
      elevation: 4,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(assetPath, width: 40, height: 40),
            SizedBox(height: 10),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(Color color, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
