//
//  TransitionManager.h
//  Sport_Plus
//
//  Created by Sean on 2018/9/14.
//  Copyright © 2018年 animation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class InteractionManager;

@interface TransitionManager : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
+ (TransitionManager *)sharedManager;

@property (strong, nonatomic) InteractionManager *interaction;
@end
