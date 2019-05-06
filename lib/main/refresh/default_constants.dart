import 'package:flutter/widgets.dart';
import 'package:flutter_flowermusic/main/refresh/smart_refresher.dart';

/*
    Author: Jpeng
    Email: peng8350@gmail.com
    createTime:2018-05-17 10:39
 */


typedef void OnRefresh();
typedef void FooterRefresh();
typedef void OnOffsetChange(bool up, double offset);
typedef Widget IndicatorBuilder(BuildContext context, RefreshStatus mode);

const int default_completeDuration = 800;

const double default_refresh_triggerDistance = 100.0;

const double default_load_triggerDistance = 15.0;

const double default_height = 60.0;

const double default_headerExceed = 100.0;

const double default_footerExceed = 100.0;

const bool default_AutoLoad = true;

const bool default_enablePullDown = true;

const bool default_enablePullUp = false;

const bool default_BottomWhenBuild = true;

const bool default_enableOverScroll = true;

const int spaceAnimateMill=300;

const double minSpace = 0.000001;