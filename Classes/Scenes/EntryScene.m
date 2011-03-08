//
//  EntryScene.m
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "EntryScene.h"
#import "SettingsButton.h"

@implementation EntryScene
@synthesize start=_start;

+ (id) scene
{
  EntryScene *scene = [EntryScene node];
  CGSize size = [[CCDirector sharedDirector] winSize];
  
  StartGameButton *start = [[StartGameButton alloc] init];
  [start setPosition:ccp(size.width /2, size.height /2 + 20)];
  
  SettingsButton *settings = [[SettingsButton alloc] init];
  [settings setPosition:ccp(size.width /2, size.height /2 - 20)];
  
  [scene addChild: start];
  [scene addChild: settings];
  
  return scene;
}


@end
