//
//  TransitionManager.m
//  Sport_Plus
//
//  Created by Sean on 2018/9/14.
//  Copyright © 2018年 animation. All rights reserved.
//

#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kScreenBounds           [UIScreen mainScreen].bounds

#import "TransitionManager.h"
#import "InteractionManager.h"

@interface TransitionManager ()
@property (assign, nonatomic) BOOL commenting;
@end

@implementation TransitionManager
+ (instancetype)sharedManager {
    static TransitionManager *_sharedObj = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedObj = [[TransitionManager alloc] init];
    }) ;
    return _sharedObj;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.commenting = true;
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.commenting = false;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .35f;
}

static const CGFloat duration = 0.30f;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *source, *destination;
    UIView *container = transitionContext.containerView;
    
    if (self.commenting) {
        destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        destination.view.backgroundColor = [UIColor clearColor];
        
        UIView *placeholder = [UIView new];
        placeholder.frame = kScreenBounds;
        placeholder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
        
        [container addSubview:placeholder];
        [container addSubview:destination.view];
        
        destination.view.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             placeholder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
                             destination.view.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             destination.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
                             [placeholder removeFromSuperview];
                             [transitionContext completeTransition:true];
                         }];
        
    } else {
        source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        source.view.backgroundColor = [UIColor clearColor];
        
        destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];;
        
        UIView *placeholder = [UIView new];
        placeholder.frame = kScreenBounds;
        placeholder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        
        [container insertSubview:placeholder atIndex:0];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.9
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             placeholder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
                             source.view.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
                         } completion:^(BOOL finished) {
                             [placeholder removeFromSuperview];
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                             if (!transitionContext.transitionWasCancelled) [destination setNeedsStatusBarAppearanceUpdate];
                             if (transitionContext.transitionWasCancelled) source.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
                         }];
    }
}

@end
