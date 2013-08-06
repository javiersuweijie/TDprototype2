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
//check if a grid is valid for units
+(BOOL)isValidUnitGrid:(CGPoint)grid;
//returns the valid grids around a particular point
+(NSArray*)walkableAdjGrid:(CGPoint)grid;
//for units
+(NSArray*)walkableAdjUnitGrid:(CGPoint)grid;

+(Byte)isConnected:(NSArray*)gridArray;

-(id)placeBlueTile;
-(id)placeFireTower;
-(id)placeCanon;
-(id)placeIce;
-(id)placeTower:(NSString*)tower;
//returns an array with all the units for target acquiring 
+(NSMutableArray*)getUnitArray;
+(NSMutableArray*)getFilledArray;

-(void)exportData;
-(void)loadData;
-(void)loadUnit;

-(BOOL)closeMenu;
-(float)getScale;

-(id)getUnitArray;
@end
