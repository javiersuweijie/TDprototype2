//
//  Unit.h
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Unit : CCSprite {
    
}
typedef NS_ENUM(NSInteger, UnitType) {
    Normal,
    Invisible,
    Flying
};

@property float speed;
@property int hp;
@property float speedMultiplier;
@property UnitType unitType;
-(NSMutableArray*)moveToward:(CGPoint)target;
@end
