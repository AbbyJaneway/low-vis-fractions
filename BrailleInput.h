//
//  BrailleInput.h
//  BrailleKeyboardv1
//
//  Created by Brown, Melissa on 4/28/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrailleInputDelegate

- (void)setNumberArray:(NSMutableArray *)numberArray forTextView:(UITextView*)textView;

@end

@interface BrailleInput : UIInputView

@property (nonatomic, strong) IBOutlet id<BrailleInputDelegate> delegate;

- (void)startPoints:(UITextView *)textView;

- (void)setTimeoutSeconds:(NSTimeInterval)timeoutSeconds;

@end
