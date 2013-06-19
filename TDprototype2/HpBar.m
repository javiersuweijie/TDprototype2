//
//  HpBar.m
//  TDprototype2
//
//  Created by Javiersu on 19/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HpBar.h"


@implementation HpBar

-(id)initWithChar:(Unit *)p1
{
    if(self = [super init]) {
        self.totalHp = p1.hp;
        self.currentHp = p1.hp;
        self.p=p1;
    }
    return self;
}

-(void)draw
{
    [super draw];
    
    float pcHp = (float)self.p.hp/self.totalHp;
    CGPoint p1 = ccp(0,27);
    CGPoint p2 = ccp(20,25);
    CGPoint p3 = ccp(p1.x+(pcHp*20),25);
    ccDrawSolidRect(p1, p2, ccc4f(255, 0, 0, 1));
    ccDrawSolidRect(p1, p3, ccc4f(0, 255, 0, 1));
    
    
}

@end
