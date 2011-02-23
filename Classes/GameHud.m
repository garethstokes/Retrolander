#import "GameHud.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldScene.h"
#import "GameScene.h"
#import "GameLayer.h"
#import "EntrySceneButton.h"

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
  
  EntrySceneButton *end = [[EntrySceneButton alloc] initForHud];
  [end setPosition:ccp(size.width - 100, 15)];
  [self addChild:end];
  
  _fuel = [[FuelGauge alloc] initWithMax:MAX_FUEL];
  [self addChild:_fuel];
  
  return self;
}

- (void) draw
{
  [super draw];
  
  if (_fuel != nil) {
    Game * scene = (Game *)[[CCDirector sharedDirector] runningScene];
    int current_fuel = [[[scene game] player] fuel];
    [_fuel draw:current_fuel];
  }
}

@end

@implementation RestartButton

@synthesize text=_text;

- (id) init
{
  if ((self=[super init])) {
    // create and initialize a Label
    _text = [CCLabelTTF labelWithString:@"restart" fontName:@"Helvetica" fontSize:16];
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

@implementation FuelGauge 
  
- (id) initWithMax:(int)fuel
{
  if ((self=[super init])) {
    _maxFuel = fuel;
  }  
  return self;
}

- (void) draw:(int)playerFuel
{
  double offset = (playerFuel / (double)MAX_FUEL) * 100;
  offset = offset * 2;
    
  const GLfloat line[] = {
    10.0f, 15.0f, //point B
    10.0f + offset, 15.0f, //point A
  };
  
  glPushMatrix();
  
  glVertexPointer(2, GL_FLOAT, 0, line);
  glEnableClientState(GL_VERTEX_ARRAY);
  
  glLineWidth(5.0f);
  glDrawArrays(GL_LINES, 0, 2);
  
  glPopMatrix();
  
  glLineWidth(1.0f);
}
  
@end