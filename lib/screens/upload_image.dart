import 'package:flutter/material.dart';
import 'package:flutter_assignment/helper/utils.dart';
import 'package:flutter_assignment/service/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadImageScreens extends StatefulWidget {
  const UploadImageScreens({Key key}) : super(key: key);

  @override
  _UploadImageScreensState createState() => _UploadImageScreensState();
}

class _UploadImageScreensState extends State<UploadImageScreens> {
  static const int MAX_IMAGE_LIMIT = 1;
  List<Asset> assetImages = <Asset>[];
  String uploadedImageUrl;
  bool isUploading;

  @override
  void initState() {
    super.initState();
    isUploading = false;
    uploadedImageUrl =
        'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Assignment"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              uploadedImageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => loadAssets(),
                child: Text(isUploading ? "Uploading" : "Select Image"))
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: MAX_IMAGE_LIMIT,
        enableCamera: true,
        selectedAssets: assetImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor:
              '#' + Colors.blue.toString().split('(0x')[1].split(')')[0],
          statusBarColor:
              '#' + Colors.blue[700].toString().split('(0x')[1].split(')')[0],
          actionBarTitle: "Select Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          lightStatusBar: true,
          selectionLimitReachedText:
              "Opps! You can select max two Image at once",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      // cprint(error);
    }

    if (resultList.length > 0) {
      setState(() {
        isUploading = true;
      });
      FireStorage().postImage(resultList[0]).then((value) {
        setState(() {
          uploadedImageUrl = value;
          isUploading = false;
        });
        showSnackBar(
            context, "Image is uploaded successfully in Firebase Storage");
      });
    }

    if (!mounted) return;
    setState(() {
      assetImages = resultList;
    });
  }
}
