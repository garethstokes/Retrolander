//
//  SettingsScene.m
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "SettingsScene.h"
#import "EntryScene.h"

@implementation SettingsScene

+ (id) scene
{
  SettingsScene *scene = [SettingsScene node];

  CCLabelTTF *mainLabel = [CCLabelTTF labelWithString:@"back to main menu" fontName:@"Helvetica" fontSize:32];
  CCMenuItem *mainMenuItem = [CCMenuItemLabel 
                                   itemWithLabel:mainLabel 
                                   target:self 
                                   selector:@selector(mainMenu:)];
  
  [mainMenuItem setPosition:ccp(0, 0)];
  
  CCMenu *menu = [CCMenu menuWithItems:mainMenuItem, nil];
  [menu setPosition:CGPointMake(240, 180)];
  
  [scene addChild: menu];
  return scene;
}

+ (void)mainMenu:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[EntryScene scene]];
}
@end
