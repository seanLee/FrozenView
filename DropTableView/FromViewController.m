//
//  ViewController.m
//  DropTableView
//
//  Created by Sean on 2018/9/18.
//  Copyright © 2018年 private. All rights reserved.
//

#import "FromViewController.h"
#import "ToViewController.h"
#import "TransitionManager.h"

@interface FromViewController ()

@end

@implementation FromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *goBtn = [UIButton new];
    [goBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
    [goBtn sizeToFit];
    goBtn.center = self.view.center;
    [self.view addSubview:goBtn];
}

- (void)goAction {
    ToViewController *to = [ToViewController new];
    
    to.modalPresentationStyle = UIModalPresentationCustom;
    to.transitioningDelegate = [TransitionManager sharedManager];
    [self presentViewController:to animated:true completion:nil];
}

@end
