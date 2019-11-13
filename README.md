 
# 备注：

### 2019年谷歌推出Provider，代替 Provide 成为官方推荐的状态管理方式，Provide已经不再维护，所有项目已经逐渐替换成了Provider，项目默认分支是provider，可下载该分支查看。
 
# 阅读之前

### 1、部分截图


![()](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.151.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.18.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.21.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.25.png)




# 安卓请扫码下载体验，ios没有证书，无法下载。

![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-05-07%20%E4%B8%8A%E5%8D%889.14.20.png)


# 项目结构

![(logo)](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-05-06%20%E4%B8%8B%E5%8D%888.29.23.png)

# 该项目的特点

### 1、使用mvvm架构编写。  [MVVM架构在Flutter中的简单实践](https://www.jianshu.com/p/43eb17163468)
### 2、Provider和RxDart 的使用


# 部分封装介绍

### 1、refresh组件：刷新组件是在pull_to_refresh的基础上进行的再次封装，该库本身是存在一些问题的，所以就自己改了一下使用。希望该库持续更新，还有其他的刷新库，这里就不详细说了。主要是我们在使用时最好能够读懂别人的组件库的代码，这样才能更好的解决问题。也是一种学习方式。[pull__to__refresh](https://github.com/peng8350/flutter_pulltorefresh)

### 2、OpacityTapWidget组件：OpacityTapWidget组件解决了2个问题：

1）点击效果：点击时child有一个透明度的变化

2）点击的热区问题： OpacityTapWidget内部设置padding增加了点击的热区。

```
new OpacityTapWidget(
    onTap: () {
        Navigator.of(context).pop();
    },
    child: new Icon(Icons.close, color: Colors.white,size: 27,),
)
```

### 3、TapWidget组件：和OpacityTapWidget不一样的是TapWidget点击的效果是背景颜色的变化。

# 部分第三方库的封装与介绍

### 1.dio 网络请求封装: [Dio](https://github.com/flutterchina/dio/blob/master/README-ZH.md)

- Dio初始化

```
dio = new Dio()
      ..options = BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: 30000,
          receiveTimeout: 30000)
      ..interceptors.add(HeaderInterceptor());
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); 
```

- 拦截器

```
class HeaderInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    final token = AppConfig.userTools.getUserToken();
    if (token != null && token.length > 0) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer' + ' ' + token);
    }
//    if (options.uri.path.indexOf('api/user/advice/Imgs') > 0 || options.uri.path.indexOf('api/user/uploadUserHeader') > 0) { // 上传图片
//      options.headers.putIfAbsent('Content-Type', () => 'multipart/form-data');
//      print('上传图片');
//    } else {
//    }
//    options.headers.putIfAbsent('Content-Type', () => 'application/json;charset=UTF-8');

    return super.onRequest(options);
  }
}
```

### 2. [rxdart](https://github.com/ReactiveX/rxdart)

- 属性监听

```
方式1：
final subjectMore = new BehaviorSubject<bool>.seeded(false);
方式2：
final subjectMore = new BehaviorSubject<bool>();

subjectMore.value = false
_provide.subjectMore.listen((hasMore) {
});
```
方式1与方式2的不同是，方式1再初始化时就会触发，监听者会在初始化时监听到false参数。
  
### 3.flutter_svg 初始化svg格式的图片

```
new SvgPicture.asset("images/is_single.svg", width: 28, height: 28);
```

### 4.shared_preferences 数据存储

由于数据的存储和获取是异步的，但是在项目中使用同步的方法获取用户信息就很是有必要，所以该项目再初始化之前就初始化了shared_preferences，解决了在项目中使用同步的方法获取用户信息这个问题。

```
void main() async {
  /// 先初始化shared_preferences
  await AppConfig.init();
  runApp(MyApp());
}
```

# 最后

### 1、建议大家把重点放在项目架构的优化上面(mvvm)。

### 2、该项目只供学习交流使用，严禁用于商业用途.....