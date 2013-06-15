//
//  IceBeamTower.h
//  TDprototype2
//
//  Created by Javiersu on 11/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Structure.h"
#import "ParticlesIceBeam.h"

@interface IceBeamTower : Structure {
    
}
@property (nonatomic,retain) ParticlesIceBeam* emitter;

-(id)initWithPosition:(CGPoint)point;

@end
