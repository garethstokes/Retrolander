//
//  EntryScene.m
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "EntryScene.h"
#import "ChoseWorldScene.h"
#import "SettingsScene.h"

@implementation EntryScene

+ (id) scene
{
  EntryScene *scene = [EntryScene node];
  
  CCLabelTTF *startLabel = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Helvetica" fontSize:32];
  CCMenuItem *startGameMenuItem = [CCMenuItemLabel 
                                   itemWithLabel:startLabel 
                                   target:self 
                                   selector:@selector(startGame:)];
  
  [startGameMenuItem setPosition:ccp(0, 0)];
  
  CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:@"Settings" fontName:@"Helvetica" fontSize:32];
  CCMenuItem *settingsMenuItem = [CCMenuItemLabel 
                                  itemWithLabel:settingsLabel 
                                  target:self 
                                  selector:@selector(settingsOnEnter:)];
  
  [settingsMenuItem setPosition:ccp(0, -40)];
  
  CCMenu *menu = [CCMenu menuWithItems:startGameMenuItem, settingsMenuItem, nil];
  [menu setPosition:CGPointMake(240, 180)];
  
  [scene addChild: menu];
  return scene;
}

+ (void)startGame:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[ChoseWorldScene scene]];
}

+ (void)settingsOnEnter:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[SettingsScene scene]];
}

@end
