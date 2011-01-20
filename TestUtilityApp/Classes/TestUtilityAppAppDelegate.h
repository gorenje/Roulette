//
//  TestUtilityAppAppDelegate.h
//  TestUtilityApp
//
//  Created by Gorenje on 13.03.09.
//  Copyright Five Os and a Zero 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TestUtilityAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

