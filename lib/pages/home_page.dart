import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/pages.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/widgets/widgets.dart';
import 'package:qr_reader/providers/ui_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Historial'),
        actions: [
          IconButton(
              onPressed: () {
                scanListProvider.removeAll();
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: const _HomePageBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtener el selected menu opt
    //i le tenemos que indicar el provider que queremos
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenudOpt;

    //Usamos listen en false porque aquí no queremos que se redibuje este widget
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.loadScansByType('geo');
        return ScanTiles(tipo: 'geo');
      case 1:
        scanListProvider.loadScansByType('http');
        return ScanTiles(
          tipo: 'http',
        );
      default:
        return ScanTiles(tipo: 'geo');
    }
  }
}
