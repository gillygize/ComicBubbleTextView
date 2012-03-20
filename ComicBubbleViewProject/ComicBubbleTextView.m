//
//  ComicBubbleTextView.m
//  TestUI
//
//  Created by Matthew Gillingham on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicBubbleTextView.h"

#define MAKE_TAG(x)     x+1
#define RETRIEVE_TAG(x) x-1

const int HEIGHTOFPOPUPTRIANGLE = 10;
const int WIDTHOFPOPUPTRIANGLE = 10;
const int borderRadius = 8;
const int strokeWidth = 4;

@interface ComicBubbleTextView()
-(CGPathRef)createPath;
-(void)setupBubble;
@end

@implementation ComicBubbleTextView

@synthesize textView = _textView;
@synthesize triangleCenter = _triangleCenter;

-(id)initWithFrame:(CGRect)frame text:(NSString *)string {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor blueColor];
        
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(
      10.0f,
      10.0f,
      frame.size.width - 20.0f,
      frame.size.height - 20.0f - HEIGHTOFPOPUPTRIANGLE 
    )];
    
    _textView.font = [UIFont fontWithName:kComicBubbleFontName size:kComicBubbleFontSize];
    _textView.center = CGPointMake(frame.size.width / 2.0f, (frame.size.height - HEIGHTOFPOPUPTRIANGLE) / 2.0f);
    _textView.textAlignment = UITextAlignmentCenter;
    _textView.text = string;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
        
    [self addSubview:_textView];
    
    // Note: The contentSize of the textView may only be set to the size of the text with the font *after* it is added
    // to the subview.
    [self resizeTextViewFrameToFitContentAnimated:NO];
        
    _triangleCenter = _textView.frame.size.width / 2.0f;
    shapeLayer = nil;
        
    [self setupBubble];
  }
    
  return self;
}
    
- (void)resizeTextViewFrameToFitContentAnimated:(BOOL)animated {
  CGFloat maximumHeight = self.frame.size.height - 20.0f - HEIGHTOFPOPUPTRIANGLE;
  CGFloat currentContentHeight = _textView.contentSize.height;

  void (^updateFrame)(void) = ^{
    self.textView.bounds = CGRectMake(
      0.0,
      0.0f,
      self.frame.size.width - 20.0f,
      MIN(currentContentHeight, maximumHeight)
    );
  };
  
  if (animated) {
    [UIView animateWithDuration:0.25f animations:updateFrame];
  } else {
    updateFrame();
  }
}

-(void)setText:(NSString*)text animated:(BOOL)animated {
  _textView.text = text;
  
  if (animated) {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey:kCATransactionAnimationDuration];
    [self resizeTextViewFrameToFitContentAnimated:animated];
    [self changeBubble:animated];
    [CATransaction commit];
  }
}

-(void)dealloc {
  [_textView release];
    
  [super dealloc];
}

-(void)setupBubble {
  if (NULL == shapeLayer) {        
    CGPathRef path = [self createPath];    
    shapeLayer = [CAShapeLayer layer];

    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setLineWidth:strokeWidth];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setPath:path];
        
    CGPathRelease(path);
        
    [[self layer] insertSublayer:shapeLayer below:[self.textView layer]];
  }
}

-(void)changeBubble:(BOOL)animated {
    CGPathRef initialPath = shapeLayer.path;
    CGPathRef newPath = [self createPath];
    
    if (animated) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        basicAnimation.duration = 0.25f;
        basicAnimation.fromValue = (id)initialPath;
        basicAnimation.toValue = (id)newPath;
        
        [shapeLayer addAnimation:basicAnimation forKey:@"bubbleAnimationEnd"];        
    }

    shapeLayer.path = newPath;
}

-(CGPathRef)createPath {    
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
    round(self.triangleCenter - WIDTHOFPOPUPTRIANGLE / 2.0f),
    currentFrame.size.height - HEIGHTOFPOPUPTRIANGLE
  );
  
  CGPathAddLineToPoint(
    path,
    &transform,
    self.triangleCenter,
    currentFrame.size.height
  );
  
  CGPathAddLineToPoint(
    path,
    &transform,
    round(self.triangleCenter + WIDTHOFPOPUPTRIANGLE / 2.0f),
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
