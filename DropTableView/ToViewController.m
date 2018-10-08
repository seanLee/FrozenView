//
//  ToViewController.m
//  DropTableView
//
//  Created by Sean on 2018/9/18.
//  Copyright © 2018年 private. All rights reserved.
//


#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kScreenBounds           [UIScreen mainScreen].bounds

#import "ToViewController.h"
#import "Masonry.h"
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JSPanGestureDirection) {
    JSPanGestureDirectionNone = 0,
    JSPanGestureDirectionLeft,
    JSPanGestureDirectionRight,
    JSPanGestureDirectionTop,
    JSPanGestureDirectionBottom
};

@interface ToViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *contentV;
@property (strong, nonatomic) UILabel *commentTipLbL;
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIButton *closeBtn;
@property (nonatomic, assign) BOOL frozen;
@property (nonatomic, assign) BOOL cancelGesture;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) JSPanGestureDirection direction;
@end

@implementation ToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _contentV = [UIView new];
    [self.view addSubview:_contentV];

    UIView *headerV = [UIView new];
    headerV.backgroundColor = [UIColor whiteColor];
    [_contentV addSubview:headerV];
    
    _closeBtn = [UIButton new];
    [_closeBtn setImage:[UIImage imageNamed:@"do_comment_close"] forState:UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageNamed:@"do_comment_close"] forState:UIControlStateHighlighted];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [headerV addSubview:_closeBtn];
    
    UIView *seperator = [UIView new];
    seperator.backgroundColor = [UIColor blackColor];
    [headerV addSubview:seperator];
    
    _commentTipLbL = [UILabel new];
    _commentTipLbL.textColor = [UIColor blackColor];
    _commentTipLbL.font = [UIFont systemFontOfSize:17.f];
    [headerV addSubview:_commentTipLbL];
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = false;
        tableView.backgroundColor = [UIColor redColor];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_contentV addSubview:tableView];
        tableView;
    });
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGesture.delegate = self;
    [_contentV addGestureRecognizer:_panGesture];
    
    {
        [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20.f);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentV);
            make.width.equalTo(self.contentV);
            make.height.mas_equalTo(44.f);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(headerV);
            make.width.mas_equalTo(44.f);
        }];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(headerV);
            make.height.mas_equalTo(.3f);
        }];
        
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerV.mas_bottom);
            make.left.right.bottom.equalTo(self.contentV);
        }];
        
        [_commentTipLbL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerV);
        }];
    }
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row + 1).stringValue;
    return cell;
}

#pragma mark - Action
- (void)closeAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:_contentV];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.frozen) return;
            
            self.cancelGesture = false;
            
            CGPoint velocity = [pan velocityInView:_contentV];
            
            CGFloat absX = fabs(velocity.x);
            CGFloat absY = fabs(velocity.y );
            CGFloat bigger = MAX(absX, absY);
            if (bigger == absX) {
                self.direction = velocity.x > 0 ? JSPanGestureDirectionRight : JSPanGestureDirectionLeft;
            } else {
                self.direction = velocity.y > 0 ? JSPanGestureDirectionBottom : JSPanGestureDirectionTop;
            }
            
            if (self.direction == JSPanGestureDirectionBottom && self.myTableView.contentOffset.y == 0) {
                self.myTableView.scrollEnabled = false;
                self.frozen = false;
            } else if ((self.direction == JSPanGestureDirectionTop && self.myTableView.contentOffset.y != 0) ||
                       (self.direction == JSPanGestureDirectionBottom && self.myTableView.contentOffset.y != 0)) {
                self.myTableView.scrollEnabled = true;
                self.frozen = true;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.frozen) return;
            if (self.cancelGesture) {
                [self _resetTableview];
                return;
            }

            self.myTableView.scrollEnabled = (self.direction == JSPanGestureDirectionTop);

            if (self.direction == JSPanGestureDirectionLeft ||
                self.direction == JSPanGestureDirectionRight)  { //X方向的位移
                CGRect frame = _contentV.frame;
                frame.origin.x = MIN(MAX(0, translation.x), kScreenWidth);
                _contentV.frame = frame;
                
            } else {
                CGRect frame = _contentV.frame;
                frame.origin.y = MIN(MAX(20, translation.y), kScreenHeight);
                _contentV.frame = frame;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (self.cancelGesture) {
                [self _resetTableview];
                self.frozen = false;
                self.myTableView.scrollEnabled = true;
                self.direction = JSPanGestureDirectionNone;
                return;
            }
            
            if (self.direction == JSPanGestureDirectionLeft ||
                self.direction == JSPanGestureDirectionRight) {
                if (translation.x >= kScreenWidth / 3.f) {
                    [UIView animateWithDuration:.2f animations:^{
                        CGRect frame = self.contentV.frame;
                        frame.origin.x = kScreenWidth;
                        self.contentV.frame = frame;
                    } completion:^(BOOL finished) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                } else {
                    [UIView animateWithDuration:.2f animations:^{
                        CGRect frame = self.contentV.frame;
                        frame.origin.x = 0;
                        self.contentV.frame = frame;
                    }];
                }
            } else {
                if (translation.y >= kScreenHeight / 3.f) {
                    [UIView animateWithDuration:.2f animations:^{
                        CGRect frame = self.contentV.frame;
                        frame.origin.y = kScreenHeight;
                        self.contentV.frame = frame;
                    } completion:^(BOOL finished) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                } else {
                    [UIView animateWithDuration:.2f animations:^{
                        CGRect frame = self.contentV.frame;
                        frame.origin.y = 20;
                        self.contentV.frame = frame;
                    }];
                }
            }
        }
            break;
        default:
            break;
    }
    _myTableView.scrollEnabled = true;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return true;
    }
    return false;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.closeBtn];
    if (location.x <= 44.f && location.y <= 44.f) return false;
    
    return true;
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.myTableView.contentOffset.y <= 0) {
        self.cancelGesture = true;
        self.myTableView.contentOffset = CGPointMake(self.myTableView.contentOffset.x, 0);
        [self _resetGesture];
    }
}

#pragma mark - Private
- (void)_resetTableview {
    CGRect frame = self.contentV.frame;
    frame.origin.x = 0;
    frame.origin.y = 20.f;
    self.contentV.frame = frame;
}

- (void)_resetGesture {
    [self.contentV removeGestureRecognizer:_panGesture];
    [self.contentV addGestureRecognizer:_panGesture];
}
@end
