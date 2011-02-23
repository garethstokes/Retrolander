//
//  SettingsButton.m
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "SettingsButton.h"
#import "SettingsScene.h"

@implementation SettingsButton

@synthesize text=_text;

- (id) init
{
  if ((self=[super init])) {
    // create and initialize a Label
    
    _text = [CCLabelTTF labelWithString:@"Settings" fontName:@"Helvetica" fontSize:32];
		[self addChild: _text];
    
    self.isTouchEnabled = YES;
    [self setContentSize:CGSizeMake(60, 40)];
  }
  return self;
}

- (CGRect)rect
{
  CGSize s = [self contentSize];
  return CGRectMake(-s.width, - s.height, s.width, s.height);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
  return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (void)onEnter
{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
  [super onEnter];
}

- (void)onExit
{
  [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
  [super onExit];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  if ( ![self containsTouchLocation:touch] ) return NO;
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint touchPoint = [touch locationInView:[touch view]];
  touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [[CCDirector sharedDirector] replaceScene:[SettingsScene scene]];
}

@end
