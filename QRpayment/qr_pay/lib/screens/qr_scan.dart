import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:qr_pay/Utils/ExternalFunctions.dart';
import 'package:qr_pay/screens/navigation_page.dart';
import 'package:qr_pay/screens/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userAPI.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  int primaryColor = 0xFFCF2027;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? qrResult;
  QRViewController? controller;
  bool isCameraPaused = false;
  var sharedPreferenceUserData;
  bool isLoading = false;

  String? senderId, fullname, email, phonenumber, address;

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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAndSetLoggedInUserDetails();
    super.initState();
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
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    controller!.pauseCamera();
                    Navigator.pop(context);
                  }),
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
                              if (qrResult != null)
                                ElevatedButton(
                                    onPressed: () {
                                      verifyQrAndContinueToPayment();
                                    },
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
                              //     'Barcode Type: ${describeEnum(qrResult!.format)}   Data: ${qrResult!.code}')
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
                                          qrResult = null;
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
                      const Text("YOUR QR CODE",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      if (fullname != null && senderId != null)
                        generateQRCode()
                      else
                        Column(
                          children: const [
                            Text(
                              "Unable to load QR code",
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 10),
                            SpinKitCubeGrid(
                              color: Colors.black,
                              size: 250,
                            )
                          ],
                        ),
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
    var data = {
      "_id": senderId,
      "fullname": fullname,
      "amount": 0.0,
      "dynamic": false
    };
    return QrImageView(data: jsonEncode(data), size: 250);
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
        qrResult = scanData;
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

  getAndSetLoggedInUserDetails() async {
    sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? _fullname = sharedPreferenceUserData.getString("_fullname");
    String? _id = sharedPreferenceUserData.getString("_id");

    setState(() {
      fullname = _fullname;
      senderId = _id;
    });
  }

  verifyQrAndContinueToPayment() {
    var qrscannedData = qrResult!.code.toString();
    if (qrscannedData.contains("_id") && qrscannedData.contains("fullname")) {
      var jsonDecodedQrData = jsonDecode(qrscannedData);
      String qrId = jsonDecodedQrData['_id'].toString();
      String qrFullname = jsonDecodedQrData['fullname'].toString();
      double qRamount = jsonDecodedQrData['amount'].toDouble();
      bool isDynamic = jsonDecodedQrData['dynamic'];

      print(qRamount);

      if (qrId == senderId) {
        Fluttertoast.showToast(
            msg: 'You cannot pay yourself, please scan a different QR',
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
        setState(() {
          qrResult = null;
        });
      } else {
        print("correct qr data format");
        checkRecipient(qrId, qrFullname, qRamount, senderId, isDynamic);
      }
    } else {
      print("incorrect qr data format");

      Fluttertoast.showToast(
          msg: 'Invalid QR code',
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);

      setState(() {
        qrResult = null;
      });
    }
  }

  checkRecipient(qrId, qrFullname, qRamount, senderid, isDynamic) async {
    try {
      var responseData = await UserApi().verifyQrData(qrId, senderid);

      bool responseStatus = responseData['success'];
      if (responseStatus == true) {
        var senderdata = responseData['senderdata'];
        double totalamount = senderdata['totalamount'].toDouble();

        Fluttertoast.showToast(
            msg: responseData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 13.0);

        controller!.pauseCamera();
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Payment(qrId, qrFullname, qRamount,
                    fullname!, senderid!, totalamount, isDynamic)));

        // ignore: use_build_context_synchronously
      } else if (responseStatus == false) {
        setState(() {
          qrResult = null;
        });
        Fluttertoast.showToast(
            msg: responseData['msg'],
            gravity: ToastGravity.CENTER_LEFT,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 13.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 13.0);
    }
  }
}
