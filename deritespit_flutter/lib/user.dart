import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  dynamic _originalImage;
  dynamic _processedImage;
  final picker = ImagePicker();
  String _prediction = '';
  double _confidence = 0.0;
  String _customMessage = '';

  List<Map<String, String>> chickenPoxItems = [
    {
      'image': 'assets/sirke.jpeg',
      'title': 'Sirke🔎',
      'url':
          'https://www.trendyol.com/wefood/organik-alic-sirkesi-500-ml-p-127178797?merchantId=370301'
    },
    {
      'image': 'assets/bittim.jpeg',
      'title': 'Bıttım Sabunu🔎',
      'url':
          'https://www.trendyol.com/sabuncu-mevlut-efendi/bittim-sabunu-450-gr-4-adet-p-92626222?merchantId=291268'
    },
    {
      'image': 'assets/nem.jpeg',
      'title': 'Dephantol🔎',
      'url':
          'https://www.trendyol.com/bepanthol/onarici-bakim-merhemi-30gr-l-cok-kuru-ciltler-ve-tahrise-yatkin-bolgeler-icin-bakim-p-85303?boutiqueId=61&merchantId=315133'
    },
    {
      'image': 'assets/cvit.jpeg',
      'title': 'C Vitamini🔎',
      'url':
          'https://www.trendyol.com/one-up/c-vitamini-1000-mg-60-tablet-p-39720880?boutiqueId=61&merchantId=105100'
    },
    {
      'image': 'assets/bal.jpeg',
      'title': 'Bal🔎',
      'url':
          'https://www.trendyol.com/egricayir/organik-poliflorali-bal-ta16-450g-p-4429617?boutiqueId=61&merchantId=107257'
    },
  ];

  List<Map<String, String>> monkeyPoxItems = [
    {
      'image': 'assets/kizilcik.jpeg',
      'title': 'Kızılcık Suyu🔎',
      'url':
          'https://www.trendyol.com/zadelife/kizilcik-ozu-700-gr-p-461196830?boutiqueId=61&merchantId=554417'
    },
    {
      'image': 'assets/cvit.jpeg',
      'title': 'C Vitamini🔎',
      'url':
          'https://www.trendyol.com/one-up/c-vitamini-1000-mg-60-tablet-p-39720880?boutiqueId=61&merchantId=105100'
    },
  ];

  List<Map<String, String>> mealesItems = [
    {
      'image': 'assets/arpa.jpeg',
      'title': 'Arpa🔎',
      'url':
          'https://www.trendyol.com/genel-markalar/dogal-tane-arpa-tohumu-yemlik-1-kg-p-55947469?boutiqueId=61&merchantId=124121'
    },
    {
      'image': 'assets/cvit.jpeg',
      'title': 'C Vitamini🔎',
      'url':
          'https://www.trendyol.com/one-up/c-vitamini-1000-mg-60-tablet-p-39720880?boutiqueId=61&merchantId=105100'
    },
    {
      'image': 'assets/lavanta.jpeg',
      'title': 'Lavanta Yağı🔎',
      'url':
          'https://www.trendyol.com/lakani-beauty/fransiz-lavanta-yagi-100-saf-ve-organik-p-663714074?boutiqueId=61&merchantId=505020'
    },
    {
      'image': 'assets/zeytin.jpeg',
      'title': 'Zeytin Yaprağı🔎',
      'url':
          'https://www.trendyol.com/organik-teyze/sevinc-teyze-zeytin-yapragi-olive-leaves-oleae-folium-oleaceae-olumsuz-agac-yapragi-50g-p-225920245?boutiqueId=61&merchantId=203747'
    },
  ];

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
        _customMessage = '';
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
          if (_prediction == 'Dried') {
            _customMessage = 'Bu hastalık için bıttım sabunu kullanılmalıdır';
          } else if (_prediction == 'MonkeyPox') {
            _customMessage =
                'İbni Sina\'ya göre Maymun çiçeği hastalığına kızılcık suyu ve C vitamini iyi gelmektedir. '
                'Kızılcık suyu ateş düşürmekte etkin bir yol oynar. Bunun yanında C vitamini kullanmak vücuda zinde tuttuğu '
                'gibi Maymun çiçeği hastalığını atlatmakta büyük pay sahibidir.'
                '\n'
                '\n';
          } else if (_prediction == 'Meales') {
            _customMessage = 'İbni Sina\'ya göre;\n'
                'Arpa kızamık tedavi sürecinde oldukça faydalıdır. Bir bardak arpayı 3 bardak su ile karıştırıp kaynatarak içmek '
                'hem kaşıntılara iyi gelir hem de hastalık sürecinin daha rahat geçmesini sağlar.\n'
                'Zeytin yaprağı kızamık tedavisinde kullanılabilecek etkili bir bitkisel üründür. antibakteriyel ve antiviral '
                'özellikler barındırması nedeni ile Paramyxo virüsünün yok edilmesine yardımcı olur.\n'
                'Lavanta yağı özellikle hastalık nedeni ile uyku problemi çeken kişiler için ideal bir bitki özüdür. Nevresime bir iki '
                'damla damlatılarak hastanın daha rahat uyuması sağlanabilir. Kızamık süresince kaşınma durumunda vücutta oluşacak '
                'yaraları da önleyecektir.'
                '\n'
                '\n';
          } else if (_prediction == 'chickenPox') {
            _customMessage =
                'İbni Sina\'ya göre su çiçeğinde doğal sirke ile alınan duş çok iyi gelmektedir. '
                'Suçiçeği çıkaran çocukların yiyecek ve içecekleri balla tatlandırılabilir. 1 bardak ılık süte 1 tatlı kaşığı bal karıştırarak '
                'çocuğunuza içirebilirsiniz. Hem rahat bir uyku sağlar hem de bağışıklığını güçlendirir. Bunun yanında C vitamini '
                'kullanmak vücuda zinde tutar su çiçeği hastalığının iyileşme sürecini hızlandırabilir.'
                '\n'
                '\n';
          } else {
            _customMessage = '';
          }
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in uploadImage: $e');
    }
  }

  void shiftLeft() {
    setState(() {
      var first;
      if (_prediction == 'MonkeyPox') {
        first = monkeyPoxItems.removeAt(0);
        monkeyPoxItems.add(first);
      } else if (_prediction == 'Meales') {
        first = mealesItems.removeAt(0);
        mealesItems.add(first);
      } else {
        first = chickenPoxItems.removeAt(0);
        chickenPoxItems.add(first);
      }
    });
  }

  void shiftRight() {
    setState(() {
      var last;
      if (_prediction == 'MonkeyPox') {
        last = monkeyPoxItems.removeAt(monkeyPoxItems.length - 1);
        monkeyPoxItems.insert(0, last);
      } else if (_prediction == 'Meales') {
        last = mealesItems.removeAt(mealesItems.length - 1);
        mealesItems.insert(0, last);
      } else {
        last = chickenPoxItems.removeAt(chickenPoxItems.length - 1);
        chickenPoxItems.insert(0, last);
      }
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
                    SizedBox(height: 10),
                    if (_customMessage.isNotEmpty)
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (_prediction == 'Meales')
                                      TextSpan(
                                        text: 'İbni Sina\'ya göre;\n',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(195, 79, 128, 126),
                                          fontSize: 20,
                                        ),
                                      ),
                                    TextSpan(
                                      text: _customMessage.replaceAll(
                                          'İbni Sina\'ya göre;\n', ''),
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 53, 134, 130),
                                        fontSize: 20,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'İbni sinanın alınan tavsiyelere göre sizler için önerlen şifa ürünleri aşağıda hemen bir tık uzakta ↓',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 25, 90, 100),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_prediction == 'chickenPox')
                                SizedBox(height: 20),
                              if (_prediction == 'chickenPox')
                                buildScrollableRow(chickenPoxItems),
                              if (_prediction == 'MonkeyPox')
                                SizedBox(height: 20),
                              if (_prediction == 'MonkeyPox')
                                buildScrollableRow(monkeyPoxItems),
                              if (_prediction == 'Meales') SizedBox(height: 20),
                              if (_prediction == 'Meales')
                                buildScrollableRow(mealesItems),
                            ],
                          ),
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

  Widget buildScrollableRow(List<Map<String, String>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: shiftLeft,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items
                  .map((item) =>
                      _buildCard(item['image']!, item['title']!, item['url']))
                  .toList(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: shiftRight,
        ),
      ],
    );
  }

  Widget _buildCard(String imagePath, String title, [String? url]) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          _launchURL(url);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 180,
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
                border: Border.all(
                  color: Color.fromARGB(255, 53, 134, 130),
                  width: 0.5,
                ),
              ),
            ),
            SizedBox(height: 5),
            MouseRegion(
              onEnter: (_) => setState(() {}),
              onExit: (_) => setState(() {}),
              child: Text(
                title,
                style: TextStyle(
                  color: Color.fromARGB(255, 25, 90, 100),
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromARGB(255, 105, 170, 180),
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
