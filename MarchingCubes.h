//
//  MarchingCubes.h
//  ValentineGL
//
//  Created by chris on 1/21/12.
//  Copyright 2012 Chris Hiszpanski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

// Floating-point type used in algorithm (GLfloat, CGFloat, float, double)
typedef GLfloat MarchingCubesFloat;

@interface MarchingCubes : NSObject {
    float isoLevel;
    
    __strong MarchingCubesFloat *vertices;
    __strong MarchingCubesFloat *normals;
    unsigned int vertexCount;
    @private unsigned int vertexCapacity;
    @private unsigned int vertexCapacityInBytes;
}
- (void)marchFromX:(MarchingCubesFloat)fromX
               toX:(MarchingCubesFloat)toX
             fromY:(MarchingCubesFloat)fromY
               toY:(MarchingCubesFloat)toY
             fromZ:(MarchingCubesFloat)fromZ
               toZ:(MarchingCubesFloat)toZ
               byX:(MarchingCubesFloat)byX
               byY:(MarchingCubesFloat)byY
               byZ:(MarchingCubesFloat)byZ;

@property(readonly) MarchingCubesFloat *vertices;
@property(readonly) MarchingCubesFloat *normals;
@property(readonly) unsigned int vertexCount;
@end
