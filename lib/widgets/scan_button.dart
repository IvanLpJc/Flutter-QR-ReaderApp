import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

import '../models/scan_model.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(Icons.filter_center_focus),
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancelar', false, ScanMode.QR);
        //String barcodeScanRes = 'geo:43.58259365521908,7.114484878730382';

        //Si recibimos un -1, quiere decir que el usuario canceló
        if (barcodeScanRes == '-1') return;

        //Esto es un ejemplo de como podemos hacer que el scan nos abra lo
        //que estamos escaneando directamente al escanearlo
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        final ScanModel nuevoScan =
            await scanListProvider.nuevoScan(barcodeScanRes);

        goToUrl(context, nuevoScan);
      },
    );
  }
}
