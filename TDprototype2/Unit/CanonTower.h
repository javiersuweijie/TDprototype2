//
//  CanonTower.h
//  TDprototype2
//
//  Created by Javiersu on 10/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Structure.h"

@interface CanonTower : Structure {
    
}
@property (strong,nonatomic) CCSprite* projectile;
-(id)initWithPosition:(CGPoint)point;
@end
