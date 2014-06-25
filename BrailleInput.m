//
//  BrailleInput.m
//  BrailleKeyboardv1
//
//  Created by Brown, Melissa on 4/28/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import "TouchPoint.h"
#import "BrailleInput.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface BrailleInput()

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *startTimer;
@property (nonatomic, strong) AVSpeechSynthesizer *syn;
@property (nonatomic) BOOL beginRecording;
@property (nonatomic, strong) UITextView *activeTextView;
@property (nonatomic, strong) NSMutableArray *numbers;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;

@property (nonatomic) NSTimeInterval timeoutSeconds;

@end

@implementation BrailleInput {
@private
//NSTimeInterval timeoutSeconds;

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _points = [[NSMutableArray alloc] init];
        
        
       // timeoutSeconds = 1.5;
        
        self.backgroundColor = [UIColor redColor];
        //        self.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
        self.isAccessibilityElement = NO;
        self.userInteractionEnabled = YES;
        _syn = [[AVSpeechSynthesizer alloc] init];
        _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:_swipeRecognizer];
        
    }
    return self;
}

- (void)setTimeoutSeconds:(NSTimeInterval)timeoutSeconds {
    _timeoutSeconds = timeoutSeconds;
    NSLog(@"%f", _timeoutSeconds);
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe recognized");
    _syn = nil;
    [self.delegate setNumberArray:_numbers forTextView:_activeTextView];
     _beginRecording = NO;
     [_activeTextView resignFirstResponder];
}


- (void)beginRecordingPoints {
    NSLog(@"%s", __FUNCTION__);
    _beginRecording = YES;
    _syn = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:@"Start"];
    [_syn speakUtterance:avsu];
    _numbers = [[NSMutableArray alloc] init];
    [_startTimer invalidate], _startTimer = nil;
}

- (void)startPoints:(UITextView *)textView {
    if(_startTimer) {
        [_startTimer invalidate], _startTimer = nil;
    }
     _startTimer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(beginRecordingPoints) userInfo:nil repeats:NO];
    _activeTextView = textView;
}

- (void)addTouchPoint:(CGPoint)touch {
    TouchPoint *touchPoint = [[TouchPoint alloc] initWithX:touch.x andY:touch.y];
    if ([_points count] < 1 && !_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeoutSeconds target:self selector:@selector(checkPoints:) userInfo:nil repeats:NO];
        
        NSLog(@"timer set"); }
        else if (_points.count > 4) {
            [self resetPoints];
            NSLog(@"Too many points!!");
            if(_beginRecording) {
                [_syn speakUtterance: [AVSpeechUtterance speechUtteranceWithString:@"Wait"]];
            }
            _startTimer = nil;
            _beginRecording = NO;
            _startTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginRecordingPoints) userInfo:nil repeats:NO];
            return;
        }
    
    if(![_points containsObject:touchPoint]) {
//        [_points performSelectorOnMainThread:@selector(addObject:) withObject:touchPoint waitUntilDone:YES];
        [_points addObject:touchPoint];
    }

}
- (void)checkPoints:(NSTimer *)timer {
    _beginRecording = NO;
    [_timer invalidate], _timer = nil;
    for(TouchPoint *touchPoint in _points) {
        NSLog(@"Point in set: %0.1f :: %0.1f", touchPoint.x, touchPoint.y);
    }
    NSLog(@"Checking points");
    NSString *text;
    text = @"";
    NSMutableArray *cleanedPoints = [[NSMutableArray alloc] init];
    for(TouchPoint *touchPoint in _points) {
        if(![cleanedPoints containsObject:touchPoint]) {
            [cleanedPoints addObject:touchPoint];
        }
    }
    NSArray *pointArray = cleanedPoints;
    switch ([pointArray count]) {
        case 1: {
            //number is 1
            text = @"One";
            [_numbers addObject:[NSNumber numberWithInt:1]];
            break; }
        case 2: {
            //number is 2, 3, 5, or 9N
            ;
            TouchPoint *firstPoint = [pointArray objectAtIndex:0];
            CGPoint first = CGPointMake(firstPoint.x, firstPoint.y);
            TouchPoint *secondPoint = [pointArray objectAtIndex:1];
            CGPoint second = CGPointMake(secondPoint.x, secondPoint.y);
            if(fabsf(first.x - second.x) < 57) {
                //x values are the same so number is two
                text = @"Two";
                [_numbers addObject:[NSNumber numberWithInt:2]];
            }
            else if(fabsf(first.y - second.y) < 58) {
                //y values are the same so number is 3
                text = @"Three";
                [_numbers addObject:[NSNumber numberWithInt:3]];
            }
            else {
                //calc slope b/w points
                CGFloat slope = (second.y - first.y) / (second.x - first.x);
                text = slope > 0 ? @"Five" : @"Nine";
                int x = slope > 0 ? 5 : 9;
                [_numbers addObject:[NSNumber numberWithInt:x]];
            }
            break; }
            
        case 3: {
            //number is 4, 6, 8, or 0
            ;
            TouchPoint *firstPoint = [pointArray objectAtIndex:0];
            TouchPoint *secondPoint = [pointArray objectAtIndex:1];
            TouchPoint *thirdPoint = [pointArray objectAtIndex:2];
            CGPoint point1 = CGPointMake(firstPoint.x, firstPoint.y);
            CGPoint point2 = CGPointMake(secondPoint.x, secondPoint.y);
            CGPoint point3 = CGPointMake(thirdPoint.x, thirdPoint.y);
            CGFloat xDiff = fabsf(point1.x - point2.x);
            CGFloat yDiff = fabsf(point1.y - point2.y);
            if (xDiff < 57) { //dots on same x value
                CGFloat compareY = point1.y > point2.y ? point1.y : point2.y;
                CGFloat xAvg = (point1.x + point2.x) / 2.0;
                if (point3.x > xAvg) {
                    //number is 6 if point3.y is upper or 8 if point3.y is lower
                    text = point3.y < (compareY - 58) ? @"Six" : @"Eight";
                    int x = point3.y < (compareY - 58) ? 6 : 8;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                } else {
                    //number is 4 if point3.y is upper or 0 if point3.y is lower
                    text = point3.y < (compareY - 58) ? @"Four" : @"Zero";
                    int x = point3.y < (compareY - 58) ? 4 : 0;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                }
            } else if (yDiff < 58) { //dots on same y value
                CGFloat compareX = point1.x > point2.x ? point1.x : point2.x;
                CGFloat yAvg = (point1.y + point2.y) / 2.0;
                if (point3.y > yAvg) {
                    //number is 4 or 6
                    text = point3.x < (compareX - 57) ? @"Six" : @"Four";
                    int x = point3.x < (compareX - 57) ? 6 : 4;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                } else {
                    //number is 8 or 0
                    text = point3.x < (compareX - 57) ? @"Eight" : @"Zero";
                    int x = point3.x < (compareX - 57) ? 8 : 0;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                }
            } else {
                //deal with diagonal drawing
                CGFloat compareX = point1.x > point2.x ? point1.x : point2.x;
                CGFloat yAvg = (point1.y + point2.y) / 2.0;
                if (point3.y > yAvg) {
                    //number is 4 or 6
                    text = point3.x < (compareX - 57) ? @"Eight" : @"Zero";
                    int x = point3.x < (compareX - 57) ? 8 : 0;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                } else {
                    //number is 8 or 0
                    text = point3.x < (compareX - 57) ? @"Six" : @"Four";
                    int x = point3.x < (compareX - 57) ? 6 : 4;
                    [_numbers addObject:[NSNumber numberWithInt:x]];
                }
            }
            
            break;
        }
        case 4: {
            ;
            TouchPoint *firstPoint = [pointArray objectAtIndex:0];
            TouchPoint *secondPoint = [pointArray objectAtIndex:1];
            TouchPoint *thirdPoint = [pointArray objectAtIndex:2];
            TouchPoint *fourthPoint = [pointArray objectAtIndex:3];
            CGPoint point1 = CGPointMake(firstPoint.x, firstPoint.y);
            CGPoint point2 = CGPointMake(secondPoint.x, secondPoint.y);
            CGPoint point3 = CGPointMake(thirdPoint.x, thirdPoint.y);
            CGPoint point4 = CGPointMake(fourthPoint.x, fourthPoint.y);
            CGFloat xDiffp1p2 = fabsf(point1.x - point2.x);
            CGFloat xDiffp2p3 = fabsf(point2.x - point3.x);
            CGFloat xDiffp3p4 = fabsf(point3.x - point4.x);
            
            if ((xDiffp1p2 < 57 && xDiffp2p3 < 57) || (xDiffp2p3 < 57 && xDiffp3p4 < 57)) {
                //is number sign
                text = @"Number sign";
                
            } else {
                text = @"Seven";
                [_numbers addObject:[NSNumber numberWithInt:7]];
                
            }
            break; }
        default: {
            text = @"No number detected, please try again";
            break; }
            
    }
    NSLog(@"Detected number: %@", text);
    if (text.length > 2) {
        AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:text];
        [_syn speakUtterance:avsu];
        [self resetPoints];
       
    }
    _beginRecording = YES;
    
}


#pragma mark - Utilities


- (void)resetPoints {
    [_timer invalidate], _timer = nil;
    [_points removeAllObjects];
   
    NSLog(@"Points reset");
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(CGRectContainsPoint(self.bounds, point)) {
        if(_beginRecording) {
            [self addTouchPoint:point];
        }
        return YES;
    }
    return NO;
}

@end
