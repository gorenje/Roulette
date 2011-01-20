//
//  PrevNumManager.h
//  TestUtilityApp
//
//  Created by Gorenje on 16.03.09.
//  Copyright 2009 Five Os and a Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUM_PREV_LABELS 11
#define MAX_INTERPOLATION_VALUES 4
#define MAX_PREVIOUS_NUMS 1000

@class RouletteNumberLogic;

@interface PrevNumManager : NSObject {
    IBOutlet UIView * prevNumsView;
    IBOutlet UIImageView * innerWheel;
    IBOutlet UIImageView * outerWheel;
    IBOutlet RouletteNumberLogic * rnLogic;
    
    NSUInteger prevNums[MAX_PREVIOUS_NUMS];
    NSUInteger prevNumIdx;
    BOOL animatingView;

    CGFloat xValues[MAX_INTERPOLATION_VALUES];
    CGFloat fValues[MAX_INTERPOLATION_VALUES];
}

- (void) addNum:(NSUInteger)num;
- (void) hideView;
- (void) showView;

@end
