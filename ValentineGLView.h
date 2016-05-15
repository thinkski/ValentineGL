//
//  ValentineGLView.h
//  ValentineGL
//
//  Created by chris on 1/20/12.
//  Copyright (c) 2012, Chris Hiszpanski. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>
#import "MyOpenGLView.h"
#import "MarchingCubes.h"

@interface ChrisHiszpanski_ValentineGLView : ScreenSaverView 
{
    MyOpenGLView *glView;
    GLfloat rotation;
    GLfloat radius;
    
    MarchingCubes *marchingCubes;
}

- (void)setUpOpenGL;

@end
