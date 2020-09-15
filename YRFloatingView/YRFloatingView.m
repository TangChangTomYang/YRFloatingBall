//
//  YRFloatingView.m
//  YRFloatingView
//
//  Created by edz on 2020/9/14.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "YRFloatingView.h"

@interface UIView (RectRoundCorner)
  
@end
  
@implementation UIView (RectRoundCorner)

-(CGFloat)selfHeight{
    return self.frame.size.height;
}

-(CGFloat)selfWidth{
    return self.frame.size.width;
}

-(CGFloat)rectRoundRadius{
    CGFloat radius = ([self selfHeight] > [self selfWidth] ?  [self selfWidth] : [self selfHeight]) * 0.5;
    return radius;
}

-(CGSize)rectRoundSize{
    return CGSizeMake([self rectRoundRadius], [self rectRoundRadius]);
}



- (void)setCornerOnTop {
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:[self rectRoundSize]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnRight {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:[self rectRoundSize]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnLeft {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:[self rectRoundSize]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

 
- (void)setCornerOnBottom {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:[self rectRoundSize]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setAllCorner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:[self rectRoundRadius]];
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

 
@implementation YRFloatingView

 
static YRFloatingView *_floatingBall;
+ (void)showAtView:(UIView *)view {
    CGRect rect = CGRectMake(0.f, 200.f, 124.f, 64.f);
    if (!_floatingBall) {
        _floatingBall = [[YRFloatingView alloc] initWithFrame:rect];
    }
    
    
     
    if (!_floatingBall.superview) {
        _floatingBall.frame = rect;
        [view addSubview:_floatingBall];
        [view bringSubviewToFront:_floatingBall];
        
        CGFloat floatX = _floatingBall.frame.origin.x;
        CGFloat floatW = _floatingBall.frame.size.width;
        CGFloat viewW = view.frame.size.width;
        
        if (floatX <= 0) {
            [_floatingBall setCornerOnRight];
        }
        else if(floatX + floatW >= viewW){
            [_floatingBall setCornerOnLeft];
        }
        else{
            [_floatingBall setAllCorner];
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.layer.contents = (__bridge id)[UIImage imageNamed:@"Btn"].CGImage;
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
