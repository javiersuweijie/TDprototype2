//
//  UILayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"
#import "UnitsMenu.h"

@implementation UILayer


-(void)onEnter
{
    [super onEnter];
    MenuBar* menu = [[MenuBar alloc]init];
    [self addChild:menu];
    UnitsMenu*unitsmenu = [[UnitsMenu alloc]init];
    [self addChild:unitsmenu];
}
@end
