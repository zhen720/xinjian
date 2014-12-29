//
//  ViewController.m
//  翻页动画
//
//  Created by lkk on 14-12-26.
//  Copyright (c) 2014年 lkk. All rights reserved.
//

#import "ViewController.h"
#import "TurnPageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TurnPageView *turnPageView = [TurnPageView tutnPageViewWithFrame:CGRectMake(30, 100, 260, 260) image:[UIImage imageNamed:@"boat.jpg"]];
    [self.view addSubview:turnPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
