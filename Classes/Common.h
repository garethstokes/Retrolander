/*
 *  Common.h
 *  lander
 *
 *  Created by gareth stokes on 19/02/11.
 *  Copyright 2011 spacehip studio. All rights reserved.
 *
 */

//#import "cocos2d.h"

static const int MAX_FUEL = 200;

enum {
  MapWidth = 480 * 4, 
  MapHeight = 320 * 4
};

// using law of cosines, we can calculate the vector between the player and
// the landing pad with this formula
// (x,y) =>
//    x = distance * cos(angle)
//    y = distance * sin(angle)
static inline CGPoint
ccpGetOffset(const double angle, const int distance)
{
  double x,y;
  x = distance * cos(angle);
  y = distance * sin(angle);
  return CGPointMake(x,y);
}

// reduces the first point to (0,0) then
// subtracts a from b. once that is done
// it will return the angle from (0,0).
static inline CGPoint 
ccpAngleBetween(CGPoint a, CGPoint b)
{
  CGPoint offset = CGPointMake(b.x - a.x, b.y - a.y);
  return offset;
}