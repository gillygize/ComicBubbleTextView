//
//  ComicBubbleTextView.h
//  TestUI
//
//  Created by Matthew Gillingham on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kComicBubbleFontName    @"Helvetica-Bold"

@interface ComicBubbleTextView : UIView <UITextViewDelegate> {
  CAShapeLayer *shapeLayer;
  id textFieldChangeNotificationHandler;
}

@property (nonatomic, retain) UITextView *textView;
@property CGFloat triangleCenter;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
- (void)setText:(NSString*)text animated:(BOOL)animated;
- (void)setTriangleCenter:(CGFloat)triangleCenter animated:(BOOL)animated;

@end
