//
//  UILayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"
#import "UnitsMenu.h"
#import "ResourceLabel.h"
#import "Structure Menu.h"

@implementation UILayer
CGSize winSize;
UIGestureRecognizer *tapGestureRecognizer;
Structure_Menu* menu;

-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector]winSize];
    menu = [[Structure_Menu alloc]init];
    [self addChild:menu z:1 tag:1];
}

@end
