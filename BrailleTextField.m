//
//  BrailleTextField.m
//  BrailleKeyboardv1
//
//  Created by Brown, Melissa on 4/30/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import "BrailleTextField.h"

@implementation BrailleTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAccessibilityTraits:(UIAccessibilityTraits)accessibilityTraits {
    self.accessibilityTraits = UIAccessibilityTraitNone;
    self.textInputView.accessibilityTraits = UIAccessibilityTraitNone;
}

- (void)setAccessibilityValue:(NSString *)accessibilityValue {
    self.accessibilityValue = @"";
    self.textInputView.accessibilityValue = @"";
}

- (void)setAccessibilityHint:(NSString *)accessibilityHint {
    self.accessibilityHint = @"";
    self.textInputView.accessibilityHint = @"";
}

@end
