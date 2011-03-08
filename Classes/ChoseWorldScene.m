//
//  ChoseWorldScene.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "ChoseWorldScene.h"
#import "World.h"
#import "LanderImageButton.h"
#import "ChooseLevelScene.h"

@implementation ChoseWorldScene

+ (id) scene
{
  ChoseWorldScene *scene = [ChoseWorldScene node];
  
  // set the heading.
  CCLabelTTF *heading = [CCLabelTTF labelWithString:@"Choose a World" fontName:@"Helvetica" fontSize:32];
  [heading setPosition:CGPointMake(240, 300)];
  [scene addChild:heading];
  
  // bind the worlds.
  NSArray *worlds = [World all];
  
  CCMenu *menu = [CCMenu menuWithItems:nil];
  
  int y_level = 1;
  for (World *w in worlds)
  {
    NSString *path = [NSString stringWithFormat:@"world_%d/screenshot.png", [w worldId]];
    LanderImageButton *button = [LanderImageButton
                                 itemFromNormalImage:path selectedImage:path
                                 target:self 
                                 selector:@selector(buttonTapped:)];
    [button setContentSize:CGSizeMake(100, 80)];
    [button setWorldId:[w worldId]];
    [button setLevelId:1];
    [menu addChild:button];
    
    int offset = [w worldId] % 4;
    if (offset == 0)
    {
      y_level++;
      [menu setPosition:CGPointMake(230, 280 - (80 * y_level - 40))];
      [menu alignItemsHorizontallyWithPadding:20];
      [scene addChild:menu];
      menu = [CCMenu menuWithItems:nil];
    }
  }
  
  [menu alignItemsHorizontallyWithPadding:20];
  [scene addChild:menu];
  
  return scene;
}

+ (void)buttonTapped:(id)sender {
  LanderImageButton *button = (LanderImageButton *)sender;
  [[CCDirector sharedDirector] replaceScene:[ChooseLevelScene sceneWith:[button worldId]]];
}

@end
