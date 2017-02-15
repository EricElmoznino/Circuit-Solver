//
//  EEInfoViewController.m
//  CircuitSolver
//
//  Created by ERIC ELMOZNINO on 2015-07-02.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EEInfoViewController.h"

@interface EEInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;
@property (weak, nonatomic) IBOutlet UILabel *text4;
@property (weak, nonatomic) IBOutlet UILabel *text5;
@property (weak, nonatomic) IBOutlet UILabel *text6;

@end

@implementation EEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat screenHeight = self.view.bounds.size.height;
    
    //iPhone 4
    if (screenHeight == 480) {
        [self.text1 setFont:[self.text1.font fontWithSize:12.5]];
        [self.text2 setFont:[self.text2.font fontWithSize:12.5]];
        [self.text3 setFont:[self.text3.font fontWithSize:12.5]];
        [self.text4 setFont:[self.text4.font fontWithSize:12.5]];
        [self.text5 setFont:[self.text5.font fontWithSize:12.5]];
        [self.text6 setFont:[self.text6.font fontWithSize:12.5]];
        [self.mainTitle setFont:[self.mainTitle.font fontWithSize:14.5]];
    }
    
    //iPhone 6 or iPhone 6+ or iPhone 5
    else if (screenHeight == 568) {
        [self.text1 setFont:[self.text1.font fontWithSize:13.8]];
        [self.text2 setFont:[self.text2.font fontWithSize:13.8]];
        [self.text3 setFont:[self.text3.font fontWithSize:13.8]];
        [self.text4 setFont:[self.text4.font fontWithSize:13.8]];
        [self.text5 setFont:[self.text5.font fontWithSize:13.8]];
        [self.text6 setFont:[self.text6.font fontWithSize:13.8]];
        [self.mainTitle setFont:[self.mainTitle.font fontWithSize:16]];
    }
    
    //iPad or iPadMini
    else if (screenHeight == 1024 || screenHeight == 768) {
        [self.text1 setFont:[self.text1.font fontWithSize:25]];
        [self.text2 setFont:[self.text2.font fontWithSize:25]];
        [self.text3 setFont:[self.text3.font fontWithSize:25]];
        [self.text4 setFont:[self.text4.font fontWithSize:25]];
        [self.text5 setFont:[self.text5.font fontWithSize:25]];
        [self.text6 setFont:[self.text6.font fontWithSize:25]];
        [self.mainTitle setFont:[self.mainTitle.font fontWithSize:30]];
    }
}

@end
