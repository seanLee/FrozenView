//
//  InteractiveTransitionManager.m
//  Sport_Plus
//
//  Created by Sean on 2018/9/14.
//  Copyright © 2018年 animation. All rights reserved.
//

#import "InteractionManager.h"

@interface InteractionManager ()
@property (strong, nonatomic) UIView *target;
@end

@implementation InteractionManager
- (void)addGesture:(UIView *)toView {
    self.target = toView;
    
    UIScreenEdgePanGestureRecognizer *leftEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    leftEdgePan.edges = UIRectEdgeLeft;
    [toView addGestureRecognizer:leftEdgePan];
    
    UIScreenEdgePanGestureRecognizer *topEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    topEdgePan.edges = UIRectEdgeTop;
    [toView addGestureRecognizer:topEdgePan];
}

#pragma mark - Action
- (void)edgePan:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGPoint translate = [recognizer translationInView:self.target];
    CGFloat progress = fabs(translate.x) / (self.target.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.dismissBlock) self.dismissBlock();
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 完成或者取消过渡
            if (progress > 0.4) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}
@end
