import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CuadreDeCajaApp());
}

class CuadreDeCajaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuadre de Efectivo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      home: CuadreScreen(),
    );
  }
}

class CuadreScreen extends StatefulWidget {
  @override
  _CuadreScreenState createState() => _CuadreScreenState();
}

class _CuadreScreenState extends State<CuadreScreen> {
  final Map<int, TextEditingController> controllers = {
    20000: TextEditingController(),
    10000: TextEditingController(),
    5000: TextEditingController(),
    2000: TextEditingController(),
    1000: TextEditingController(),
    500: TextEditingController(),
  };
  final TextEditingController monedasController = TextEditingController();
  final TextEditingController totalSistemaController = TextEditingController();
  final NumberFormat currencyFormat = NumberFormat('#,##0', 'es_CL');

  double get totalGlobal {
    double total = 0;
    controllers.forEach((denominacion, controller) {
      int cantidad = int.tryParse(controller.text) ?? 0;
      total += cantidad * denominacion;
    });
    total += double.tryParse(monedasController.text) ?? 0;
    return total;
  }

  double get diferencia {
    double totalSistema = double.tryParse(totalSistemaController.text) ?? 0;
    return totalSistema - totalGlobal;
  }

  void limpiarCampos() {
    controllers.values.forEach((controller) => controller.clear());
    monedasController.clear();
    totalSistemaController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuadre de Efectivo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Cuadre de Efectivo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              buildCard(
                child: TextField(
                  controller: totalSistemaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Capturador',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 8),
              ...controllers.entries.map((entry) => buildRow(entry.key, entry.value)).toList(),
              SizedBox(height: 8),
              buildMonedasRow(),
              SizedBox(height: 16),
              Text(
                'Total Contado: \$${currencyFormat.format(totalGlobal)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Diferencia: \$${currencyFormat.format(diferencia)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: diferencia >= 0 ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: limpiarCampos,
        child: Icon(Icons.cleaning_services),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  Widget buildRow(int denominacion, TextEditingController controller) {
    String imagePath = 'assets/billetes/$denominacion.png';

    return buildCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                imagePath,
                width: 35,
                height: 20,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.money),
              ),
              SizedBox(width: 6),
              Text('\$${currencyFormat.format(denominacion)}', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'N° Billetes',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Text(
            '\$${currencyFormat.format((int.tryParse(controller.text) ?? 0) * denominacion)}',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget buildMonedasRow() {
    return buildCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/billetes/monedas.png',
                width: 35,
                height: 20,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.attach_money),
              ),
              SizedBox(width: 6),
              Text('Monedas', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: monedasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Text(
            '\$${currencyFormat.format(double.tryParse(monedasController.text) ?? 0)}',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
