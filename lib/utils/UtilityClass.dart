import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:optimanage/main.dart';
import 'package:intl/intl.dart';

class UtilityClass {
  static BuildContext? dialogContext;

  static showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          side: BorderSide(
            width: 2.0,
            style: BorderStyle.solid,
            color: Colors.blueGrey,
          ),
        ),
        duration: const Duration(milliseconds: 3000),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      ),
    );
  }

  // static showSnackBar2(BuildContext context, String message, Color color) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       backgroundColor: color,
  //
  //       behavior: SnackBarBehavior.floating,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(10.0),
  //         ),
  //         side: BorderSide(
  //           width: 2.0,
  //           style: BorderStyle.solid,
  //           color: Colors.blueGrey,
  //         ),
  //       ),
  //       duration: const Duration(milliseconds: 7000),
  //       margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
  //       padding:
  //           const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
  //     ),
  //   );
  // }

  static showProgressDialog(BuildContext context, String message) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return Dialog(
            backgroundColor: Colors.grey[100],
            child: Container(
              height: 150,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      size: 60,
                      color: Colors.lightGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static dismissProgressDialog() {
    if (dialogContext != null) {
      Navigator.pop(navigatorKey.currentState!.context!);
    } else {
      debugPrint("Unable to dismiss progress dialog");
    }
  }

  static Future<bool> askForInput(
      String title,
      String message,
      String positiveButton,
      String negativeButton,
      bool showOnlyOneButton,
      ) async {
    return await showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logos/logout.png', width: 50, height: 50), // 👈 Your icon
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!showOnlyOneButton)
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1C355E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // 👈 Cancel returns false
                        },
                        child: Text(
                          negativeButton,
                          style: const TextStyle(color: Color(0xFF1C355E)),
                        ),
                      ),
                    ),
                  if (!showOnlyOneButton) const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C355E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true); // 👈 Logout returns true
                      },
                      child: Text(
                        positiveButton,
                        style: const TextStyle(color: Colors.white), // Ensures white text on red
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  // static Future<bool> showAlert(BuildContext context, String title,
  //     String message, String buttonText) async {
  //   return await showCupertinoDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15),
  //         side: BorderSide(width: 3.0, color: Colors.red[200]!),
  //       ),
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: () => Navigator.of(context).pop(false),
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 width: 100,
  //                 padding: const EdgeInsets.all(10),
  //                 margin: const EdgeInsets.symmetric(horizontal: 10),
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.green[400]!, width: 2),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Text(
  //                   buttonText,
  //                   style: const TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }


  // static void checkConnection(BuildContext context) async{
  //   final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //   if(connectivityResult.contains(ConnectivityResult.mobile)){
  //     showSnackBar2(context, 'Mobile: Online', Colors.green);
  //   }else if (connectivityResult.contains(ConnectivityResult.wifi)) {
  //     showSnackBar2(context, 'WiFi: Online', Colors.green);
  //   }else if (connectivityResult.contains(ConnectivityResult.none)) {
  //     showSnackBar2(context, 'No Internet Connection', Colors.red);
  //   }else{
  //     showSnackBar2(context, 'Unknown Connection Status', Colors.blue);
  //
  //   }
  // }

  // String formatDateToIST(DateTime dateTime) {
  //   DateTime istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
  //   String formattedDate = DateFormat('EEE MMM dd yyyy HH:mm:ss').format(istDateTime);
  //   String timeZoneOffset = "GMT+0530";
  //   String timeZoneName = "(India Standard Time)";
  //   return "$formattedDate $timeZoneOffset $timeZoneName";
  // }
}
