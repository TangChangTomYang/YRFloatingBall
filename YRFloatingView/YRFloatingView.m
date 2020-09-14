//
//  YRFloatingView.m
//  YRFloatingView
//
//  Created by edz on 2020/9/14.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "YRFloatingView.h"

@interface UIView (RectCorner)
  
@end
  
@implementation UIView (RectCorner)

- (void)setCornerOnTop {
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(30.0f, 30.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnRight {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnLeft {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

 
- (void)setCornerOnBottom {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(30.0f, 30.0f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setAllCorner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:self.frame.size.height * 0.5];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setNoneCorner{
    self.layer.mask = nil;
}
  
@end


@interface YRFloatingView(){
    
    CGPoint lastPoint;      // point in superView
    CGPoint pointInSelf;    // point in self
    
}
@property (nonatomic, assign) CGRect  bFrame;
@end

#define fixSpace 160.f
@implementation YRFloatingView

 
static YRFloatingView *_floatingBall;
+ (void)showAtView:(UIView *)view {
    
    
    if (!_floatingBall) {
        _floatingBall = [[YRFloatingView alloc] initWithFrame:CGRectMake(0.f, 200.f, 60.f, 60.f)];
    }
    
    
     
    if (!_floatingBall.superview) {
        _floatingBall.frame = CGRectMake(0.f, 200.f, 60.f, 60.f);
        [view addSubview:_floatingBall];
        [view bringSubviewToFront:_floatingBall];
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        ///设置图片
        self.layer.contents = (__bridge id)[UIImage imageNamed:@"WebView_Minimize_Float_IconHL"].CGImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

-(void)translationToPoint:(CGPoint)point{
    CGRect frame = self.bFrame;
    CGFloat X = frame.origin.x + point.x;
    CGFloat Y = frame.origin.y + point.y;
    
    if (X < 0) {
        X = 0;
    }
    else if(X > self.superview.frame.size.width - self.frame.size.width){
        X = self.superview.frame.size.width - self.frame.size.width;
    }
    
    if (Y < 0) {
        Y = 0;
    }
    else if (Y > self.superview.frame.size.height - self.frame.size.height){
        Y = self.superview.frame.size.height - self.frame.size.height;
    }
    
    frame =  CGRectMake(X, Y, frame.size.width, frame.size.height);
    self.frame = frame;
}


-(void)panGestureAction:(UIPanGestureRecognizer *)pan{
   
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.bFrame = self.frame;
        [self setAllCorner];
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self];
        [self translationToPoint:translation];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint translation = [pan translationInView:self];
        [self translationToPoint:translation];
        if (self.frame.origin.x + self.frame.size.width / 2.0 < (self.superview.frame.size.width / 2.0)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                
                
            }completion:^(BOOL finished) {
                [self setCornerOnRight];
            }];
        }
        else{
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(self.superview.frame.size.width - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                
                
            }completion:^(BOOL finished) {
                [self setCornerOnLeft];
            }];
        }
        
    }
}



 


@end
