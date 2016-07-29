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
@required
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart;
/**
 *  输出多边形的形状. 3为三边形, 4为正方形
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)maxValueForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param row        <#row description#>
 *  @param section    <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section;
@optional
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param row        <#row description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)minValueForRadarChart:(LQRadarChart *)radarChart;
@end

@protocol LQRadarChartDelegate <NSObject>
@optional
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfSeparateLineForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param step       <#step description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param step       <#step description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param section    <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param section    <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *
 *  @return <#return value description#>
 */
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart;
/**
 *  <#Description#>
 *
 *  @param radarChart <#radarChart description#>
 *  @param index      <#index description#>
 */
- (void)radarChart:(LQRadarChart *)radarChart didSelectedItemAtIndex:(NSInteger)index;
/**
 *  <#Description#>
 *
 *  @param row  <#row description#>
 *  @param rect <#rect description#>
 *
 *  @return <#return value description#>
 */
- (CGRect)titleRectForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row currentRect:(CGRect)rect;
@end

@interface LQRadarChart : UIView

@property (nonatomic, weak)id<LQRadarChartDataSource>dataSource;
@property (nonatomic, weak)id<LQRadarChartDelegate>delegate;

@property(nonatomic, assign) CGFloat radius;

@property(nonatomic, assign, readonly) NSInteger numberOfStep;

@property(nonatomic, assign, readonly) NSInteger numberOfRow;

@property(nonatomic, assign, readonly) NSInteger numberOfSection;

@property(nonatomic, assign) BOOL showPoint;

@property(nonatomic, assign) BOOL fillArea;

@property(nonatomic, assign) BOOL clockwise;

@property(nonatomic, assign) BOOL autoCenterPoint;

@property(nonatomic, assign) CGPoint centerPoint;

- (void)reloadData;

@end
