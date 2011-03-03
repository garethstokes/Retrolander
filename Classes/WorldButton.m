//
//  WorldButton.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "WorldButton.h"
#import "ChoseLevelScene.h"

@implementation WorldButton

@synthesize number=_number;

- (id) initWith:(int)num
{
  if ((self=[super init])) {
    
    _number = num;
    NSString *numberString = [NSString stringWithFormat:@"%i", _number];
    
    _text = [CCLabelTTF labelWithString:numberString fontName:@"Helvetica" fontSize:32];
		[self addChild: _text];
    
    self.isTouchEnabled = YES;
    [self setContentSize:CGSizeMake(100, 80)];
  }
  return self;
}

- (void) dealloc
{
  [_text dealloc];
  [super dealloc];
}

- (CGRect)rect
{
  CGSize s = [self contentSize];
  return CGRectMake(-s.width, - s.height, s.width, s.height);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
  CGRect r = [self rect];
  CGPoint p = [self convertTouchToNodeSpaceAR:touch];
  BOOL contains_point = CGRectContainsPoint(r, p);
  return contains_point;
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
  
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	//Game *current = (Game *)[[CCDirector sharedDirector] runningScene];
	
  [[CCDirector sharedDirector] replaceScene:[ChoseLevelScene sceneWith:_number]];
}


@end
