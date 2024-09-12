import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
class ExportDataPage extends StatefulWidget {
  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  String selectedMonth = 'Janvier';
  int selectedYear = DateTime.now().year;

  final List<String> months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Couleur du thème
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec le logo
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'images/logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Exporter vos données',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Carte pour le menu déroulant
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedMonth,
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value ?? months.first;
                    });
                  },
                  items: months.map((month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Sélectionnez un mois',
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Carte pour le champ de saisie de l'année
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Entrez l\'année',
                    icon: Icon(Icons.calendar_today),
                  ),
                  onChanged: (value) {
                    setState(() {
                      final intValue = int.tryParse(value);
                      if (intValue != null) {
                        selectedYear = intValue;
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bouton d'exportation
            ElevatedButton(
              onPressed: () {
                exportData(selectedMonth, selectedYear);
              },
              child: Text(
                'Exporter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, // Texte en gras
                      color: Colors.black, // Couleur du texte
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 18, 100, 21), // Couleur du bouton
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> exportData(String month, int year) async {
    try {
      // Logique pour exporter les données en fonction du mois et de l'année choisis
      print('Exporter les données pour $month $year');
      // Ajoute ici une logique d'exportation réelle, par exemple avec une requête HTTP
      // final response = await yourExportFunction(month, year);
      // if (response.success) {
      //   // Données exportées avec succès
      // } else {
      //   // Affiche une erreur à l'utilisateur
      // }
    } catch (e) {
      print('Erreur lors de l\'exportation des données : $e');
    }
  }
}

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
              Tab(text: 'Analytique'),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportDataPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text('Profile'),
                onTap: () {},
              ),
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
            Commande(), // Remplace ce Container par le widget souhaité pour "Commandes"
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
          GraphCard(
            title: 'CO2',
            color: Colors.blue,
            chartData: _getChartData([30, 40, 50, 60, 70, 80, 90]),
          ),
          GraphCard(
            title: 'Humidité',
            color: Colors.lightBlue,
            chartData: _getChartData([60, 55, 70, 65, 80, 75, 70]),
          ),
          GraphCard(
            title: 'O2',
            color: Colors.lightBlue,
            chartData: _getChartData([21, 21.5, 20.5, 22, 21, 21.2, 21.3]),
          ),
          GraphCard(
            title: 'Température',
            color: Colors.lightBlue,
            chartData: _getChartData([22, 23, 21, 22.5, 23.5, 24, 22]),
          ),
        ],
      ),
    );
  }

  List<ChartSeries> _getChartData(List<double> values) {
    List<DataPoint> data =
        values.asMap().entries.map((e) => DataPoint(e.key, e.value)).toList();
    return [
      LineSeries<DataPoint, int>(
        dataSource: data,
        xValueMapper: (DataPoint dp, _) => dp.x,
        yValueMapper: (DataPoint dp, _) => dp.y,
        color: Colors.blue,
      ),
    ];
  }
}

class DataPoint {
  DataPoint(this.x, this.y);
  final int x;
  final double y;
}

class GraphCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<ChartSeries> chartData;

  GraphCard(
      {required this.title, required this.color, required this.chartData});

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
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: chartData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
                '${selectedDate.toLocal()}'.split(' ')[0],
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
            SizedBox(height: 15),
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

class Commande extends StatefulWidget {
  @override
  _CommandeState createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  String _selectedOption = ''; // Variable pour stocker l'option sélectionnée

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1), // Espace pour pousser les éléments vers le haut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImageButton(context, 'images/water.png', 'Water Tap'),
              _buildImageButton(context, 'images/aeration.png', 'Aeration'),
            ],
          ),
          SizedBox(height: 15),
          if (_selectedOption
              .isNotEmpty) // Affiche la confirmation si une option est sélectionnée
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vous avez choisi : $_selectedOption',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // Action de confirmation
              if (_selectedOption.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Confirmation : $_selectedOption sélectionné!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Veuillez sélectionner une option avant de confirmer.'),
                  ),
                );
              }
            },
            child: Text('Confirmer'),
          ),
          Spacer(flex: 2), // Espace pour ajuster le bas de la page
        ],
      ),
    );
  }

  Widget _buildImageButton(
      BuildContext context, String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = label; // Met à jour l'option sélectionnée
        });
      },
      child: Column(
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          SizedBox(height: 15),
          Text(label),
        ],
      ),
    );
  }
}
