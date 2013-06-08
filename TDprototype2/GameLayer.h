//
//  GameLayer.h
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer <UIGestureRecognizerDelegate> {
    
}
+(BOOL)isValid:(CGPoint)point;
+(BOOL)isValidGrid:(CGPoint)grid;
+(NSArray*)walkableAdjGrid:(CGPoint)grid;
+(void)testSP;
+(void)placeBlueTile;
+(void)placeFireTower;
+(NSMutableArray*)getUnitArray;
@end
