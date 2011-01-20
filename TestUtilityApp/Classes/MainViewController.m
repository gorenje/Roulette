//
//  MainViewController.m
//  TestUtilityApp
//
//  Created by Gorenje on 13.03.09.
//  Copyright Five Os and a Zero 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "PrevNumManager.h"
#import "RouletteNumberLogic.h"

/*
 * Remeber that americans have 38 values on the wheel (00) as opposed to the
 * european wheel which has 37 values (0 - 36).
 *
 * Roulette wheel image is from Wikipedia and is licensed under GPL Documentation
 * license.
 */

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        animComplete = YES;
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    lastTimeStamp = ((UITouch *)[touches anyObject]).timestamp;
    lastPoint = pt;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    addButton.hidden = YES;
    [UIView commitAnimations];
} 

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { 
    UITouch * touch = [touches anyObject];
    CGPoint pt1 = [touch locationInView:self.view];
    CGPoint pt2 = lastPoint;
    [prevNumsManager hideView];
    
    if ( animComplete ) {
        CGPoint center = wheel.center;
        CGFloat angle1 = atan2( center.y - pt2.y, center.x - pt2.x ); 
        CGFloat angle2 = atan2( center.y - pt1.y, center.x - pt1.x ); 
        animComplete = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.01f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideView:finished:context:)];
        wheel.transform = CGAffineTransformRotate(wheel.transform,  angle2 - angle1);
        innerWheel.transform = CGAffineTransformRotate(innerWheel.transform,  angle2 - angle1);
        [UIView commitAnimations];
        lastTimeStamp = [touch timestamp];
        lastPoint = pt1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    lastTimeStamp = 0.0;
    lastPoint = CGPointZero;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    addButton.hidden = NO;
    [UIView commitAnimations];
    [prevNumsManager showView];

    CGFloat angle = atan2(wheel.transform.a, wheel.transform.b);
    CGFloat destAngle = ( ( angle + M_PI ) / (M_PI / 18.5f) );
    destAngle = [rnLogic getAngleForPosition:(abs(destAngle+9.75) % 37)];

    CGFloat deltaAngle = ( angle < destAngle ? -(destAngle - angle) : angle - destAngle );
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    wheel.transform = CGAffineTransformRotate(wheel.transform, deltaAngle);
    innerWheel.transform = CGAffineTransformRotate(innerWheel.transform,  deltaAngle);
    [UIView commitAnimations];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSUInteger) getRouletteNumber:(CGAffineTransform)transform {
    /*
     * atan2 returns a value between -M_PI and M_PI. The angle is measured 
     * from the x-axis. This means: we need to add M_PI (we assume 0 .. 2*M_PI)
     * and since we want the value at the top of the roulette (not to the left)
     * we need to add 9.75 (37/4 -- one quarter) spots to the absolute value.
     */
    CGFloat angle = atan2(wheel.transform.a, wheel.transform.b);
    angle  = ( ( angle + M_PI ) / (M_PI / 18.5f) );
    return [rnLogic getNumberForPosition:(abs(angle+9.75) % 37)];
}

- (void) hideView:(NSString *)animId finished:(NSNumber *)finished context:(void *)context {
    CGFloat angle = atan2(wheel.transform.a, wheel.transform.b);
        CGFloat destAngle = ( ( angle + M_PI ) / (M_PI / 18.5f) );
        destAngle = [rnLogic getAngleForPosition:(abs(destAngle+9.75) % 37)];
    NSUInteger num = [self getRouletteNumber:wheel.transform];
    textField.text = [NSString stringWithFormat:@"%d, %0.2f, %0.2f", num, angle, destAngle];
    textField.textColor = [rnLogic getBgColor:num];
    animComplete = YES;    
}

- (IBAction) spinButtonPressed {
    if ( animComplete ) {
        animComplete = NO;
        [prevNumsManager hideView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideView:finished:context:)];
        CGFloat angle = (2.0f * M_PI) * rand();
        wheel.transform = CGAffineTransformRotate(wheel.transform, angle);
        innerWheel.transform = CGAffineTransformRotate(innerWheel.transform, angle);
        [UIView commitAnimations];
    }
}

- (IBAction) addButtonPressed {
    [prevNumsManager addNum:[self getRouletteNumber:wheel.transform]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
