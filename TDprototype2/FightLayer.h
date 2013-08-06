//
//  FightLayer.h
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FightLayer : CCLayer {
    
}
@property id filledList;
-(id)initWith:(id)boxLayer;
-(NSMutableArray*)getUnitArray;
-(BOOL)isValidUnitGrid:(CGPoint)grid;
-(NSArray*)walkableAdjUnitGrid:(CGPoint)grid;
@end
