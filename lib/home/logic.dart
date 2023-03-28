import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  var username = Get.arguments['username'];
  var newMessage = TextEditingController();
  var portController = TextEditingController();
  var messages = <String>[].obs;
  late RawDatagramSocket socket ;


  @override
  void onInit() {
    super.onInit();
    init(1234);
  }

  Future<void> init(int port) async {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
  }

  void sendMessage(String ip, int port, String message) {
    try {
      // socket = await RawDatagramSocket.bind(ip, port);
      List<int> data = utf8.encode(message);
      socket.send(data, InternetAddress(ip), port);
      socket.close();
    }catch(exception){
      debugPrint(exception.toString());
    }
  }

  Future<void> receiveMessage(int port) async{
    await socket.forEach((event) {
        if(event == RawSocketEvent.read){
          Datagram? datagram = socket.receive();
          var message = datagram?.data;
          messages.add(utf8.decode(message!));
        }
    });
  }


  
}
