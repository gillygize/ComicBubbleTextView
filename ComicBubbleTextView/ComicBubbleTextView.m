//
//  ComicBubbleTextView.m
//  TestUI
//
//  Created by Matthew Gillingham on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicBubbleTextView.h"

const int HEIGHTOFPOPUPTRIANGLE = 10;
const int WIDTHOFPOPUPTRIANGLE = 10;
const int borderRadius = 8;
const int strokeWidth = 4;

@interface ComicBubbleTextView()
- (CGPathRef)createPath;
- (void)setupBubble;
- (void)resizeContent:(BOOL)animated;
- (void)resizeBubble:(BOOL)animated;
- (void)resizeTextViewFrameToFitContentAnimated:(BOOL)animated;
@end

@implementation ComicBubbleTextView

@synthesize textView = _textView;
@synthesize triangleCenter = _triangleCenter;

- (id)initWithFrame:(CGRect)frame text:(NSString *)string {
  self = [super initWithFrame:frame];
  if (self) {        
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(
      10.0f,
      10.0f,
      frame.size.width - 20.0f,
      frame.size.height - 20.0f - HEIGHTOFPOPUPTRIANGLE 
    )];

    _textView.font = [UIFont fontWithName:kComicBubbleFontName size:24];
    _textView.center = CGPointMake(frame.size.width / 2.0f, (frame.size.height - HEIGHTOFPOPUPTRIANGLE) / 2.0f);
    _textView.textAlignment = UITextAlignmentCenter;
    _textView.text = string;
    _textView.backgroundColor = [UIColor blackColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.textColor = [UIColor whiteColor];
    [self addSubview:_textView];
    
    // Note: The contentSize of the textView may only be set to the size of the text with the font *after* it is added
    // to the subview.
    [self resizeTextViewFrameToFitContentAnimated:NO];
        
    _triangleCenter = 0.5f;
    shapeLayer = nil;
        
    [self setupBubble];
    
    __block ComicBubbleTextView *thisView = self;
    textFieldChangeNotificationHandler = [[NSNotificationCenter defaultCenter]
      addObserverForName:UITextViewTextDidChangeNotification
      object:_textView
      queue:[NSOperationQueue mainQueue]
      usingBlock:^(NSNotification* notification){
        [thisView resizeContent:NO];
    }];
    
    [textFieldChangeNotificationHandler retain];
  }
    
  return self;
}

- (void)layoutSubviews {
  [self resizeContent:NO];
}

- (void)dealloc {
  [_textView release];
  
  [[NSNotificationCenter defaultCenter] removeObserver:textFieldChangeNotificationHandler];
  [textFieldChangeNotificationHandler release];
    
  [super dealloc];
}
    
- (void)resizeTextViewFrameToFitContentAnimated:(BOOL)animated {
  CGFloat minimumHeight = [@"Qq" sizeWithFont:self.textView.font].height + 10.0f;
  CGFloat maximumHeight = self.bounds.size.height - 20.0f - HEIGHTOFPOPUPTRIANGLE;
  CGFloat currentContentHeight = self.textView.contentSize.height;

  CGRect newBounds = CGRectMake(
    0.0,
    0.0f,
    self.bounds.size.width - 20.0f,
    MIN(
      MAX(
        currentContentHeight,
        minimumHeight
      ),
      maximumHeight
    )
  );
  
  CGPoint newCenter = CGPointMake(
    self.bounds.size.width / 2.0f,
    (self.bounds.size.height - HEIGHTOFPOPUPTRIANGLE) / 2.0f
  );

  self.textView.bounds = newBounds;
  self.textView.center = newCenter;
  self.textView.contentOffset = CGPointMake(0.0f, self.textView.contentSize.height-newBounds.size.height);
}

- (void)setText:(NSString*)text animated:(BOOL)animated {
  self.textView.text = text;
  
  [self resizeContent:animated];
}

- (void)setTriangleCenter:(CGFloat)triangleCenter animated:(BOOL)animated {
  self.triangleCenter = triangleCenter;
  
  [self resizeContent:animated];
}

- (void)resizeContent:(BOOL)animated {
  if (animated) {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey:kCATransactionAnimationDuration];
  }
  
  [self resizeTextViewFrameToFitContentAnimated:animated];  
  [self resizeBubble:animated];
  
  if (animated) {
    [CATransaction commit];
  }
}

- (void)setupBubble {
  if (nil == shapeLayer) {        
    CGPathRef path = [self createPath];    
    shapeLayer = [CAShapeLayer layer];

    [shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setLineWidth:strokeWidth];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setPath:path];
        
    CGPathRelease(path);
        
    [[self layer] insertSublayer:shapeLayer below:[self.textView layer]];
  }
}

- (void)resizeBubble:(BOOL)animated {
  CGPathRef initialPath = shapeLayer.path;
  CGPathRef newPath = [self createPath];
    
  if (animated) {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25f;
    basicAnimation.fromValue = (id)initialPath;
    basicAnimation.toValue = (id)newPath;
        
    [shapeLayer addAnimation:basicAnimation forKey:nil];        
  }

  shapeLayer.path = newPath;
}

- (CGPathRef)createPath {    
  CGRect currentFrame = CGRectMake(
    self.textView.frame.origin.x - strokeWidth / 2.0f,
    self.textView.frame.origin.y - strokeWidth / 2.0f,
    self.textView.frame.size.width + strokeWidth,
    self.textView.frame.size.height + HEIGHTOFPOPUPTRIANGLE + strokeWidth
  );
    
  CGMutablePathRef path = CGPathCreateMutable();
    
  CGAffineTransform transform = CGAffineTransformMakeTranslation(
    currentFrame.origin.x,
    currentFrame.origin.y
  );

  CGPathMoveToPoint(
    path,
    &transform,
    borderRadius + strokeWidth,
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE
  );
  
  CGPathAddLineToPoint(
    path,
    &transform,
    round(self.triangleCenter * self.textView.frame.size.width - WIDTHOFPOPUPTRIANGLE / 2.0f),
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE
  );
  
  CGPathAddLineToPoint(
    path,
    &transform,
    self.triangleCenter * self.textView.frame.size.width,
    currentFrame.size.height
  );
  
  CGPathAddLineToPoint(
    path,
    &transform,
    round(self.triangleCenter * self.textView.frame.size.width + WIDTHOFPOPUPTRIANGLE / 2.0f),
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE
  );
  
  CGPathAddArcToPoint(
    path,
    &transform,
    currentFrame.size.width,
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE,
    currentFrame.size.width,
    0.0f,
    borderRadius
  );
  
  CGPathAddArcToPoint(
    path,
    &transform,
    currentFrame.size.width,
    0.0f,
    round(currentFrame.size.width / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f),
    0.0f,
    borderRadius
  );
  
  CGPathAddArcToPoint(
    path,
    &transform,
    0.0f,
    0.0f,
    0.0f,
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE,
    borderRadius
  );
  
  CGPathAddArcToPoint(
    path,
    &transform,
    0.0f,
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE,
    currentFrame.size.width,
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE,
    borderRadius
  );
  
  CGPathCloseSubpath(path);
    
  return path;
}

@end
