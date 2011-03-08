//
//  StaticObject.m
//  lander
//
//  Created by Richard Owen on 8/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "StaticObject.h"

@implementation LevelStaticObject

-(id) initWithColors:(NSString**) colors
{
	[super init];
	
	_colors = colors;
	
	
	
	return self;
}

- (void) step:(ccTime) delta
{
}

- (void) draw:(cpShape*)shape;
{
	  //cpBody *body = shape->body;
	  cpPolyShape* poly = (cpPolyShape *)shape;
		
	  int count = poly->numVerts;
    
    #if CP_USE_DOUBLES
	  	glVertexPointer(2, GL_DOUBLE, 0, poly->tVerts);
    #else
		  glVertexPointer(2, GL_FLOAT, 0, poly->tVerts);
    #endif
		
	  // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	  // Needed states:  GL_VERTEX_ARRAY, 
	  // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	  glDisable(GL_TEXTURE_2D);
	  glDisableClientState(GL_COLOR_ARRAY);
	  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
		
	  if(!poly->shape.sensor){
		  GLfloat v = 0.25f;
		  glColor4f(v,v,v,1);
		  glDrawArrays(GL_TRIANGLE_FAN, 0, count);
	  }
		
	  glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
	  glDrawArrays(GL_LINE_LOOP, 0, count);
		
	  // restore default GL state
	  glEnable(GL_TEXTURE_2D);
	  glEnableClientState(GL_COLOR_ARRAY);
  	glEnableClientState(GL_TEXTURE_COORD_ARRAY);		
}

@end
