//
//  ViewController.m
//  LQRadarChart
//
//  Created by LiQuan on 16/7/14.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "ViewController.h"
#import "LQRadarChart.h"

@interface ViewController ()<LQRadarChartDataSource,LQRadarChartDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat w = self.view.frame.size.width;
    LQRadarChart * chart = [[LQRadarChart alloc]initWithFrame:CGRectMake(0, 0, w, w)];
    chart.center = self.view.center;
    chart.radius = w / 3;
    chart.delegate = self;
    chart.dataSource = self;
    [chart reloadData];
    [self.view addSubview:chart];
}

- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart
{
    return 5;
}
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart
{
    return 6;
}
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart
{
    return 2;
}
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row
{
    return [NSString stringWithFormat:@"NO.%ld",row];
}
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section
{
    if (section == 0 ){
        return (CGFloat)(MAX(MIN(row + 1, 4), 3));
    } else {
        return 3;
    }
}



- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return [UIColor blackColor];

}
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart
{
    return [UIColor colorWithRed:0.337 green:0.847 blue:0.976 alpha:1];

}
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step
{
    UIColor * color = [UIColor whiteColor];
    switch (step) {
        case 1:
            color = [UIColor colorWithRed:0.545 green:0.906 blue:0.996 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:0.706 green:0.929 blue:0.988 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.831 green:0.949 blue:0.984 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:0.922 green:0.976 blue:0.998 alpha:1];
            break;
            
        default:
            break;
    }
    return color;
}
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section
{
    if (section == 0) {
        return [UIColor colorWithRed:1 green:0.867 blue:0.012 alpha:0.4];
    }else{
        return [UIColor colorWithRed:0 green:0.788 blue:0.543 alpha:0.4];
    }
}
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section
{
    if (section == 0) {
        return [UIColor colorWithRed:1 green:0.867 blue:0.012 alpha:0.4];
    }else{
        return [UIColor colorWithRed:0 green:0.788 blue:0.543 alpha:0.4];
    }

}
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return [UIFont systemFontOfSize:11];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
