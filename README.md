# Dermatoloji Destek ve Bilgilendirme Mobil Uygulaması

Bu proje, kullanıcıların cilt hastalıkları hakkında bilgi alabileceği ve dermatologların teşhis sürecini kolaylaştırabilecek bir mobil uygulama geliştirmeyi amaçlamaktadır. Proje, iki ana bölümden oluşmaktadır:

1. **Dermatoloji Teşhis Destek Sistemi**: Dermatologların cilt hastalıklarını daha doğru bir şekilde teşhis edebilmesine yardımcı olmak.
2. **Kullanıcı Bilgilendirme ve Ürün Öneri Sistemi**: Kullanıcıların cilt hastalıkları hakkında bilgi almasını sağlamak ve uygun ürün önerilerinde bulunmak.
## Proje Yapısı

- `deritespit_flutter/`: Flutter mobil uygulama kodları.
- `deripython_api/`: Python API kodları.


## Kurulum

### Flutter Uygulaması

1. Flutter SDK'yı yükleyin: [Flutter Install](https://flutter.dev/docs/get-started/install)
2. `flutter_app` dizinine gidin:
    ```sh
    cd flutter_app
    ```
3. Gerekli paketleri yükleyin:
    ```sh
    flutter pub get
    ```
4. Uygulamayı çalıştırın:
    ```sh
    flutter run
    ```

### Python API

1. Python ve pip'i yükleyin.
2. `python_api` dizinine gidin:
    ```sh
    cd python_api
    ```
3. Gerekli bağımlılıkları yükleyin:
    ```sh
    pip install -r requirements.txt
    ```
4. API'yi çalıştırın:
    ```sh
    python app.py
    ```

## Kullanım

Uygulama açıldığında, kullanıcı cilt hastalıklarını tanımlamak için bir fotoğraf çekebilir veya mevcut bir fotoğrafı yükleyebilir.yüklenen fotoğraf remove.bg web sitesinde api bağlantısı ile arka görselin arka planında bulunan gürültüleri temizler ve ve bu şekilde hastalığın maksimum doğruluk oranı ile deri hastalığı tespitini gerçekleştirmeyi hedefler. Kullanıcı ayrıca tahmin edilen hastalık hakkında detaylı bilgi alır ve tespit edilen hastalığın önerilen ürünleri görüntler ve link bağlantısı ile ürünlere ulaşabilir.
