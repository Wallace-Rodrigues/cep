import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'endereco.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  var rua = '';
  var bairro = '';
  var cidade = '';
  var estado = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'Digite o CEP'),
              ),
              TextButton(
                onPressed: buscaCEP,
                child: const Text('Buscar'),
              ),
              TextField(
                controller: _ruaController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Logradouro: $rua',
                ),
              ),
              TextField(
                controller: _bairroController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Bairro: $bairro',
                ),
              ),
              TextField(
                controller: _cidadeController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Cidade: $cidade',
                ),
              ),
              TextField(
                controller: _estadoController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Estado: $estado',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buscaCEP() async {
    String cep = _cepController.text;
    String url = 'https://viacep.com.br/ws/$cep/json/';

    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode == 200) {
      // resposta 200 OK
      // o body contém JSON
      final jsonDecodificado = jsonDecode(resposta.body);
      final endereco = Endereco.fromJson(jsonDecodificado);

      setState(() {
        rua = endereco.logradouro;
        bairro = endereco.bairro;
        cidade = endereco.cidade;
        estado = endereco.estado;
      });
    } else {
      // Diferente de 200 (CEP inexistente ou erro na requisição)

      setState(() {
        cep = '';
        rua = '';
        bairro = '';
        cidade = '';
        estado = '';
      });
      throw Exception('Falha no carregamento.');
    }
  }
}
