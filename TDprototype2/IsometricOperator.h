//
//  IsometricOperator.h
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GLKit/GLKMatrix3.h>

@interface IsometricOperator : NSObject

+(void)init;

+(CGPoint)coordTransform:(CGPoint)point;

+(CGPoint)coordInvTransform:(CGPoint)point;

+(CGPoint)nearestPoint:(CGPoint)point;

+(CGPoint)gridNumber:(CGPoint)nPoint;

+(CGPoint)gridToCoord:(CGPoint)grid;

+(id)getArea:(CGPoint)position;

@end
