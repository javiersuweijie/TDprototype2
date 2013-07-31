//
//  IsometricOperator.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//
//

#import "IsometricOperator.h"

@implementation IsometricOperator
static kmMat4 scale;
static kmMat4 rotate;
static kmMat4 translate;
static kmMat4 transform;
static kmMat4 invTransform;
static float tileHeight;

+(void)init
{
    kmMat4Identity(&transform);
    kmMat4Translation(&translate, 0, 0.8f, 0);
//    kmMat4Scaling(&scale, sqrtf(2.0)*cosf(CC_DEGREES_TO_RADIANS(40)), 1.0f, 1.0f);
    kmMat4Scaling(&scale, sqrtf(2.0), 1.0f, 1.0f);
    kmMat4RotationZ(&rotate, CC_DEGREES_TO_RADIANS(-45));
    kmMat4Multiply(&transform, &scale, &rotate);
    kmMat4Inverse(&invTransform, &transform);
    tileHeight = 16;
    NSLog(@"%f",[[CCDirector sharedDirector]winSize].width);
    NSLog(@"%f",tileHeight);
    
    
    NSLog(@"%d",(int)-1.5);
    NSLog(@"%d",(int)1.5);
}

+(CGPoint)coordTransform:(CGPoint)point {
    kmVec3 vPoint = {
        point.x,point.y,0
    };
    
    kmVec3Transform(&vPoint, &vPoint, &transform);
    return ccp(vPoint.x,vPoint.y);
}

+(CGPoint)coordInvTransform:(CGPoint)point {
    kmVec3 vPoint = {
        point.x,point.y,0
    };
    
    kmVec3Transform(&vPoint, &vPoint, &invTransform);
    return ccp(vPoint.x,vPoint.y);
}

+(CGPoint)nearestPoint:(CGPoint)point {
    CGPoint xypoint = [IsometricOperator coordInvTransform:ccp(point.x,point.y)];
    int x = xypoint.x;
    int y = xypoint.y;
    //NEEDS TO TEST
    if (x%(int)tileHeight==0 && y%(int)tileHeight==0) {
        return [IsometricOperator coordTransform:ccp(x,y)];
    }
    
    else {
        if (x<0) {
            x = xypoint.x/tileHeight;
            x--;
        }
        else x = xypoint.x/tileHeight;
        y = xypoint.y/tileHeight;
        if (y<0)y--;
        x*=tileHeight;
        y*=tileHeight;
        return [IsometricOperator coordTransform:ccp(x+tileHeight,y)];
    }
}


+(CGPoint)gridNumber:(CGPoint)nPoint{
    CGPoint xypoint = [IsometricOperator coordInvTransform:nPoint];
    int x = roundf(xypoint.x/tileHeight);
    int y = roundf(xypoint.y/tileHeight);
    
    return ccp(x,y);
}

+(CGPoint)gridToCoord:(CGPoint)grid {
    
    float x=grid.x*tileHeight;
    float y=grid.y*tileHeight;
    return [IsometricOperator coordTransform:ccp(x,y)];
}

+(id)getArea:(CGPoint)position
{
    CGPoint vert[4];
    CGPoint grid = [IsometricOperator gridNumber:position];
    vert[0] = [IsometricOperator gridToCoord:ccp(grid.x,grid.y)];
    vert[1] = [IsometricOperator gridToCoord:ccp(grid.x,grid.y+1)];
    vert[2] = [IsometricOperator gridToCoord:ccp(grid.x+1,grid.y+1)];
    vert[3] = [IsometricOperator gridToCoord:ccp(grid.x+1,grid.y)];
    
    return (__bridge id)(vert);
}



@end
