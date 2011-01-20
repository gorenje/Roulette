//
//  PrevNumManager.m
//  TestUtilityApp
//
//  Created by Gorenje on 16.03.09.
//  Copyright 2009 Five Os and a Zero. All rights reserved.
//

#import "PrevNumManager.h"
#import "RouletteNumberLogic.h"

@implementation PrevNumManager


- (id) init {
    self = [super init];
    if (self != nil) {
        animatingView = NO;
        prevNumIdx = 0;
    }
    return self;
}

/*
 * Peform the Lagrange or Neville polynomial interpolation.
 * Parameters are:
 *  x - is the array of x values (0...n-1)
 *  f - is an array containing the values f(x) from 0...n-1
 *  n - is the number of points
 *  t - is interpolation we're interested, i.e. we want f(t)
 * Return value is f(t).
 *
 * WARNING: this has the side effect of reseting the values in f.
 */
+ (CGFloat) nevilleinterpolation:(CGFloat *)x f:(CGFloat *)f n:(NSUInteger)n t:(CGFloat)t
{
    NSUInteger m;
    NSUInteger i;
    
    n = n-1;
    for(m = 1; m <= n; m++)
    {
        for(i = 0; i <= n-m; i++)
        {
            f[i] = ( (t-x[i+m]) * f[i] + (x[i]-t) * f[i+1]) / (x[i]-x[i+m]);
        }
    }
    return f[0];
}

/*
 * Values is our set of numbers, n is the number of numbers we have.
 */
+ (CGFloat) standardDeviation:(CGFloat *)values n:(NSUInteger)n {
    CGFloat sum = 0.0f;
    for ( int i = 0; i < n; i++ ) sum += values[i];
    CGFloat mean = sum / n;
    CGFloat variance = 0.0f;
    for ( int i = 0; i < n; i++ ) variance += pow(values[i] - mean, 2.0f);
    variance = variance / n;
    return (CGFloat)sqrt(variance);
}

+ (CGFloat) average:(CGFloat *)values n:(NSUInteger)n {
    CGFloat sum = 0.0f;
    for ( int idx = 0; idx < n; idx++ ) sum += values[idx];
    return (sum / (CGFloat)n);
}

/*
 * This computes the position of the inner wheel so that it indicates where the
 * next spin will end up (hopefully!). The logic here assumes that the last number
 * added is at the top of the outer wheel (otherwise it could not have been added!)
 * Assuming that, we move the inner wheel back to the "start location" (i.e. so that
 * the middle of the green is pointing directly upwards) and then move the inner wheel
 * by the distance value (in rads) from the current value. Since the current value is 
 * also located at the top of the outer wheel, this makes sense.
 */
- (void) updateInnerWheel {
    if ( prevNumIdx <= MAX_INTERPOLATION_VALUES ) return;
    
    NSUInteger startIdx = ( prevNumIdx > MAX_INTERPOLATION_VALUES ? prevNumIdx - MAX_INTERPOLATION_VALUES - 1: 0);
    NSLog(@"------------");
    for ( NSUInteger idx = 0; idx < MAX_INTERPOLATION_VALUES; idx++, startIdx++ ) {
        xValues[idx] = (CGFloat)(idx + 1);
        fValues[idx] = (CGFloat)[rnLogic distanceBetweenNum:prevNums[startIdx] to:prevNums[startIdx+1]]; 
        NSLog(@"%d: %0.2f %0.2f, %d => %d", idx, xValues[idx], fValues[idx], prevNums[startIdx], prevNums[startIdx+1]);
    }

    CGFloat staDev = [PrevNumManager standardDeviation:fValues n:MAX_INTERPOLATION_VALUES];
    CGFloat distance = NAN;

    // special case of going forward, then back, then forward, ...
    if ( staDev > 2.5f ) {
        CGFloat fValuesCopy[MAX_INTERPOLATION_VALUES];
        for ( int idx = 0; idx < MAX_INTERPOLATION_VALUES; idx++ ) fValuesCopy[idx] = fabs(fValues[idx]);
        CGFloat staDevCopy = [PrevNumManager standardDeviation:fValuesCopy n:MAX_INTERPOLATION_VALUES];
        NSLog(@"StadevCopy: %0.2f Orig: %0.2f", staDevCopy, staDev);
        if ( staDevCopy < 1.20f ) {
            NSLog(@"Setting from average");
            staDev = staDevCopy;
            CGFloat avg = [PrevNumManager average:fValuesCopy n:MAX_INTERPOLATION_VALUES];
            CGFloat lastValue = fValues[MAX_INTERPOLATION_VALUES-1];
            CGFloat secondLastValue = fValues[MAX_INTERPOLATION_VALUES-2];
            distance = ( (lastValue < 0 && secondLastValue > 0) || (lastValue < 0 && secondLastValue < 0) ) ? avg : -avg;
        }
    }

    // if distance has not been set, then we extrapolate it.
    if ( isnan(distance) ) {
        NSLog(@"Computing distance");
        distance = [PrevNumManager nevilleinterpolation:xValues 
                                                      f:fValues 
                                                      n:MAX_INTERPOLATION_VALUES 
                                                      t:MAX_INTERPOLATION_VALUES+0.1]; 
    }

    // compute the transformation angle and alpha value for the inner wheel.
    CGFloat distanceInRads = distance * (M_PI / 18.5f);
    CGFloat innerWheelAlpha = ((1.20f - staDev) / 1.20f);
    innerWheelAlpha = ( innerWheelAlpha < 0.20f ? 0.20f : innerWheelAlpha );

    NSLog(@"Result: %0.2f (%0.2f) StdDev: %0.2f Alpha: %0.2f",
          distance, fabs(distance), staDev,innerWheelAlpha);
    
    // finally animate the movemenet of the inner wheel.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    innerWheel.alpha = innerWheelAlpha;
    innerWheel.transform = CGAffineTransformMakeRotation(-M_PI_4-distanceInRads);
    [UIView commitAnimations];
}

- (void) addNum:(NSUInteger)num {
    prevNums[prevNumIdx++] = num;
    NSUInteger startIdx = ( prevNumIdx > NUM_PREV_LABELS ? prevNumIdx - NUM_PREV_LABELS : 0);
    for ( NSUInteger idx = 0; idx < NUM_PREV_LABELS; idx++, startIdx++ ) {
        UILabel * label = (UILabel *)[prevNumsView viewWithTag:(idx+1)];
        NSUInteger labelVal = 0;
        label.text = ( idx < prevNumIdx ? [NSString stringWithFormat:@"%d", labelVal=prevNums[startIdx]] : @"--" );
        label.backgroundColor = [rnLogic getBgColor:labelVal];
        label.textColor = [rnLogic getFgColor:labelVal];
    }
    [self showView];
    [self updateInnerWheel];
}

- (void) completedShow:(NSString *)animId finished:(NSNumber *)finished context:(void *)context {
    prevNumsView.hidden = NO;;
    animatingView = NO;
}

- (void) completedHide:(NSString *)animId finished:(NSNumber *)finished context:(void *)context {
    prevNumsView.hidden = YES;
    animatingView = NO;
}

- (void) hideView {
    if ( animatingView ) return;
    if ( prevNumsView.hidden ) return;

    animatingView = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(completedHide:finished:context:)];
    prevNumsView.center = CGPointMake(prevNumsView.center.x, -prevNumsView.center.y);    
    [UIView commitAnimations];
}

- (void) showView {
    if ( animatingView ) return;
    if ( ! prevNumsView.hidden ) return;

    prevNumsView.hidden = NO;
    animatingView = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(completedShow:finished:context:)];
    prevNumsView.center = CGPointMake(prevNumsView.center.x, -prevNumsView.center.y);    
    [UIView commitAnimations];
}

@end
