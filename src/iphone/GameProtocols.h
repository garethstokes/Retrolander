/*
 *  GameProtocols.h
 *  lander
 *
 *  Created by Richard Owen on 9/03/11.
 *  Copyright 2011 spacehip studio. All rights reserved.
 *
 */

#import "cocos2d.h"

@protocol GameObject
- (void) step:(ccTime) delta;
- (void) draw:(cpShape *)shape;
@end