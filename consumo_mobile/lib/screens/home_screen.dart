import 'package:flutter/material.dart';

import '../models/registro_agua.dart';
import '../services/storage_service.dart';
import 'adicionar_registro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RegistroAgua> registros = [];

  @override
  void initState() {
    super.initState();
    carregarRegistros();
  }

  Future<void> carregarRegistros() async {
    final dados = await StorageService.carregarRegistros();

    setState(() {
      registros = dados;
    });
  }

  Future<void> salvarDados() async {
    await StorageService.salvarRegistros(registros);
  }

  String get dataHoje {
    final agora = DateTime.now();

    return '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year}';
  }

  List<RegistroAgua> get registrosHoje {
    return registros.where((registro) => registro.data == dataHoje).toList();
  }

  double get totalConsumidoHoje {
    return registrosHoje.fold(
      0,
      (total, registro) => total + registro.quantidadeEmMl,
    );
  }

  double get pesoAtual {
    if (registrosHoje.isEmpty) {
      return 0;
    }

    return registrosHoje.last.pesoAtualKg;
  }

  double get metaDiaria {
    return pesoAtual * 35;
  }

  double get porcentagemMeta {
    if (metaDiaria <= 0) {
      return 0;
    }

    return (totalConsumidoHoje / metaDiaria) * 100;
  }

  Future<void> adicionarRegistro() async {
    final resultado = await Navigator.push<RegistroAgua>(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarRegistroScreen()),
    );

    if (resultado != null) {
      setState(() {
        registros.add(resultado);
      });

      await salvarDados();
    }
  }

  Future<void> editarRegistro(int index) async {
    final resultado = await Navigator.push<RegistroAgua>(
      context,
      MaterialPageRoute(
        builder: (_) => AdicionarRegistroScreen(registro: registros[index]),
      ),
    );

    if (resultado != null) {
      setState(() {
        registros[index] = resultado;
      });

      await salvarDados();
    }
  }

  Future<void> excluirRegistro(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir registro?'),
          content: const Text(
            'Tem certeza que deseja excluir '
            'este registro?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCELAR'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        registros.removeAt(index);
      });

      await salvarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    final porcentagem = porcentagemMeta.clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.water_drop),
            SizedBox(width: 10),
            Text('AquaControl', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarRegistro,
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: carregarRegistros,

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Consumo de hoje',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              dataHoje,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 20),

            // CARD PRINCIPAL
            Container(
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  const Icon(Icons.water_drop, size: 50),

                  const SizedBox(height: 10),

                  Text(
                    '${totalConsumidoHoje.toStringAsFixed(0)} ml',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'de ${metaDiaria.toStringAsFixed(0)} ml',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: porcentagem / 100,
                      minHeight: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${porcentagemMeta.toStringAsFixed(2)}% da meta atingida',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  if (pesoAtual > 0)
                    Text(
                      'Peso utilizado: '
                      '${pesoAtual.toStringAsFixed(1)} kg',
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Meus registros',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (registros.isEmpty)
              Container(
                padding: const EdgeInsets.all(30),

                child: Column(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Nenhum registro ainda.',
                      style: TextStyle(fontSize: 17),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Clique no botão + para adicionar.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...registros.asMap().entries.map((entry) {
                final index = entry.key;
                final registro = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    onTap: () => editarRegistro(index),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),

                    leading: Container(
                      width: 50,
                      height: 50,

                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(Icons.water_drop, color: Colors.blue),
                    ),

                    title: Text(
                      '${registro.quantidadeEmMl.toStringAsFixed(0)} ml',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Text(
                      '${registro.data} • '
                      '${registro.pesoAtualKg.toStringAsFixed(1)} kg',
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),

                      onPressed: () => excluirRegistro(index),
                    ),
                  ),
                );
              }),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}