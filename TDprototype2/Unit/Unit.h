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
@property float speed;
@property int hp;
-(NSMutableArray*)moveToward:(CGPoint)target;
@end
