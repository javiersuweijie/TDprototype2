//
//  UILayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"

@implementation UILayer


-(void)onEnter
{
    [super onEnter];
    MenuBar* menu = [[MenuBar alloc]init];
    [menu setPosition:ccp(50,50)];
    [self addChild:menu];
}
@end
