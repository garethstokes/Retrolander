/*
 *  Common.h
 *  lander
 *
 *  Created by gareth stokes on 19/02/11.
 *  Copyright 2011 spacehip studio. All rights reserved.
 *
 */

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
  return ccp(x,y);
}