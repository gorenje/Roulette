//
//  RouletteNumberLogic.h
//  TestUtilityApp
//
//  Created by Gorenje on 17.03.09.
//  Copyright 2009 Five Os and a Zero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RouletteNumberLogic : NSObject {
    UIColor * fgColors[40];
    UIColor * bgColors[40];
    CGFloat angleForPosition[40];
}

- (NSUInteger) getNumberForPosition:(NSUInteger)pos;
- (UIColor *) getFgColor:(NSUInteger)num;
- (UIColor *) getBgColor:(NSUInteger)num;
- (NSInteger) distanceBetweenNum:(NSUInteger)from to:(NSUInteger)to;
- (CGFloat) getAngleForPosition:(NSUInteger)pos;

@end
