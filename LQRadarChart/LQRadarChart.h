//
//  LQRadarChart.h
//  LQRadarChart
//
//  Created by LiQuan on 16/7/14.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQRadarChart;

@protocol LQRadarChartDataSource <NSObject>

- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart;
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart;
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart;
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row;
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section;

@end

@protocol LQRadarChartDelegate <NSObject>

- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart;
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart;
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step;
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart;

@end


@interface LQRadarChart : UIView

- (instancetype)initWithFrame:(CGRect)frame
 NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak)id<LQRadarChartDataSource>dataSource;
@property (nonatomic, weak)id<LQRadarChartDelegate>delegate;

@property(nonatomic,assign) CGFloat radius;
@property(nonatomic,assign) CGFloat minValue;
@property(nonatomic,assign) CGFloat maxValue;

@property(nonatomic,assign) BOOL showPoint;
@property(nonatomic,assign) BOOL showBorder;
@property(nonatomic,assign) BOOL fillArea;
@property(nonatomic,assign) BOOL clockwise;
@property(nonatomic,assign) BOOL autoCenterPoint;

@property(nonatomic,assign) CGPoint centerPoint;

- (void)reloadData;

@end
