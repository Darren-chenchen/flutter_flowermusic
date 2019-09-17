import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class AdviceProvide extends BaseProvide {

  final MineRepo _repo = MineRepo();

  String _advice = '';
  String get advice => _advice;
  set advice(String advice) {
    _advice = advice;
  }

  String _contact = '';
  String get contact => _contact;
  set contact(String contact) {
    _contact = contact;
  }

  List<String> _imgArr = [];
  List<String> get imgArr => _imgArr;
  set imgArr(List<String> arr) {
    _imgArr = arr;
    print(_imgArr);
    notify();
  }

  notify() {
    notifyListeners();
  }

  Observable adviceSubmit() {
    var body = {
      'content': this.advice,
      'phone': this.contact,
      'imgs': this.imgArr
    };
    return _repo
        .adviceSubmit(body)
        .doOnData((result) {
          if (result.success) {
            Fluttertoast.showToast(
                msg: "提交成功",
                gravity: ToastGravity.CENTER
            );
          }
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  // 上传图片
  Observable uploadImages(body) {
    return _repo
        .uploadImg(body)
        .doOnData((result) {
          if (result.success) {
            this.imgArr.clear();
            var arr = result.data as List;
            this.imgArr.addAll(arr.map((map) => AppConfig.baseUrl + map['imageUrl']));
            this.imgArr = this.imgArr;
          }
    })
        .doOnError((e, stacktrace) {
      Fluttertoast.showToast(
          msg: "上传失败",
          gravity: ToastGravity.CENTER
      );
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
}