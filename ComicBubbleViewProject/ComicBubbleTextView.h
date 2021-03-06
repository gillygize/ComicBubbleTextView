//
//  ComicBubbleTextView.h
//  TestUI
//
//  Created by Matthew Gillingham on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kComicBubbleFontSize    24
#define kComicBubbleFontName    @"Helvetica"

@interface ComicBubbleTextView : UIView {
  CAShapeLayer *shapeLayer;
}

@property (nonatomic, retain) UITextView *textView;
@property CGFloat triangleCenter;

-(id)initWithFrame:(CGRect)frame text:(NSString *)text;
-(void)setText:(NSString*)text animated:(BOOL)animated;

@end
