import 'dart:io';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/screens/prescription/widget/image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({Key key}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  List<String> prescription = [];
  var _image;

  Future camaraImage() async {
    PickedFile image = (await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 400, imageQuality: 50));

    setState(() {
      _image = File(image.path);
    });
    uploadProfilePicture(context, _image.path);
    Navigator.pop(context);
  }

  Future galleryImage() async {
    PickedFile image = (await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 1200,
        imageQuality: 80));

    setState(() {
      _image = File(image.path);
    });
    uploadProfilePicture(context, _image.path);
    Navigator.pop(context);
  }

  uploadProfilePicture(BuildContext context, String path) async {
    // upload the image
    // Navigator.pop(context);
    prescription.add(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'prescription'.tr),
      body: prescription.isEmpty
          ? Container(
              child: Center(
                child: Text(
                  'Upload Prescription',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              itemCount: prescription.length,
              itemBuilder: (contyext, index) {
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageView(
                        path: prescription[index],
                      ),
                    ),
                  ),
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: EdgeInsets.all(4.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(prescription[index]),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imageBottomDialog(context, camaraImage, galleryImage);
        },
        child: Icon(
          Icons.upload,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<String> imageBottomDialog(BuildContext context, Function() cameraOnTap,
          Function() galleryOnTap) =>
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          topRight: const Radius.circular(8.0))),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 0.0, right: 12.0, bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Upload your prescription',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          right: 16,
                        ),
                        child: Wrap(
                          direction: Axis.horizontal,
// spacing: 12.0,
                          children: [
                            SizedBox(width: 20),
                            _getImage(onTap: cameraOnTap, title: 'Camera'),
                            SizedBox(width: 30),
                            _getImage(onTap: galleryOnTap, title: 'Gallery'),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                );
              },
            );
          });
  _getImage({@required String title, @required Function() onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              border:
                  Border.all(width: 0.2, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Center(
              child: Icon(
                title == 'Gallery' ? Icons.insert_photo : Icons.camera,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
