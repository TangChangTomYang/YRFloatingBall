//
//  ViewController.m
//  YRFloatingView
//
//  Created by edz on 2020/9/14.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "ViewController.h"
#import "YRFloatingView.h"



@interface ViewController ()
@property (weak, nonatomic) IBOutlet YRFloatingView *container;

@property (weak, nonatomic) IBOutlet UIView *orangeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)btnClick:(id)sender {
    
    [YRFloatingView showAtView:self.container];
}


@end


