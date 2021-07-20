import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FireStorage {
  Future<String> postImage(Asset imageFile) async {
    String url;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('flutter').child(fileName);
    UploadTask uploadTask = reference.putData(
        (await imageFile.getByteData(quality: 25)).buffer.asUint8List());
    await uploadTask.whenComplete(() async {
      url = await reference.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }
}
