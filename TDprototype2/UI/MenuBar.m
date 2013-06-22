//
//  MenuBar.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuBar.h"
#import "GameLayer.h"

@implementation MenuBar

BOOL extended;
CCMenuItem* root;
id game_layer;
-(id)init
{

    root = [CCMenuItemImage itemWithNormalImage:@"Icon.png"
                                  selectedImage: @"Icon.png"
                                         target:self
                                       selector:@selector(changeState)];
    CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"ball.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do1Action)];
    
    CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"bluebox.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do2Action)];
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Basic wall" fontName:@"Helvetica" fontSize:8];
    [label2 setAnchorPoint:ccp(0,0)];
    [menuItem2 addChild:label2];
    
    CCMenuItemImage * menuItem3 = [CCMenuItemImage itemWithNormalImage:@"redbox.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do3Action)];
    CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"Fire Tower" fontName:@"Helvetica" fontSize:8];
    [label3 setAnchorPoint:ccp(0,0)];
    [menuItem3 addChild:label3];
    
    CCMenuItemImage * menuItem4 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do4Action)];
    CCLabelTTF* label4 = [CCLabelTTF labelWithString:@"Canon Tower" fontName:@"Helvetica" fontSize:8];
    [label4 setAnchorPoint:ccp(0,0)];
    [menuItem4 addChild:label4];
    
    CCMenuItemImage * menuItem5 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do5Action)];
    CCLabelTTF* label5 = [CCLabelTTF labelWithString:@"Ice Tower" fontName:@"Helvetica" fontSize:8];
    [label5 setAnchorPoint:ccp(0,0)];
    [menuItem5 addChild:label5];
    
    CCMenuItemImage * menuItem6 = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png"
                                                         selectedImage: @"Icon-Small.png"
                                                                target:self
                                                              selector:@selector(do6Action)];
    [menuItem1 setVisible:NO];
    [menuItem2 setVisible:NO];
    [menuItem3 setVisible:NO];
    [menuItem4 setVisible:NO];
    [menuItem5 setVisible:NO];
    [menuItem6 setVisible:NO];
    
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem6,menuItem5,menuItem4,menuItem3,menuItem2,menuItem1,root,nil];
    
    return [super initWithArray:menuArray];

}

-(void)onEnter
{
    [super onEnter];
    game_layer= [[[self parent]parent] getChildByTag:1];
    extended = NO;
    [self setContentSize:CGSizeMake(root.contentSize.width, 320)];
    [self setPosition:ccp(10, 10)];
    for (id menuitem in self.children) {
        [menuitem setPosition:ccp(root.contentSize.width/2,root.contentSize.height/2)];
    }
//    
//    NSLog(@"%@",NSStringFromCGPoint(self.anchorPoint));
//    NSLog(@"%d",self.isTouchEnabled);
//    NSLog(@"%@",NSStringFromCGPoint(self.position));
//    NSLog(@"%@",NSStringFromCGSize(self.contentSize));
//    
    
}
-(void) changeState
{
    if ([root numberOfRunningActions]>0) {
        return;
    }
    if (extended) {
        extended = NO;
        for (id menuitem in [self children]) {
            if (menuitem==root) {
                [menuitem runAction:[CCRotateTo actionWithDuration:0.4 angle:0]];
            }
            else {
                
                CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:ccp(root.contentSize.width/2,root.contentSize.height/2)];
                id ease = [CCEaseInOut actionWithAction:move rate:3];
                id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(setInvisible)];
                [menuitem runAction:[CCSequence actions:ease, moveCallback, nil]];
            }
        }
    }
    else {
        extended = YES;
        NSLog(@"%@",NSStringFromCGSize(self.contentSize));
        for (id menuitem in [self children]) {
            if (menuitem==root) {
                [menuitem runAction:[CCRotateTo actionWithDuration:0.4 angle:45]];
            }
            else {
                [menuitem setVisible:YES];
                CGPoint endPoint = ccp(0,([[self children] indexOfObject:menuitem]+1)*40+20);
                CCMoveBy *move = [CCMoveBy actionWithDuration:0.5 position:endPoint];
                id ease = [CCEaseInOut actionWithAction:move rate:3];
                [menuitem runAction:ease];
            }
        }
        
    }
}
-(void) setInvisible
{
    for (id menuitem in [self children]) {
        if (menuitem!=root) {
            [menuitem setVisible:NO];
        }
    }
}
-(void) do1Action
{
    [game_layer testSP];
}
-(void) do2Action
{
    [game_layer placeBlueTile];
}
-(void) do3Action
{
    [game_layer placeFireTower];
}
-(void) do4Action
{
    [game_layer placeCanon];
}
-(void) do5Action
{
    [game_layer placeIce];
}
-(void) do6Action{
    
}
@end
