//
//  ComicBubbleViewProjectAppDelegate.h
//  ComicBubbleViewProject
//
//  Created by Matthew Gillingham on 10/2/11.
//  Copyright 2011 Matt Gillingham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComicBubbleViewProjectViewController;

@interface ComicBubbleViewProjectAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ComicBubbleViewProjectViewController *viewController;

@end
