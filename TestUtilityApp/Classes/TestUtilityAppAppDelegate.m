//
//  TestUtilityAppAppDelegate.m
//  TestUtilityApp
//
//  Created by Gorenje on 13.03.09.
//  Copyright Five Os and a Zero 2009. All rights reserved.
//

#import "TestUtilityAppAppDelegate.h"
#import "RootViewController.h"

@implementation TestUtilityAppAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
