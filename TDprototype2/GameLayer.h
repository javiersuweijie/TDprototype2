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
//check if a coordinate point is valid
+(BOOL)isValid:(CGPoint)point;
//check if a grid point is valid
+(BOOL)isValidGrid:(CGPoint)grid;
//returns the valid grids around a particular point
+(NSArray*)walkableAdjGrid:(CGPoint)grid;

-(id)placeBlueTile;
-(id)placeFireTower;
-(id)placeCanon;
-(id)placeIce;
//returns an array with all the units for target acquiring 
+(NSMutableArray*)getUnitArray;
+(NSMutableArray*)getFilledArray;

-(void)testSP;
-(void)spawnFastPaper;
-(void)spawnSlowThick;
-(void)spawnFlyingUnit;

-(void)exportData;
-(void)loadData;
@end
