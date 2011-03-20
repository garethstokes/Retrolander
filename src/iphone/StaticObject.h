//
//  StaticObject.h
//  lander
//
//  Created by Richard Owen on 8/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayer.h"
#import "GameProtocols.h"

@interface LevelStaticObject : NSObject < GameObject > {
	NSString **_colors;
}

-(id) initWithColors:(NSString**) colors;

@end
