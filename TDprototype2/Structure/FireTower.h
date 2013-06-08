//
//  FireTower.h
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Structure.h"

@interface FireTower : Structure
@property (strong,nonatomic) CCParticleFire* emitter;

-(id)initWithPosition:(CGPoint)point;
@end
