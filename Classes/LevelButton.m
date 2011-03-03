//
//  LevelButton.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "LevelButton.h"
#import "GameScene.h"

@implementation LevelButton

@synthesize worldId=_worldId;
@synthesize levelId=_levelId;

- (id) initWith:(int)worldId levelId:(int)levelId
{
  if(!(self = [super init])) return nil;
	
  _worldId = worldId;
	_levelId = levelId;
  
  NSString *numberString = [NSString stringWithFormat:@"%i", levelId];
  
  _text = [CCLabelTTF labelWithString:numberString fontName:@"Helvetica" fontSize:32];
  [self addChild: _text];
  
  self.isTouchEnabled = YES;
  [self setContentSize:CGSizeMake(100, 60)];
  
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
  [[CCDirector sharedDirector] replaceScene:[Game scene:_worldId levelID:_levelId]];
}

@end
