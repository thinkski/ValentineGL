//
//  ValentineGLView.m
//  ValentineGL
//
//  Created by chris on 1/20/12.
//  Copyright (c) 2012, Chris Hiszpanski. All rights reserved.
//

#import "ValentineGLView.h"


@implementation ChrisHiszpanski_ValentineGLView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        // Initialize rotation and view radius (i.e. distance to heart)
        rotation = 0.0f;
        radius = 4.0f;
        
        // Compute isosurface mesh
        marchingCubes = [[MarchingCubes alloc] init];
        [marchingCubes marchFromX:-1.5 toX:1.5
                            fromY:-1.0 toY:1.0
                            fromZ:-1.5 toZ:1.5 byX:0.04 byY:0.04 byZ:0.04];
        
        NSOpenGLPixelFormatAttribute attributes[] = {
            NSOpenGLPFAColorSize, 24,
            NSOpenGLPFAAlphaSize, 8,
            NSOpenGLPFADepthSize, 8,
            NSOpenGLPFADoubleBuffer,
            NSOpenGLPFAAccelerated,
            NSOpenGLPFAClosestPolicy,
            0
        };  
        NSOpenGLPixelFormat *format;
        
        format = [[[NSOpenGLPixelFormat alloc] 
                   initWithAttributes:attributes] autorelease];
        
        glView = [[MyOpenGLView alloc] initWithFrame:NSZeroRect 
                                         pixelFormat:format];
		
        if (!glView) {             
            NSLog( @"Couldn't initialize OpenGL view." );
            [self autorelease];
            return nil;
        } 
        
        [self addSubview:glView]; 
        [self setUpOpenGL];
        
        [self setAnimationTimeInterval:1/30.0];
    }
    
    return self;
}

- (void)dealloc
{
    [glView removeFromSuperview];
    [glView release];
    [super dealloc];
}

- (void)setUpOpenGL
{ 
    // The GL context must be active for these functions to have an effect
    [[glView openGLContext] makeCurrentContext];
    
    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInterval = 1;
    [[glView openGLContext] setValues:&swapInterval
                         forParameter:NSOpenGLCPSwapInterval];
    
    glFrontFace(GL_CW);

    glShadeModel(GL_SMOOTH);
    glClearDepth(1.0);
    glClearColor (0.0, 0.0, 0.0, 0.0);
    glEnable(GL_DEPTH_TEST);

    // Light
    GLfloat ambient_light[] = { 0.0f, 0.0f, 0.0f, 1.0f };
    GLfloat diffuse_light[] = { 0.5f, 0.5f, 0.5f, 1.0f };
    GLfloat specular_light[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    GLfloat position_light[] = { 0.0f, 0.0f, -10.0f, 0.0f };

    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHTING);
    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient_light);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse_light);
    glLightfv(GL_LIGHT0, GL_SPECULAR, specular_light);
    glLightfv(GL_LIGHT0, GL_POSITION, position_light);

    // Material
    GLfloat mat_ambient[] = {1.0, 0.0, 0.0, 1.0};
    GLfloat mat_diffuse[] = { 1.0, 0.0, 0.0, 1.0 };
    GLfloat mat_specular[] = { 1.0, 1.0, 1.0, 1.0 };
    GLfloat mat_shininess[] = { 100.0 };
    
    glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);

    // Copy isosurface vertices to graphics array
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, [marchingCubes vertices]);
    glNormalPointer(GL_FLOAT, 0, [marchingCubes normals]);
    
    // No use rendering the unseen
    glCullFace(GL_BACK);
    glEnable(GL_CULL_FACE);
}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    [glView setFrameSize:newSize]; 
    
    [[glView openGLContext] makeCurrentContext];
    
    // Now the result is glViewport()-compatible
    glViewport(0, 0, (GLsizei)newSize.width, (GLsizei)newSize.height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, (GLfloat)newSize.width/(GLfloat)newSize.height, 0.2, 7);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    [[glView openGLContext] update];
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [[glView openGLContext] makeCurrentContext];
    
    glDrawBuffer(GL_BACK);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Adjust viewpoint to give heart beat effect
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0, radius, 2*radius/3,
              0, 0, 0,
              0, 0, 1);
    
    // Adjust rotation to make heart spin
    glRotatef(rotation, 0.0f, 0.0f, 1.0f);
    
    // Draw heart
    glDrawArrays(GL_TRIANGLES, 0, [marchingCubes vertexCount]/3);
    
    glFlush();
    
    [[glView openGLContext] flushBuffer];
    
    // Rotate and scale a bit
    rotation += 1.0f;
    radius = 4.0 + 0.25*sin(rotation/4);
}

- (void)animateOneFrame
{
    [self setNeedsDisplay:YES];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
