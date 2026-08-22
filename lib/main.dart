import 'package:flutter/material.dart';

void main() {
  runApp(const MiAsistenteApp());
}

class SupportRequest {
  SupportRequest({
    required this.id,
    required this.message,
    this.status = 'Pendiente',
  });

  final String id;
  String message;
  String status;
}

class SupportRequestStore extends ChangeNotifier {
  final List<SupportRequest> _requests = [];

  List<SupportRequest> get requests => List.unmodifiable(_requests);

  // CREATE
  void create(String message) {
    final text = message.trim();
    if (text.isEmpty) return;

    _requests.insert(
      0,
      SupportRequest(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: text,
      ),
    );
    notifyListeners();
  }

  // READ
  SupportRequest? read(String id) {
    for (final request in _requests) {
      if (request.id == id) return request;
    }
    return null;
  }

  // UPDATE
  void update(String id, {String? message, String? status}) {
    final request = read(id);
    if (request == null) return;

    if (message != null && message.trim().isNotEmpty) {
      request.message = message.trim();
    }
    if (status != null) request.status = status;
    notifyListeners();
  }

  // DELETE
  void delete(String id) {
    _requests.removeWhere((request) => request.id == id);
    notifyListeners();
  }
}

class MiAsistenteApp extends StatefulWidget {
  const MiAsistenteApp({super.key});

  @override
  State<MiAsistenteApp> createState() => _MiAsistenteAppState();
}

class _MiAsistenteAppState extends State<MiAsistenteApp> {
  final store = SupportRequestStore();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MiAsistente Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: SupportHome(store: store),
    );
  }
}

class SupportHome extends StatefulWidget {
  const SupportHome({super.key, required this.store});

  final SupportRequestStore store;

  @override
  State<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends State<SupportHome> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.store.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _createRequest() {
    widget.store.create(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MiAsistente Care'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.support_agent),
                title: Text('Asistente de soporte'),
                subtitle: Text(
                  'Registra una consulta y administra su seguimiento.',
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Describe tu consulta',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'Agregar',
                  onPressed: _createRequest,
                  icon: const Icon(Icons.send),
                ),
              ),
              onSubmitted: (_) => _createRequest(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: widget.store.requests.isEmpty
                  ? const Center(
                      child: Text('Aún no hay solicitudes registradas.'),
                    )
                  : ListView.builder(
                      itemCount: widget.store.requests.length,
                      itemBuilder: (context, index) {
                        final request = widget.store.requests[index];
                        return Card(
                          child: ListTile(
                            title: Text(request.message),
                            subtitle: Text(request.status),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  tooltip: 'Actualizar',
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () => widget.store.update(
                                    request.id,
                                    status: 'Atendida',
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Borrar',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      widget.store.delete(request.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

