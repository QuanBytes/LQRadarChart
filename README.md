# LQRadarChart

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/MrLQ/LQRadarChart/blob/master/LICENSE)
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

----

# 中文

LQRadarChart 是一个简单的可定制的雷达图

### Base

|基本概念|描述|演示|
|---|---|---|
|Step|背景多边形圈数, 最小值为1|![image](https://github.com/MrLQ/LQRadarChart/blob/master/demo1.png?raw=true)
|Row|多边形边数, 最小值为三|![image](https://github.com/MrLQ/LQRadarChart/blob/master/demo1.png?raw=true) 
|Section|同时展现数据组数|![image](https://github.com/MrLQ/LQRadarChart/blob/master/demo1.png?raw=true)

### LQRadarChartDataSource

通过 LQRadarChartDataSource 可以对 RadarChart 的 row,section,setp 进行设置, 并且获取每个 Section 的数据进行绘制

```
- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart;
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart;
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart;
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row;
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section;

```
### LQRadarChartDelegate

通过 LQRadarChartDelegate 可以对 RadarChart 的 UI 进行定制

```

- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart;
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart;
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step;
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart;

```

### LQRadarChart属性


```
@property(nonatomic,assign) CGFloat radius;
@property(nonatomic,assign) CGFloat minValue;
@property(nonatomic,assign) CGFloat maxValue;

@property(nonatomic,assign) BOOL showPoint;
@property(nonatomic,assign) BOOL showBorder;
@property(nonatomic,assign) BOOL fillArea;
@property(nonatomic,assign) BOOL clockwise;
@property(nonatomic,assign) BOOL autoCenterPoint;

@property(nonatomic,assign) CGPoint centerPoint;


```

----


/***  设置完成后需 `reload` ***/