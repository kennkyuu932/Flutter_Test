import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';//File
import 'dart:typed_data';// Uint8List
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  // 画像をギャラリーから選ぶ関数
  Future pickImage() async {
    try {
      //XFile型
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // 画像がnullの場合戻る
      if (image == null) return;

      //
      final imageTemp = File(image.path);

      //状態を確定する(これをしないと画面がに画像が出ない)
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future _saveImage() async {
    if(image != null) {
      Uint8List _buffer = await image!.readAsBytes();
      final result = await ImageGallerySaver.saveImage(_buffer);
    }
  }

  //UIについて書かれた場所
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Image Viewer!!'),//widget.title
      ),
      body: Center(
        // 画像がないと文字が表示される
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //画像を開くボタン
            Container(
              alignment: Alignment.center,
              height: 300,
              width: 300,
              child: image != null ? Image.file(image!) :Container(
                  alignment: Alignment.center,
                  color: image != null ? Colors.transparent : Colors.blueGrey,
                  child:const Text(
                    "画像がないです",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      )
                    )
                )
            ),
            //画像を保存するボタン
            ElevatedButton(
                onPressed: _saveImage,
                child: Text("save image")
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'pick image',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
