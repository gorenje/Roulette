//
//  MainViewController.h
//  TestUtilityApp
//
//  Created by Gorenje on 13.03.09.
//  Copyright Five Os and a Zero 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrevNumManager;
@class RouletteNumberLogic;

@interface MainViewController : UIViewController {
    IBOutlet UILabel * textField;
    IBOutlet UIImageView * wheel;
    IBOutlet UIImageView * innerWheel;
    IBOutlet UIButton * addButton;
    IBOutlet UIButton * spinButton;
    IBOutlet PrevNumManager * prevNumsManager;
    IBOutlet RouletteNumberLogic * rnLogic;
    
    NSTimeInterval lastTimeStamp;
    CGPoint lastPoint;
    BOOL animComplete;
}

- (IBAction) spinButtonPressed;
- (IBAction) addButtonPressed;
- (NSUInteger) getRouletteNumber:(CGAffineTransform)transform;

@end
