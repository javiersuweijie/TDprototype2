//
//  MenuBar.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuBar.h"


@implementation MenuBar
CCMenu* menu;
BOOL extended;
CCMenuItem* root;

-(void)onEnter
{
    [super onEnter];
    root = [CCMenuItemImage itemWithNormalImage:@"Icon.png"
                                  selectedImage: @"Icon.png"
                                         target:self
                                       selector:@selector(changeState)];
    CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doRedAction)];
    
    CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doBlueAction)];
    
    CCMenuItemImage * menuItem3 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doSaveAction)];
    
    CCMenuItemImage * menuItem4 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doLoadAction)];
    CCMenuItemImage * menuItem5 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doLoadAction)];
    CCMenuItemImage * menuItem6 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(doLoadAction)];
    [menuItem1 setVisible:NO];
    [menuItem2 setVisible:NO];
    [menuItem3 setVisible:NO];
    [menuItem4 setVisible:NO];
    [menuItem5 setVisible:NO];
    [menuItem6 setVisible:NO];
    
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem6,menuItem5,menuItem4,menuItem3,menuItem2,menuItem1,root,nil];
    
    menu = [[CCMenu alloc]initWithArray:menuArray];
    [menu setPosition:ccp(0,0)];
        //        NSLog(NSStringFromCGPoint(menu.position));
    [self addChild:menu];
    
}
-(void) changeState {
    if (extended) {
        extended = NO;
        for (id menuitem in [menu children]) {
            if (menuitem==root) {
                [menuitem runAction:[CCRotateBy actionWithDuration:0.5 angle:-45]];
            }
            else {
                CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:ccp(0,0)];
                id ease = [CCEaseInOut actionWithAction:move rate:3];
                id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(setInvisible)];
                [menuitem runAction:[CCSequence actions:ease, moveCallback, nil]];
            }
        }
    }
    else {
        extended = YES;
        for (id menuitem in [menu children]) {
            if (menuitem==root) {
                [menuitem runAction:[CCRotateBy actionWithDuration:0.5 angle:45]];
            }
            else {
                [menuitem setVisible:YES];
                CGPoint endPoint = ccp(([[menu children] indexOfObject:menuitem]+1)*40+20,0);
                CCMoveBy *move = [CCMoveBy actionWithDuration:0.5 position:endPoint];
                id ease = [CCEaseInOut actionWithAction:move rate:3];
                [menuitem runAction:ease];
            }
        }
        
    }
}
-(void) setInvisible {
    for (id menuitem in [menu children]) {
        if (menuitem!=root) {
            [menuitem setVisible:NO];
        }
    }
}
-(void) doRedAction{
    NSLog(@"red is pressed");
}
-(void) doBlueAction{
    NSLog(@"blue is pressed");
}
-(void) doLoadAction{
    NSLog(@"load is pressed");
}
-(void) doSaveAction{
    NSLog(@"save is pressed");
}

@end
