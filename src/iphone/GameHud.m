#import "GameHud.h"
#import "CCTouchDispatcher.h"
#import "GameScene.h"
#import "GameLayer.h"
#import "EntryScene.h"

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
  
  CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"restart" fontName:@"Helvetica" fontSize:16];
  CCMenuItem *restartButton = [CCMenuItemLabel
                                itemWithLabel:restartLabel
                                target:self 
                                selector:@selector(restartGame:)];
  [restartButton setPosition:CGPointMake(210, 15)];
  
  CCLabelTTF *endGameLabel = [CCLabelTTF labelWithString:@"end" fontName:@"Helvetica" fontSize:16];
  CCMenuItem *endButton = [CCMenuItemLabel
                           itemWithLabel:endGameLabel
                           target:self 
                           selector:@selector(endGame:)];
  [endButton setPosition:CGPointMake(160, 15)];

  CCMenu *menu = [CCMenu menuWithItems:restartButton, endButton, nil];
  [menu setPosition:CGPointMake(240, 0)];
  [self addChild:menu];
  
  _fuel = [[FuelGauge alloc] initWithMax:MAX_FUEL];
  [self addChild:_fuel];
  
  _levelInfo = [CCLabelTTF labelWithString:@"W:1 L:1" fontName:@"Helvetica" fontSize:16];
  [_levelInfo setPosition:CGPointMake(310, 15)];
  [self addChild:_levelInfo];
  
  _livesInfo = [CCLabelTTF labelWithString:@"lives: 0" fontName:@"Helvetica" fontSize:16];
  [_livesInfo setPosition:CGPointMake(250, 15)];
  [self addChild:_livesInfo];
  
  return self;
}

- (void)restartGame:(id)sender
{
  Game *current = (Game *)[[CCDirector sharedDirector] runningScene];
  [[CCDirector sharedDirector] replaceScene:[Game scene:current.worldID levelID:current.levelID]];
}

- (void)endGame:(id)sender
{
  [[CCDirector sharedDirector] replaceScene:[EntryScene scene]];
}

- (void) draw
{
  [super draw];
  
  if (_fuel != nil) {
    Game * scene = (Game *)[[CCDirector sharedDirector] runningScene];
    Player *player = [[scene game] player];
    
    int current_fuel = [player fuel];
    [_fuel draw:current_fuel];
    
    int current_lives = [player lives];
        
    [_levelInfo setString:[NSString stringWithFormat:@"w:%i l:%i", scene.worldID, scene.levelID]];
    [_livesInfo setString:[NSString stringWithFormat:@"lives: %i", current_lives]];
  }
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