//
//  ComicBubbleViewProjectViewController.m
//  ComicBubbleViewProject
//
//  Created by Matthew Gillingham on 10/2/11.
//  Copyright 2011 Matt Gillingham. All rights reserved.
//

#import "ComicBubbleViewProjectViewController.h"

@implementation ComicBubbleViewProjectViewController

@synthesize comicBubbleTextView;

- (void)dealloc {
  [comicBubbleTextView release];
  [super dealloc];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)loadView
{
  UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  comicBubbleTextView = [[ComicBubbleTextView alloc]
    initWithFrame:CGRectMake(
        0.0f,
        100.0f,
        320.0f,
        200.0f
      )
    text:@"Hello!"];
  [view addSubview:comicBubbleTextView];
  [comicBubbleTextView release];

  self.view = view;
  [view release];
}

- (void)viewDidLoad {
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [comicBubbleTextView setText:@"How are you? I hope you are ok, because you really, really, really don't look so good." animated:YES];
  });

  delayInSeconds = 4.0;
  popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [comicBubbleTextView setText:@"I am just concerned, that's all." animated:YES];
  });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
