//
//  BrailleViewController.m
//  Braillev4
//
//  Created by Brown, Melissa on 4/16/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import "BrailleViewController.h"
#import "BrailleView.h"
#import <AVFoundation/AVFoundation.h>

@interface BrailleViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer; //VoiceOver interference recognizer

@end

@implementation BrailleViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    self.view = [[BrailleView alloc] initWithFrame:frame];
    self.isAccessibilityElement = NO;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ignoreTaps)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = YES;
    
}

- (void)ignoreTaps {
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:@"Please retry, tap slower"];
    [syn speakUtterance:avsu];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self.view addSubview:[[BrailleView alloc] initWithFrame:self.view.bounds]];
}

/*- (void)setDetectedNumber:(NSInteger)detectedNumber {
    _detectedNumber = detectedNumber;
} */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
