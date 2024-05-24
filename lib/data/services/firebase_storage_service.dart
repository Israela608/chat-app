import 'package:chat_app/firebase_ref/references.dart';

class FirebaseStorageService {
  //Function that loads images from Firebase Storage
  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }

    try {
      // We get the reference or path of the image in Firebase Storage
      var urlRef = firebaseStorage
          // The name of the images folder in Firebase Storage
          .child('question_paper_images')
          // The name of the image file we want. We convert the name we are sending to lower case because all the images in the Firebase Storage are in lower cases
          .child('${imgName.toLowerCase()}.png');

      //Through the path, we get the download link
      var imgUrl = await urlRef.getDownloadURL();

      return imgUrl;
    } catch (e) {
      return null;
    }
  }
}
