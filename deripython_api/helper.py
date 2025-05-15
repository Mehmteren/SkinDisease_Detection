import cv2
import numpy as np
import tensorflow as tf
import io
from PIL import Image

model_path = r'C:\Users\Pc\Desktop\bitkitespitpy\models\inceptionv3_model'

try:
    model = tf.saved_model.load(model_path)

    model_fn = model.signatures['serving_default']

    print(model.signatures['serving_default'])

except Exception as e:
    print(f"Model yükleme hatası: {e}")


def classify_plant(image_file):
    try:
        print("Görüntü işleme başladı.")
        image = Image.open(image_file)
        image = image.convert('RGB')
        image = np.array(image)
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        image = cv2.resize(image, (299, 299))
        image = img_to_array_opencv(image)
        image = preprocess_input_opencv(image)
        print("Görüntü başarıyla hazırlandı.")

        # Sınıflandırma işlemi
        print("Model tahmin işlemi başladı.")
        output = model_fn(tf.constant(image))
        predictions = output['dense_2']
 
        print(f"Predictions: {predictions}")

        class_index = np.argmax(predictions)
        confidence = predictions[0][class_index]

        class_names = ['chickenPox', 'Meales', 'MonkeyPox', 'Healty']

        class_name = class_names[class_index]
        print(f"Sınıflandırma tamamlandı: {class_name} ({confidence:.2f})")
        return class_name, confidence

    except Exception as e:
        print(f"Sınıflandırma hatası: {e}")
        return None, None


def img_to_array_opencv(image): 
    img_array = np.array(image, dtype=np.float32)
    return img_array 

def preprocess_input_opencv(image):
    image /= 255.0
    image = np.expand_dims(image, axis=0)  
    return image
