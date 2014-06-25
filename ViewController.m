//
//  ViewController.m
//  Fractions
//
//  Created by Dunahee, Jacob Roger on 2/12/14.
//  Copyright (c) 2014 Dunahee, Jacob Roger. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "CrossMultiplication.h"
#import "BrailleViewController.h"
#import "BrailleInput.h"
#import "AppDelegate.h"

@interface ViewController ()

@property(nonatomic, weak)IBOutlet UIView *slash1;
@property(nonatomic, weak)IBOutlet UIView *slash2;
//@property(nonatomic, weak)IBOutlet UIButton *crossMult;
@property (nonatomic, strong) IBOutlet UITextView *n1Braille;
@property (nonatomic, strong) IBOutlet UITextView *n2Braille;
@property (nonatomic, strong) IBOutlet UITextView *d1Braille;
@property (nonatomic, strong) IBOutlet UITextView *d2Braille;
@property (nonatomic) NSInteger n1Value;
@property (nonatomic) NSInteger n2Value;
@property (nonatomic) NSInteger d1Value;
@property (nonatomic) NSInteger d2Value;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _appDelegate = [UIApplication sharedApplication].delegate;
//    self.notificationCenter = [NSNotificationCenter defaultCenter];
//    [self.notificationCenter addObserver:self selector:@selector(voiceOverFinishedSpeaking:) name:UIAccessibilityAnnouncementKeyStringValue object:nil];
    BrailleInput *b = [[BrailleInput alloc] initWithFrame:self.view.bounds];
    b.delegate = self;
    [b setTimeoutSeconds:[self loadPreferences]];
    _n1Braille.accessibilityTraits = UIAccessibilityTraitNone;
    _n2Braille.accessibilityTraits = UIAccessibilityTraitNone;
    _d1Braille.accessibilityTraits = UIAccessibilityTraitNone;
    _d2Braille.accessibilityTraits = UIAccessibilityTraitNone;
//    _n1Braille.accessibilityHint = @"";
    
//    _n1Braille.accessibilityValue = @"";

    
    _n1Braille.inputView = b;
    _n2Braille.inputView = b;
    _d1Braille.inputView = b;
    _d2Braille.inputView = b;
    
   

    
 //   NSArray *array = [self.navigationController viewControllers];
    
 /*   UISwipeGestureRecognizer *diagDownRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(crossMultiplyRight:)];
    [diagDownRight setDirection:UISwipeGestureRecognizerDirectionDown + UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:diagDownRight];
    
    UISwipeGestureRecognizer *diagDownLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(crossMultiplyLeft:)];
    [diagDownLeft setDirection:UISwipeGestureRecognizerDirectionDown + UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:diagDownLeft];
*/
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)voiceOverFinishedSpeaking:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __FUNCTION__);
    self.view.accessibilityElementsHidden = YES;
    [(BrailleInput *)textView.inputView startPoints:textView];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __FUNCTION__);
    self.view.accessibilityElementsHidden = NO;
    return YES;
}


- (void)setNumberArray:(NSMutableArray *)numberArray forTextView:(UITextView *)textView {
    NSLog(@"%s", __FUNCTION__);
    NSInteger detectedNumber = 0;
    NSString *numberAsString;
    switch (numberArray.count) {
        case 1:
            detectedNumber = [numberArray[0] integerValue];
            numberAsString = [NSString stringWithFormat:@"%@", numberArray[0]];
            NSLog(@"number: %ld, string: %@", (long)detectedNumber, numberAsString);
            break;
        case 2:
            numberAsString = [NSString stringWithFormat:@"%@%@", numberArray[0], numberArray[1]];
            detectedNumber = [numberAsString integerValue];
            NSLog(@"number: %ld, string: %@", (long)detectedNumber, numberAsString);
            break;
        case 3:
            numberAsString = [NSString stringWithFormat:@"%@%@%@", numberArray[0], numberArray[1], numberArray[2]];
            detectedNumber = [numberAsString integerValue];
            NSLog(@"number: %ld, string: %@", (long)detectedNumber, numberAsString);
        default:
            numberAsString = @"No number entered";
            break;
    }
    if (textView == _n1Braille) {
        _n1Value = detectedNumber;
        _n1Braille.accessibilityLabel = [NSString stringWithFormat:@"%@", numberAsString];
    } else if (textView == _n2Braille) {
        _n2Value = detectedNumber;
        _n2Braille.accessibilityLabel = [NSString stringWithFormat:@"%@", numberAsString];
    } else if (textView == _d1Braille) {
        _d1Value = detectedNumber;
        _d1Braille.accessibilityLabel = [NSString stringWithFormat:@"%@", numberAsString];
    } else if (textView == _d2Braille) {
        _d2Value = detectedNumber;
        _d2Braille.accessibilityLabel = [NSString stringWithFormat:@"%@", numberAsString];
    }
}

- (NSTimeInterval)loadPreferences {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:TIMEOUT_KEY];
}

/*-(void)crossMultiplyRight:(UISwipeGestureRecognizer *)recognizer{

    
    NSInteger product1 = _n1*_d2;

    
    if(_numerator1.accessibilityElementIsFocused){
       NSLog(@"crossMultiply1 = %ld", (long) product1);
        
        NSString *crossMult1 = [NSString stringWithFormat:@"The product of your cross multiplication is %ld", (long) product1];
        
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:crossMult1];
        [av speakUtterance:utterance];
    
}
}

-(void)crossMultiplyLeft :(UISwipeGestureRecognizer *)recognizer{
    
    
    int product1 = _n2*_d1;
    
    
    if(_numerator2.accessibilityElementIsFocused){
        NSLog(@"crossMultiply1 = %i", product1);
        
        NSString *crossMult1 = [NSString stringWithFormat:@"The product of your cross multiplication is %i", product1];
        
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:crossMult1];
        [av speakUtterance:utterance];
        
    }
} */

/*-(IBAction)goToCrossMult{
    [self.navigationController pushViewController:[[CrossMultiplication alloc]initWithNibName:@"CrossMultiplication" bundle:nil] animated:YES];
}*/









@end
