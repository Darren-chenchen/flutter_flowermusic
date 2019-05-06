
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CommonUtil {
  static padNum(String pad) {
    var num = '${(double.parse(pad) / 60).toInt()}';
    var len = num.toString().length;
    while (len < 2) {
      num = '0' + num;
      len++;
    }
    return num;
  }

  static dealDuration(String duration) {
    var ge = '${(double.parse(duration) % 60).toInt()}';
    var miao = '00';
    if (ge.length == 1) {
      miao = '0' + ge;
    } else {
      miao = ge;
    }
    return padNum(duration) + ':$miao';
  }

  static isPassword(String password) {
    return new RegExp(r'^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$').hasMatch(password);
  }

  static isEmail(String email) {
    return new RegExp(r'^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$').hasMatch(email);
  }

  // 处理图片
  static Future<FormData> clickIcon(int count) async {
    FormData formData;
    List<UploadFileInfo> files = [];
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
          maxImages: count,
          enableCamera: true
      );
      if (resultList.length > 0) {
        for(int i = 0; i< resultList.length; i ++) {
          Asset asset = resultList[i];
          ByteData byteData = await asset.requestThumbnail(200, 200);
          List<int> imageData = byteData.buffer.asUint8List();

          //获得一个uuud码用于给图片命名
          final String uuid = Uuid().v1();
          //获得应用临时目录路径
          final Directory _directory = await getTemporaryDirectory();
          final Directory _imageDirectory =
          await new Directory('${_directory.path}/image/')
              .create(recursive: true);
          var path = _imageDirectory.path;
          print('本次获得路径：${_imageDirectory.path}');
          //将压缩的图片暂时存入应用缓存目录
          File imageFile = new File('${path}originalImage_$uuid.png')
            ..writeAsBytesSync(imageData);
          print(imageFile.path);
          var file = new UploadFileInfo(imageFile, '${path}originalImage_$uuid.png', contentType: ContentType.parse("image/png"));
          files.add(file);
        };
        FormData formData = new FormData.from({
          'file': files
        });
        return formData;
      } else {
        return formData;
      }
    } catch (e) {
      print(e.message);
    }
  }
}