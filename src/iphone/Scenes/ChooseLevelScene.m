//
//  ChoseLevelScene.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "ChooseLevelScene.h"
#import "Common.h"
#import "World.h"
#import "Level.h"
#import "LanderImageButton.h"
#import "GameScene.h"

@implementation ChooseLevelScene

@synthesize worldId=_worldId;

+ (id) sceneWith:(int) worldId
{
  ChooseLevelScene *scene = [ChooseLevelScene node];
  scene.worldId = worldId;
  
  // set the heading.
  CCLabelTTF *heading = [CCLabelTTF labelWithString:@"Choose a level" fontName:@"Helvetica" fontSize:32];
  [heading setPosition:CGPointMake(240, 300)];
  [scene addChild:heading];
  
  // bind the levels to the sceen.
  World *world = [[World alloc] initWith:worldId];
  
  CCMenu *menu = [CCMenu menuWithItems:nil];
  
  int y_level = 1;
  for (Level* level in [world levels])
  {
    NSString *path = [NSString stringWithFormat:@"world_%d/level_%d/screenshot.png", [world worldId], [level levelId]];
    
    LanderImageButton *button = [LanderImageButton
                                 itemFromNormalImage:path selectedImage:path
                                 target:self 
                                 selector:@selector(starButtonTapped:)];
    
    [button setContentSize:CGSizeMake(100, 80)];
    [button setWorldId:[world worldId]];
    [button setLevelId:[level levelId]];
    [menu addChild:button];
    
    int offset = [level levelId] % 4;
    if (offset == 0)
    {
      y_level++;
      [menu setPosition:CGPointMake(230, 320 - (80 * y_level - 40))];
      [menu alignItemsHorizontallyWithPadding:20];
      [scene addChild:menu];
      menu = [CCMenu menuWithItems:nil];
    }
  }
  
  [menu alignItemsHorizontallyWithPadding:20];
  [scene addChild:menu];
  
  return scene;
}

+ (void)starButtonTapped:(id)sender {
  LanderImageButton *button = (LanderImageButton *)sender;
  [[CCDirector sharedDirector] replaceScene:[Game scene:[button worldId] levelID:[button levelId]]];
}

@end
