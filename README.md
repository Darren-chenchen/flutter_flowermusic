# 阅读之前

### 1、[部分截图](https://www.jianshu.com/p/ce011acad64e)


![()](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.151.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.18.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.21.png)
![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-06%20at%2018.23.25.png)


### 2、[Vue项目请点击查看](https://github.com/Darren-chenchen/flowermusic_vue_github)




# 安卓请扫码下载体验，ios没有证书，无法下载。

![](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-05-07%20%E4%B8%8A%E5%8D%889.14.20.png)


# 项目结构

![(logo)](https://raw.githubusercontent.com/Darren-chenchen/flutter_flowermusic/master/screenShots/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-05-06%20%E4%B8%8B%E5%8D%888.29.23.png)

# 该项目的特点

### 1、使用mvvm架构编写。  [MVVM架构在Flutter中的简单实践](https://www.jianshu.com/p/43eb17163468)
### 2、Provide和RxDart 的使用，详细请参考 [Flutter | 状态管理特别篇 —— Provide](https://juejin.im/post/5c6d4b52f265da2dc675b407)

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

# 最后

### 1、建议大家把重点放在项目加架构的优化上面(mvvm)。

### 2、该项目只供学习交流使用，严禁用于商业用途.....