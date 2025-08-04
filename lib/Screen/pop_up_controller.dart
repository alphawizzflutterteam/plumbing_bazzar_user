import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PopupController extends GetxController {
  Timer? popupTimer;
  String? imageUrl;
  bool _isDialogShowing = false;

  late BuildContext context;

  void setContext(BuildContext ctx) {
    context = ctx;
  }

  Future<String?> fetchImageUrl() async {
    try {
      final response = await http.get(
        Uri.parse('https://plumbing-new.alphawizzserver.com/app/v1/api/get_popup_images'),
      );
      print("Image URL Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for list and first image
        if (data['data'] != null &&
            data['data'] is List &&
            data['data'].isNotEmpty &&
            data['data'][0]['image'] != null) {
          return data['data'][0]['image'];
        } else {
          print("No image found in API response");
          return null;
        }
      } else {
        print("Failed to fetch image URL: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
    }
  }


  void fetchAndStartPopup() async {
    if (popupTimer != null && popupTimer!.isActive) return;

    imageUrl = await fetchImageUrl();

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      Future.delayed(Duration(minutes: 2), () {
        popupTimer = Timer.periodic(Duration(minutes: 3), (timer) {
          if (!_isDialogShowing) {
            showImagePopup();
          }/* else {
            timer.cancel();
          }*/
        });
      });
    }
  }
  void stopPopup() {
    print('PrintData____serwertrtgertrtgderfgtdgtr}_____');
    if (popupTimer != null && popupTimer!.isActive) {
      popupTimer!.cancel();
      popupTimer = null;
    }
  }

  void showImagePopup() {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.91,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, size: 50, color: Colors.red),
                                    Text("Failed to load image"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  void onClose() {
    popupTimer?.cancel();
    super.onClose();
  }
}
