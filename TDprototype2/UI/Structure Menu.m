//
//  Structure Menu.m
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Structure Menu.h"
#import "CustomMenuItem.h"

@implementation Structure_Menu

-(id)init
{
    CustomMenuItem * menuItem1 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do1Action)];

    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Basic unit" fontName:@"Helvetica" fontSize:8];
    [label1 setAnchorPoint:ccp(0,0)];
    [menuItem1 addChild:label1];
    
    CustomMenuItem * menuItem2 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do2Action)];
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Fast + Paper" fontName:@"Helvetica" fontSize:8];
    [label2 setAnchorPoint:ccp(0,0)];
    [menuItem2 addChild:label2];
    
    CustomMenuItem * menuItem3 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do3Action)];
    CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"Slow + Thick" fontName:@"Helvetica" fontSize:8];
    [label3 setAnchorPoint:ccp(0,0)];
    [menuItem3 addChild:label3];
    
    CustomMenuItem * menuItem4 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do4Action)];
    CCLabelTTF* label4 = [CCLabelTTF labelWithString:@"Flying" fontName:@"Helvetica" fontSize:8];
    [label4 setAnchorPoint:ccp(0,0)];
    [menuItem4 addChild:label4];
    
    CustomMenuItem * menuItem5 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do5Action)];
    CCLabelTTF* label5 = [CCLabelTTF labelWithString:@"Nothing" fontName:@"Helvetica" fontSize:8];
    [label5 setAnchorPoint:ccp(0,0)];
    [menuItem5 addChild:label5];
    
    CustomMenuItem * menuItem6 = [CustomMenuItem menuItemWithOnlyImage:@"Icon-Small.png" target:self selector:@selector(do6Action)];
    
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem6,menuItem5,menuItem4,menuItem3,menuItem2,menuItem1 ,nil];
    
    return [super initWithArray:menuArray];
    
}

-(void)draw
{
    ccDrawRect(ccp(self.position.x-self.contentSize.width/2,self.position.y-self.contentSize.height/2), ccp(self.position.x+self.contentSize.width/2,self.position.y+self.contentSize.height/2));
}

-(void) do1Action
{
    NSLog(@"touched 1");
//    [game_layer testSP];
}
-(void) do2Action
{
    NSLog(@"touched 2");
//    [game_layer placeBlueTile];
}
-(void) do3Action
{
    NSLog(@"touched 3");
//    [game_layer placeFireTower];
}
-(void) do4Action
{
    NSLog(@"touched 4");
//    [game_layer placeCanon];
}
-(void) do5Action
{
        NSLog(@"touched 5");
//    [game_layer placeIce];
}
-(void) do6Action{
        NSLog(@"touched 6");
        NSLog(@"%@",NSStringFromCGSize(self.contentSize));
}
@end
