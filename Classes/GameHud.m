#import "GameHud.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldScene.h"
#import "GameScene.h"

@implementation GameHud

- (id) init
{
  if (!(self=[super initWithColor:(ccColor4B){64, 64, 128, 64}]))
  {
    return nil;
  }
  
  CGSize size = [[CCDirector sharedDirector] winSize];
  [self setPosition:ccp(0, size.height - 30)];
  [self setContentSize:CGSizeMake(size.width, 30)];
  
  RestartButton *restart = [[RestartButton alloc] init];
  [restart setPosition:ccp(size.width - 30, 15)];
  [self addChild:restart];
  
  return self;
}

@end

@implementation RestartButton

@synthesize text=_text;

- (id) init
{
  if ((self=[super init])) {
    // create and initialize a Label
    _text = [CCLabelTTF labelWithString:@"restart" fontName:@"Marker Felt" fontSize:16];
		[self addChild: _text];
    
    self.isTouchEnabled = YES;
    [self setContentSize:CGSizeMake(30, 20)];
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
  NSLog(@"ccTouchBegan Called");
  if ( ![self containsTouchLocation:touch] ) return NO;
  [_text setString:@"is being touched"];
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint touchPoint = [touch locationInView:[touch view]];
  touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
  
  NSLog(@"ccTouch Moved is called");
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [_text setString:@"reset"];
  [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

@end