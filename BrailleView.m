
//
//  BrailleView.m
//  Braillev4
//
//  Created by Brown, Melissa on 4/14/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import "BrailleView.h"
//#import "BrailleTapRecognizer.h"
#import "TouchPoint.h"
#import <AVFoundation/AVFoundation.h>

#define TOUCH_SIZE 40

@interface BrailleView ()
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *startTimer;
@property (nonatomic, strong) BrailleView *theView;
@property (nonatomic, strong) AVSpeechSynthesizer *syn;
@property (nonatomic) BOOL beginRecording;
@end

@implementation BrailleView {

@private
NSTimeInterval timeoutSeconds;

}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"%s", __FUNCTION__);
    self = [super initWithFrame:frame];
    if (self) {
        _points = [[NSMutableArray alloc] init];
        _startTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(beginRecordingPoints) userInfo:nil repeats:NO];
        timeoutSeconds = 1;
        self.backgroundColor = [UIColor whiteColor];
//        self.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
        self.isAccessibilityElement = NO;
        self.userInteractionEnabled = YES;
        _syn = [[AVSpeechSynthesizer alloc] init];
        //VoiceOver interference recognizer
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ignoreTaps:)]];
    }
    return self;
}

- (void)ignoreTaps:(UITapGestureRecognizer *)tapGR {
    [self resetPoints];
    AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:@"Please retry, tap slower"];
    [_syn speakUtterance:avsu];
}


- (void)beginRecordingPoints {
    _beginRecording = YES;
    AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:@"Start"];
    [_syn speakUtterance:avsu];
}


- (void)addTouchPoint:(CGPoint)touch {
    //CGPoint point = [touch locationInView:self.window];
    TouchPoint *touchPoint = [[TouchPoint alloc] initWithX:touch.x andY:touch.y];
    if ([_points count] < 1 && !_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeoutSeconds target:self selector:@selector(checkPoints:) userInfo:nil repeats:NO];
        
        NSLog(@"timer set");

    }
    [_points addObject:touchPoint];
    NSLog(@"Added point at %0.1f, %0.1f in view: %@.", touchPoint.x, touchPoint.y, self);
}



/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
//    if([[event allTouches] count] >= 1) {
//        NSLog(@"In touchesBegan");
//       // [self addTouchPoint:[touches anyObject]];
//        if (_timer == nil) {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:timeoutSeconds target:self selector:@selector(checkPoints:) userInfo:nil repeats:NO];
//            
//            NSLog(@"timer set");
//        }
//    }
} //doesn't get called


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
    //[self addTouchPoint:[touches anyObject]];
    //[self checkPoints];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
}
*/
- (void)checkPoints:(NSTimer *)timer {
    [_timer invalidate], _timer = nil;
    NSLog(@"Checking points");
    NSString *text;
    text = @"";
    switch ([_points count]) {
        case 1: {
            //number is 1
            text = @"One";
          //  [self.delegate setDetectedNumber:1];
            break; }
        case 2: {
            //number is 2, 3, 5, or 9N
            ;
            TouchPoint *firstPoint = [_points objectAtIndex:0];
            CGPoint first = CGPointMake(firstPoint.x, firstPoint.y);
            TouchPoint *secondPoint = [_points objectAtIndex:1];
            CGPoint second = CGPointMake(secondPoint.x, secondPoint.y);
            if(fabsf(first.x - second.x) < 57) {
                //x values are the same so number is two
                text = @"Two";
             //   [self.delegate setDetectedNumber: 2];
            }
            else if(fabsf(first.y - second.y) < 58) {
                //y values are the same so number is 3
                text = @"Three";
              //  [self.delegate setDetectedNumber:3];
            }
            else {
                //calc slope b/w points
                CGFloat slope = (second.y - first.y) / (second.x - first.x);
                text = slope > 0 ? @"Five" : @"Nine";
                int x = slope > 0 ? 5 : 9;
               // [self.delegate setDetectedNumber:x];
            }
            break; }
            
        case 3: {
            //number is 4, 6, 8, or 0
            ;
           TouchPoint *firstPoint = [_points objectAtIndex:0];
            TouchPoint *secondPoint = [_points objectAtIndex:1];
           TouchPoint *thirdPoint = [_points objectAtIndex:2];
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
                //    [self.delegate setDetectedNumber:x];
                } else {
                    //number is 4 if point3.y is upper or 0 if point3.y is lower
                    text = point3.y < (compareY - 58) ? @"Four" : @"Zero";
                    int x = point3.y < (compareY - 58) ? 4 : 0;
                //    [self.delegate setDetectedNumber:x];
                }
            } else if (yDiff < 58) { //dots on same y value
                CGFloat compareX = point1.x > point2.x ? point1.x : point2.x;
                CGFloat yAvg = (point1.y + point2.y) / 2.0;
                if (point3.y > yAvg) {
                    //number is 4 or 6
                    text = point3.x < (compareX - 57) ? @"Six" : @"Four";
                    int x = point3.x < (compareX - 57) ? 6 : 4;
                //    [self.delegate setDetectedNumber:x];
                } else {
                    //number is 8 or 0
                    text = point3.x < (compareX - 57) ? @"Eight" : @"Zero";
                    int x = point3.x < (compareX - 57) ? 8 : 0;
                 //   [self.delegate setDetectedNumber:x];
                }
            } else {
                //deal with diagonal drawing
                CGFloat compareX = point1.x > point2.x ? point1.x : point2.x;
                CGFloat yAvg = (point1.y + point2.y) / 2.0;
                if (point3.y > yAvg) {
                    //number is 4 or 6
                    text = point3.x < (compareX - 57) ? @"Eight" : @"Zero";
                    int x = point3.x < (compareX - 57) ? 8 : 0;
                //    [self.delegate setDetectedNumber:x];
                } else {
                    //number is 8 or 0
                    text = point3.x < (compareX - 57) ? @"Six" : @"Four";
                    int x = point3.x < (compareX - 57) ? 6 : 4;
                 //   [self.delegate setDetectedNumber:x];
                }
            }
            
            break;
        }
        case 4: {
            ;
            TouchPoint *firstPoint = [_points objectAtIndex:0];
            TouchPoint *secondPoint = [_points objectAtIndex:1];
            TouchPoint *thirdPoint = [_points objectAtIndex:2];
            TouchPoint *fourthPoint = [_points objectAtIndex:3];
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
               // [self.delegate setDetectedNumber:7];
            }
            break; }
        default: {
            break; }
            
    }
    NSLog(@"Detected number: %@", text);
    if (text.length > 2) {
        AVSpeechUtterance *avsu = [AVSpeechUtterance speechUtteranceWithString:text];
        [_syn speakUtterance:avsu];
        [self resetPoints];
        
    }
    
}


#pragma mark - Utilities


- (void)resetPoints {
    [_timer invalidate], _timer = nil;
    [_points removeAllObjects];
    NSLog(@"Points reset");
}

#pragma mark - Custom Accessors

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_beginRecording) {
        [self addTouchPoint:point];
    }
    
    return YES;
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"HitTest Point: %@", NSStringFromCGPoint(point));
//    return self;
//}

@end
