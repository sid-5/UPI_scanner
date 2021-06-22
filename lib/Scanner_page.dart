import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:upi_canner/Services/contactsAPI.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Contact obj = Contact();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    Future future = obj.getURL();
    future.then((value) => (){
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building widget");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Savings",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      body: Stack(
        children: [Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Pay through UPI",style: TextStyle(fontSize:18,color: Colors.black, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(cursorColor: Colors.blue,
                decoration: InputDecoration(
                  hintText: "Enter UPI number here",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      //  when the TextFormField in unfocused
                    ) ,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      //  when the TextFormField in focused
                    ) ,
                    border: UnderlineInputBorder(
                    )
                ),),
              )],
            ),),
            Container(height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.width, child: _buildQrView(context)),
          ],
        ),
          DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.5,
              builder: (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Container(height: 13, width: MediaQuery.of(context).size.width*0.2,decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                      color: Colors.white,
                    ),),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Search Contact",style: TextStyle(fontSize:18,color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                  hintText: "Select Number",
                                  suffixIcon: Icon(Icons.contact_page_outlined, color: Colors.deepPurpleAccent,),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                                    //  when the TextFormField in unfocused
                                  ) ,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    //  when the TextFormField in focused
                                  ) ,
                                  border: UnderlineInputBorder(
                                  )
                              ),),
                          ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(obj.imageURL??""),
                                  ),
                                  SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Sumanth Verma",style: TextStyle(fontSize:18,color: Colors.black, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 5,),
                                      Text("8782348812",style: TextStyle(fontSize:16,color: Colors.blueGrey, fontWeight: FontWeight.w300))
                                    ],
                                  )
                                ],
                              ),
                            )],
                          ),
                        ),
                      ),
                    ),
                  ],
                );})]
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}