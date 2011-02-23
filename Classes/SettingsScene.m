//
//  SettingsScene.m
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "SettingsScene.h"
#import "EntrySceneButton.h"

@implementation SettingsScene

+ (id) scene
{
  SettingsScene *scene = [SettingsScene node];
  CGSize size = [[CCDirector sharedDirector] winSize];
  
  EntrySceneButton *entry_button = [[EntrySceneButton alloc] init];
  [entry_button setPosition:ccp(size.width /2, size.height /2)];
  
  [scene addChild:entry_button];
  
  return scene;
}

@end
