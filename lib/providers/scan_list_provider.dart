import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedOption = 'http'; //http by default

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);

    // Asignamos el nuevo id de la base de datos al modelo
    nuevoScan.id = id;

    //Actualizamos nuestro listado de scans con el nuevo
    //Aunque aún no se actualiza la ui
    //Y solo lo añadimos a la lista si el nuevo scan
    //es del mismo tipo que la pestaña que tenemos seleccionada
    if (selectedOption == nuevoScan.tipo) {
      scans.add(nuevoScan);
      //Notificamos a cualquier widget interesado
      notifyListeners();
    }

    return nuevoScan;
  }

  loadScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...?scans];
    notifyListeners();
  }

  loadScansByType(String type) async {
    final scans = await DBProvider.db.getScansByType(type);
    this.scans = [...scans];
    selectedOption = type;
    notifyListeners();
  }

  removeAll() async {
    await DBProvider.db.deleteAllScan();
    scans = [];
    notifyListeners();
  }

  removeScanById(int id) async {
    await DBProvider.db.deleteScan(id);
    scans.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
