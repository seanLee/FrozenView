//
//  InteractiveTransitionManager.h
//  Sport_Plus
//
//  Created by Sean on 2018/9/14.
//  Copyright © 2018年 animation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionManager : UIPercentDrivenInteractiveTransition
@property (copy, nonatomic) void (^dismissBlock)(void);

- (void)addGesture:(UIView *)toView;
@end
