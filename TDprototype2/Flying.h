//
//  Flying.h
//  TDprototype2
//
//  Created by Javiersu on 23/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Unit.h"

@interface FlyingUnit : Unit {
    
}
-(id)initWithPosition:(CGPoint)point moveTo:(CGPoint)pointTo;
@end
