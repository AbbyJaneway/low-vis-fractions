//
//  ViewController.h
//  Fractions
//
//  Created by Dunahee, Jacob Roger on 2/12/14.
//  Copyright (c) 2014 Dunahee, Jacob Roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrailleInput.h"

@interface ViewController : UIViewController <UITextViewDelegate, BrailleInputDelegate>

@property (nonatomic) NSInteger n1;
@property (nonatomic) NSInteger n2;
@property (nonatomic) NSInteger d1;
@property (nonatomic) NSInteger d2;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
- (NSTimeInterval)loadPreferences;

@end



