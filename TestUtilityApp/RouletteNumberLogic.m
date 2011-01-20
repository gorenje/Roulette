//
//  RouletteNumberLogic.m
//  TestUtilityApp
//
//  Created by Gorenje on 17.03.09.
//  Copyright 2009 Five Os and a Zero. All rights reserved.
//

#import "RouletteNumberLogic.h"

@implementation RouletteNumberLogic

- (id) init
{
    self = [super init];
    if (self != nil) {
        fgColors[0] = [UIColor greenColor];
        bgColors[0] = [UIColor whiteColor];
        
        fgColors[15] = fgColors[4]  = fgColors[2]  = fgColors[17] = fgColors[6]  = fgColors[13] = fgColors[11] = [UIColor whiteColor];
        bgColors[15] = bgColors[4]  = bgColors[2]  = bgColors[17] = bgColors[6]  = bgColors[13] = bgColors[11] = [UIColor blackColor];
        fgColors[8]  = fgColors[10] = fgColors[24] = fgColors[33] = fgColors[20] = fgColors[31] = fgColors[22] = [UIColor whiteColor];
        bgColors[8]  = bgColors[10] = bgColors[24] = bgColors[33] = bgColors[20] = bgColors[31] = bgColors[22] = [UIColor blackColor];
        fgColors[29] = fgColors[28] = fgColors[35] = fgColors[26] = [UIColor whiteColor];
        bgColors[29] = bgColors[28] = bgColors[35] = bgColors[26] = [UIColor blackColor];
        
        fgColors[32] = fgColors[19] = fgColors[21] = fgColors[25] = fgColors[34] = fgColors[27] = fgColors[36] = [UIColor whiteColor];
        bgColors[32] = bgColors[19] = bgColors[21] = bgColors[25] = bgColors[34] = bgColors[27] = bgColors[36] = [UIColor redColor];
        fgColors[30] = fgColors[23] = fgColors[5]  = fgColors[16] = fgColors[1]  = fgColors[14] = fgColors[9]  = [UIColor whiteColor];
        bgColors[30] = bgColors[23] = bgColors[5]  = bgColors[16] = bgColors[1]  = bgColors[14] = bgColors[9]  = [UIColor redColor];
        fgColors[18] = fgColors[7]  = fgColors[12] = fgColors[3]  = [UIColor whiteColor];
        bgColors[18] = bgColors[7]  = bgColors[12] = bgColors[3]  = [UIColor redColor];

        for ( NSUInteger idx = 0; idx < 10; idx++ ) {
            angleForPosition[idx] = (M_PI/2) + ((M_PI/18.5f) * idx);
        }
        NSUInteger cnt = 1;
        for ( NSUInteger idx = 10; idx < 29; idx++, cnt++ ) {
            angleForPosition[idx] = ((M_PI/18.5f) * cnt) - M_PI - 0.04f;
        }
        cnt = 1;
        for ( NSUInteger idx = 29; idx < 38; idx++, cnt++ ) {
            angleForPosition[idx] = ((M_PI/18.5f) * cnt) + 0.04f;
        }
    }
    return self;
}

/*
 * Based on zero being in the first quadrate, the other
 * numbers going clockwise around.
 */
NSUInteger QUADRATES[]={
    1,
    3,1,4,1,3,
    2,4,2,3,2,
    2,4,2,3,1,
    3,1,4,1,3,
    1,4,2,3,1,
    4,2,4,4,2,
    3,1,3,1,4,
    2
};

/*
 * Map a number to the distance from zero going clockwise around
 */
NSUInteger DISTANCE_FROM_ZERO[] = {
    0,
    23,  6, 35,  4, 19,
    10, 31, 16, 27, 18,
    14, 33, 12, 25,  2,
    21,  8, 29,  3, 24,
     5, 28, 17, 20,  7,
    36, 11, 32, 30, 15,
    26,  1, 22,  9, 34,
    13
};

/*
 * Index is the position going clockwise from 0
 */
NSUInteger ROULETTE_NUMBERS[] = {
    /*green*/ 0, 
    /*red*/   32,15,19, 4,21, 2,25,17,34, /* 1 to 9 */
    /*black*/ 6, 27,13,36,11,30, 8,23,10, /* 10 to 18 */
    /*red*/   5, 24,16,33, 1,20,14,31, 9, /* 19 to 27 */
    /*black*/ 22,18,29, 7,28,12,35, 3,26  /* 28 to 36 */
};

- (NSUInteger) getNumberForPosition:(NSUInteger)pos {
    return ROULETTE_NUMBERS[pos];
}

- (CGFloat) getAngleForPosition:(NSUInteger)pos {
    return angleForPosition[pos];
}

- (UIColor *) getFgColor:(NSUInteger)num {
    return fgColors[num];
}

- (UIColor *) getBgColor:(NSUInteger)num {
    return bgColors[num];
}

- (NSInteger) distanceBetweenNum:(NSUInteger)from to:(NSUInteger)to {
    NSInteger dist = DISTANCE_FROM_ZERO[from] - DISTANCE_FROM_ZERO[to];
    //return dist;
    return ( dist < -18 ? dist + 37 : ( dist > 18 ? dist - 37 : dist ));
}
@end
