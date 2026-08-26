import 'package:flutter/material.dart';

import '../models/registro_agua.dart';

class AdicionarRegistroScreen extends StatefulWidget {
  final RegistroAgua? registro;

  const AdicionarRegistroScreen({super.key, this.registro});

  @override
  State<AdicionarRegistroScreen> createState() =>
      _AdicionarRegistroScreenState();
}

class _AdicionarRegistroScreenState extends State<AdicionarRegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController dataController;
  late TextEditingController quantidadeController;
  late TextEditingController pesoController;

  @override
  void initState() {
    super.initState();

    dataController = TextEditingController(text: widget.registro?.data ?? '');

    quantidadeController = TextEditingController(
      text: widget.registro != null
          ? widget.registro!.quantidadeEmMl.toString()
          : '',
    );

    pesoController = TextEditingController(
      text: widget.registro != null
          ? widget.registro!.pesoAtualKg.toString()
          : '',
    );
  }

  @override
  void dispose() {
    dataController.dispose();
    quantidadeController.dispose();
    pesoController.dispose();

    super.dispose();
  }

  Future<void> selecionarData() async {
    DateTime inicial = DateTime.now();

    if (widget.registro != null) {
      try {
        final partes = widget.registro!.data.split('/');

        inicial = DateTime(
          int.parse(partes[2]),
          int.parse(partes[1]),
          int.parse(partes[0]),
        );
      } catch (_) {}
    }

    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataController.text =
            '${dataSelecionada.day.toString().padLeft(2, '0')}/'
            '${dataSelecionada.month.toString().padLeft(2, '0')}/'
            '${dataSelecionada.year}';
      });
    }
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final registro = RegistroAgua(
      data: dataController.text,
      quantidadeEmMl: double.parse(
        quantidadeController.text.replaceAll(',', '.'),
      ),
      pesoAtualKg: double.parse(pesoController.text.replaceAll(',', '.')),
    );

    Navigator.pop(context, registro);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.registro != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar registro' : 'Novo registro'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: dataController,
                readOnly: true,
                onTap: selecionarData,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione uma data';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: quantidadeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quantidade de água',
                  hintText: 'Ex: 500',
                  suffixText: 'ml',
                  prefixIcon: Icon(Icons.water_drop),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a quantidade';
                  }

                  final numero = double.tryParse(value.replaceAll(',', '.'));

                  if (numero == null || numero <= 0) {
                    return 'Digite uma quantidade válida';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: pesoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Peso atual',
                  hintText: 'Ex: 60',
                  suffixText: 'kg',
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu peso';
                  }

                  final numero = double.tryParse(value.replaceAll(',', '.'));

                  if (numero == null || numero <= 0) {
                    return 'Digite um peso válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: salvar,
                  icon: const Icon(Icons.save),
                  label: Text(
                    editando ? 'SALVAR ALTERAÇÕES' : 'SALVAR REGISTRO',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}