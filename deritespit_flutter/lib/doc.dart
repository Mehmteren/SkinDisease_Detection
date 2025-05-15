import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

class DocPage extends StatefulWidget {
  @override
  _DocPageState createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  dynamic _originalImage;
  dynamic _processedImage;
  final picker = ImagePicker();
  String _prediction = '';
  double _confidence = 0.0;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (kIsWeb) {
          _originalImage = pickedFile;
        } else {
          _originalImage = io.File(pickedFile.path);
        }
        _prediction = '';
        _processedImage = null;
      } else {
        print('No image selected.');
      }
    });

    if (_originalImage != null) {
      await removeBackgroundAndClassify(_originalImage);
    }
  }

  Future<void> removeBackgroundAndClassify(dynamic image) async {
    var removeBgResponse = await removeBackground(image);
    if (removeBgResponse != null) {
      setState(() {
        _processedImage = removeBgResponse;
      });
      await uploadImage(_processedImage);
    } else {
      print('Background removal failed');
    }
  }

  Future<dynamic> removeBackground(dynamic image) async {
    final apiKey = 'ndErs5cYTWTdFWQZJB2SAqRV';
    final url = 'https://api.remove.bg/v1.0/removebg';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image_file',
          await image.readAsBytes(),
          filename: 'image.jpg',
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('image_file', image.path),
      );
    }

    request.headers['X-Api-Key'] = apiKey;

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        return responseData;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error in removeBackground: $e');
      return null;
    }
  }

  Future<void> uploadImage(dynamic imageBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.163:5000/predict'),
    );

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg',
        ),
      );
    } else {
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/temp_image.jpg';
      var file = await io.File(filePath).writeAsBytes(imageBytes);
      request.files.add(
        await http.MultipartFile.fromPath('image', file.path),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        setState(() {
          _prediction = decodedData['prediction'];
          _confidence = decodedData['confidence'];
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in uploadImage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Text(
              'Hastalık Tespit ve Öneri',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.white,
              ),
            ),
            Text(
              'Hastalık Tespit ve Öneri',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 90, 100),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 226, 244, 249),
      ),
      backgroundColor: Color.fromARGB(255, 226, 244, 249),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_originalImage == null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Text(
                        'Seçili görüntü yok.',
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        'Seçili görüntü yok.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 53, 134, 130),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_processedImage == null)
                Card(
                  elevation: 5,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: kIsWeb
                        ? Image.network(
                            _originalImage.path,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _originalImage,
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              else
                Card(
                  elevation: 5,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.memory(
                      _processedImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (_prediction.isNotEmpty)
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Prediction: ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 90, 100),
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: _prediction,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' (Confidence: ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 90, 100),
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: '${(_confidence * 100).toStringAsFixed(2)}%)',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.camera),
            tooltip: 'Take Photo',
            child: Icon(Icons.camera),
            backgroundColor: Color.fromARGB(255, 53, 134, 130),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.gallery),
            tooltip: 'Upload Image',
            child: Icon(Icons.photo_library),
            backgroundColor: Color.fromARGB(255, 53, 134, 130),
          ),
        ],
      ),
    );
  }
}
