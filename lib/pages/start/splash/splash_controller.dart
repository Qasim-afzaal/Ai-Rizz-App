import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:sparkd/core/constants/constants.dart';
import 'package:sparkd/core/constants/helper.dart';
import 'package:sparkd/routes/app_pages.dart';

import '../../../main.dart';
import '../../payment/payment_plan/payment_plan_controller.dart';

class SplashController extends GetxController {
  // final PaymentPlanController _paymentPlanController =
  //     getPaymentPlanController();


  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (getStorageData.readString(getStorageData.tokenKey) != null) {
        if (getStorageData.readBoolean(key: getStorageData.isPinCreated)) {
          Get.offNamed(Routes.PIN_VERIFICATION);
        } else {
         
        }
      } else {
        Get.offNamed(Routes.MAINPAGE);
      }
    });
    super.onReady();
  }

  socketRegister() {
    printAction("-==-=-= socket conneting");
    Constants.socket = IO.io(
      Constants.socketBaseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'upgraded': ['websocket'],
        'autoConnect': true,
      },
    );
    // TODO : Socket Connections Methods

    // TODO : on Connect
    Constants.socket!.onConnect((data) => checkSocket(data, "onConnect"));

    // TODO : on Connecting
    Constants.socket!.onConnecting((data) => checkSocket(data, "onConnecting"));

    // TODO : on ConnectError
    Constants.socket!
        .onConnectError((data) => checkSocket(data, "onConnectError"));

    // TODO : on Connect Timeout
    Constants.socket!
        .onConnectTimeout((data) => checkSocket(data, "onConnectTimeout"));

    // TODO : on Disconnect
    Constants.socket!.onDisconnect((data) => checkSocket(data, "onDisconnect"));
  }

  void checkSocket(data, String identify) {
    if (identify == 'onConnect') {
      printOkStatus(" <<< ---------- Socket $identify ---------- >>>");
    } else {
      printError(" <<< ---------- Socket $identify ---------- >>>");
    }
  }

  @override
  void onInit() {
    getId();
    socketRegister();
    super.onInit();
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      getStorageData.saveString(
          getStorageData.deviceId, iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      getStorageData.saveString(getStorageData.deviceId, androidDeviceInfo.id);
      return androidDeviceInfo.id;
    }
    return null;
  }
}
