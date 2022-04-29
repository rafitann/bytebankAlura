import 'package:flutter/material.dart';

void main() {
  runApp(const BytebankApp());
}

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:
            ListaTransferencias() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerNumero = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Criando Transferência',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Editor(
                        controller: _controllerNumero,
                        rotulo: "Número da Conta",
                        dica: '1234-0'),
                    Editor(
                        controller: _controllerValor,
                        rotulo: 'Valor',
                        dica: '1000.0',
                        icon: Icons.monetization_on),
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                _criarTransferencia(context);
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }

  void _criarTransferencia(BuildContext context) {
    final int? numerodaConta = int.tryParse(_controllerNumero.text);
    final double? valor = double.tryParse(_controllerValor.text);

    if (numerodaConta != null && valor != null) {
      final transfer = Transferencia(valor, numerodaConta);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$transfer')));
      Navigator.pop(context,transfer);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controller;
  final String? rotulo;
  final String? dica;
  final IconData? icon;

  Editor({this.controller, this.dica, this.rotulo, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(fontSize: 18),
        controller: controller,
        decoration: InputDecoration(
            icon: icon != null ? Icon(icon) : null,
            labelText: rotulo,
            hintText: dica),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


//





class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencias>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transferências',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context,index){
          final transfer =  widget._transferencias[index];
          return ItemTransferencia(transfer);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida){
            transferenciaRecebida != null ? setState(() => widget._transferencias.add(transferenciaRecebida)) : "";
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}





//
class ItemTransferencia extends StatelessWidget {
  final Transferencia _transfer;

  ItemTransferencia(this._transfer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Colors.yellow[700]),
        title: Text(_transfer.valor.toString()),
        subtitle: Text(_transfer.numConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numConta;

  Transferencia(this.valor, this.numConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numConta: $numConta}';
  }
}
