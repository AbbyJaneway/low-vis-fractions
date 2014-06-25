//
//  TouchPoint.h
//  BrailleV3
//
//  Created by Brown, Melissa on 3/31/14.
//
//

#import <Foundation/Foundation.h>

@interface TouchPoint : NSObject

@property (nonatomic, readonly) float x;
@property (nonatomic, readonly) float y;

- (id)initWithX:(float)xVal andY:(float)yVal;

@end
