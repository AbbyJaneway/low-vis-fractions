//
//  TouchPoint.m
//  BrailleV3
//
//  Created by Brown, Melissa on 3/31/14.
//
//

#import "TouchPoint.h"

@implementation TouchPoint

- (id)initWithX:(float)xVal andY:(float)yVal {
    if((self = [super init])) {
        _x = xVal;
        _y = yVal;
    }
    return self;
}

- (BOOL)isEqual:(TouchPoint *)point {
    NSLog(@"Comparing %0.1f, %0.1f to %0.1f, %0.1f", _x, _y, point.x, point.y);
    return _x == point.x && _y == point.y;
}
@end
