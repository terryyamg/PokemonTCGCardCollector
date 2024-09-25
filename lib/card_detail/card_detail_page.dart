// lib/card_detail/card_detail_page.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../card/models/pokemon_card.dart';
import '../utils/logger.dart';
import 'bloc/card_detail_bloc.dart';

class CardDetailPage extends StatelessWidget {
  final List<PokemonCard> pokemonCards;
  final int number;

  const CardDetailPage(
      {super.key, required this.pokemonCards, required this.number});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) => CardDetailBloc(number), // 傳入初始頁面到 Bloc
        child: BlocBuilder<CardDetailBloc, CardDetailState>(
          builder: (context, state) {
            return SizedBox(
              child: PageView.builder(
                itemCount: pokemonCards.length,
                controller: PageController(
                  viewportFraction: 0.9,
                  initialPage: number, // 使用傳入的 number 作為初始頁面
                ),
                onPageChanged: (index) {
                  context.read<CardDetailBloc>().add(PageChangedEvent(index));
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _checkAndRequestPermission(
                        context, pokemonCards[index].imageUrl),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.all(
                          state.currentPage == index ? 0.0 : 8.0),
                      child: InteractiveViewer(
                        panEnabled: false,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: Image.network(
                          pokemonCards[index].imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _checkAndRequestPermission(
      BuildContext context, String imageUrl) async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        await _downloadImage(imageUrl);
      } else {
        _showPermissionDialog(context, imageUrl);
      }
    } else {
      // iOS 或其他平台的處理
      if (await Permission.photos.isGranted) {
        await _downloadImage(imageUrl);
      } else {
        _showPermissionDialog(context, imageUrl);
      }
    }
  }

  void _showPermissionDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('權限請求'),
          content: const Text('我們需要存取權限來下載圖片，請授予權限。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 關閉對話框
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 關閉對話框
                bool granted = false;
                if (Platform.isAndroid) {
                  var androidInfo = await DeviceInfoPlugin().androidInfo;
                  var sdkInt = androidInfo.version.sdkInt;
                  if (Platform.isAndroid && sdkInt.compareTo(33) >= 0) {
                    granted = await Permission.photos.request().isGranted;
                  } else if (Platform.isAndroid) {
                    granted = await Permission.storage.request().isGranted ||
                        await Permission.manageExternalStorage
                            .request()
                            .isGranted;
                  } else {
                    granted = await Permission.photos.request().isGranted;
                  }
                }
                if (Platform.isIOS) {
                  logger.d("Requesting photo permission on iOS...");
                  granted = await Permission.photos.request().isGranted;
                  logger.d("Permission granted: $granted");
                }
                if (granted) {
                  await _downloadImage(imageUrl);
                } else {
                  Fluttertoast.showToast(msg: "未授予存取權限");
                }
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    try {
      // 使用 http 獲取圖片數據
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // 獲取圖片的字節數據
        Uint8List bytes = response.bodyBytes;

        // 使用 ImageGallerySaver 保存圖片
        final result = await ImageGallerySaver.saveImage(bytes);

        if (result['isSuccess']) {
          Fluttertoast.showToast(msg: "圖片已下載");
        } else {
          Fluttertoast.showToast(msg: "圖片下載失敗");
        }
      } else {
        Fluttertoast.showToast(msg: "圖片下載失敗: 網絡錯誤");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "下載失敗: $error");
    }
  }
}
