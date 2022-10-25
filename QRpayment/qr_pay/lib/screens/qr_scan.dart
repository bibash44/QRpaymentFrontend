import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  int primaryColor = 0xFFCF2027;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? result;
  QRViewController? controller;
  bool isCameraPaused = false;

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await qrViewController!.resumeCamera();
    } else {
      qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.camera_alt), text: "Scan"),
                  Tab(icon: Icon(Icons.qr_code_2), text: "Share"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(flex: 3, child: _buildQrView(context)),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const SizedBox(
                                height: 15,
                              ),
                              if (result != null)
                                ElevatedButton(
                                    onPressed: () {},
                                    // ignore: sort_child_properties_last
                                    child: const Text(
                                      "QR scanned, continue to payment",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.all(20),
                                        side: const BorderSide(
                                            color: Colors.black, width: 2),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)))))

                              // Text(
                              //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                              else
                                const Text(
                                  'Scan a code',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10 * 2),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.play_circle,
                                        size: 25,
                                      ),
                                      onPressed: () async {
                                        await controller?.resumeCamera();
                                        setState(() {
                                          result = null;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10 * 2),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          await controller?.toggleFlash();
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        child: FutureBuilder(
                                          future: controller?.getFlashStatus(),
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              return snapshot.data!
                                                  ? const Icon(
                                                      Icons.flash_off,
                                                      color: Colors.black,
                                                      size: 25,
                                                    )
                                                  : const Icon(
                                                      Icons.flash_on,
                                                      color: Colors.black,
                                                    );
                                            } else {
                                              return Container();
                                            }

                                            // return Text(
                                            //
                                          },
                                        )),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10 * 2),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          await controller?.flipCamera();
                                          setState(() {});
                                        },
                                        child: FutureBuilder(
                                          future: controller?.getCameraInfo(),
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              // ignore: unrelated_type_equality_checks
                                              if (describeEnum(
                                                      snapshot.data!) ==
                                                  "back") {
                                                return const Icon(
                                                    Icons.flip_camera_ios);
                                              }

                                              return const Icon(Icons
                                                  .flip_camera_ios_outlined);

                                              // return Text(
                                              //     'Camera facing ${describeEnum(snapshot.data!)}');
                                            } else {
                                              return const SpinKitCircle(
                                                color: Colors.black,
                                              );
                                            }
                                          },
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ), // buildQRView(context),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("QR PAY",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      generateQRCode(),
                      const SizedBox(height: 15),
                      const Text(
                          "This code can be scanned by other users to pay you",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget generateQRCode() {
    return QrImage(data: "bibash", size: 200);
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderLength: 20,
          borderColor: Colors.red,
          borderWidth: 10,
          borderRadius: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
