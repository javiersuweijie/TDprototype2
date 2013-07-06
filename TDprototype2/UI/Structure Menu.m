//
//  Structure Menu.m
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Structure Menu.h"
#import "CustomMenuItem.h"
#import "GameLayer.h"

@implementation Structure_Menu
id game_layer;


-(id)init
{
    CustomMenuItem * menuItem1 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do1Action)];

    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Wall" fontName:@"Helvetica" fontSize:8];
    [label1 setAnchorPoint:ccp(0,0)];
    [menuItem1 addChild:label1];
    
    CustomMenuItem * menuItem2 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do2Action)];
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Canon tower" fontName:@"Helvetica" fontSize:8];
    [label2 setAnchorPoint:ccp(0,0)];
    [menuItem2 addChild:label2];
    
    CustomMenuItem * menuItem3 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do3Action)];
    CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"Ice tower" fontName:@"Helvetica" fontSize:8];
    [label3 setAnchorPoint:ccp(0,0)];
    [menuItem3 addChild:label3];
    
    CustomMenuItem * menuItem4 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do4Action)];
    CCLabelTTF* label4 = [CCLabelTTF labelWithString:@"Fire tower" fontName:@"Helvetica" fontSize:8];
    [label4 setAnchorPoint:ccp(0,0)];
    [menuItem4 addChild:label4];
    
    CustomMenuItem * menuItem5 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do5Action)];
    CCLabelTTF* label5 = [CCLabelTTF labelWithString:@"Nothing" fontName:@"Helvetica" fontSize:8];
    [label5 setAnchorPoint:ccp(0,0)];
    [menuItem5 addChild:label5];
    
    CustomMenuItem * menuItem6 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do6Action)];
    CCLabelTTF* label6 = [CCLabelTTF labelWithString:@"Nothing" fontName:@"Helvetica" fontSize:8];
    [label6 setAnchorPoint:ccp(0,0)];
    [menuItem5 addChild:label6];
    
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem6,menuItem5,menuItem4,menuItem3,menuItem2,menuItem1 ,nil];
    
    return [super initWithArray:menuArray];
    
}

-(void)onEnter
{
    [super onEnter];
    game_layer = [[[self parent]parent]getChildByTag:1];
    [self setPosition:ccp([[CCDirector sharedDirector]winSize].width/2, [[CCDirector sharedDirector]winSize].height/2)];
}

-(void)draw
{
    ccDrawRect(ccp(self.position.x-self.contentSize.width/2,self.position.y-self.contentSize.height/2), ccp(self.position.x+self.contentSize.width/2,self.position.y+self.contentSize.height/2));
}

-(void) do1Action
{
    NSLog(@"touched 1");
    [game_layer placeBlueTile];
}
-(void) do2Action
{
    NSLog(@"touched 2");
    [game_layer placeCanon];
}
-(void) do3Action
{
    NSLog(@"touched 3");
    [game_layer placeIce];
}
-(void) do4Action
{
    NSLog(@"touched 4");
    [game_layer placeFireTower];
}
-(void) do5Action
{
        NSLog(@"touched 5");
}
-(void) do6Action{
        NSLog(@"touched 6");
        NSLog(@"%@",NSStringFromCGSize(self.contentSize));
}
@end
