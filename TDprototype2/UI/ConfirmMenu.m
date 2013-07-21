//
//  ConfirmMenu.m
//  TDprototype2
//
//  Created by Javiersu on 17/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ConfirmMenu.h"
#import "CustomMenuItem.h"
#import "GameLayer.h"

@implementation ConfirmMenu
id game_layer;
id structure_;
Structure* prevStruct_;
-(id)init
{
    float left_padding = 10;
    
    CustomMenuItem * menuItem1 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(confirm)];
    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Confirm" fontName:@"Helvetica" fontSize:8];
    [label1 setAnchorPoint:ccp(0,0)];
    [label1 setPosition:ccp(left_padding, 0)];
    [menuItem1 addChild:label1];
    
    CustomMenuItem * menuItem2 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(cancel)];
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Helvetica" fontSize:8];
    [label2 setAnchorPoint:ccp(0,0)];
    [label2 setPosition:ccp(left_padding, 0)];
    [menuItem2 addChild:label2];
    
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem2,menuItem1 ,nil];
    
    [self setVisible:NO];
    
    return [super initWithArray:menuArray];
    

}

-(void)onEnter
{
    [super onEnter];
    game_layer = [[[self parent]parent]getChildByTag:1];
    [self setPosition:ccp([[CCDirector sharedDirector]winSize].width/2, [[CCDirector sharedDirector]winSize].height/2)];
}

-(void)openWithStructure:(Structure *)structure
{
    if (!structure) {
        return;
    }
    NSLog(@"OPEN");
    structure_ = structure;
    [self setVisible:YES];
    [self arrangeCircle];
}

-(void)openWithStructure:(Structure *)structure andPrev:(Structure *)prevStruct
{
    if (!prevStruct) {
        prevStruct_ = prevStruct;
        prevStruct_.visible = NO;
    }
    [self openWithStructure:structure];
}

-(void)confirm
{
    if (!prevStruct_) {
        [prevStruct_ removeFromParentAndCleanup:YES];
        prevStruct_ = nil;
    }
    [structure_ unSelect];
    [self keepCircle];
}

-(void)cancel
{
    if (!prevStruct_) {
        prevStruct_.visible = YES;
    }
    [structure_ removeFromParentAndCleanup:YES];
    structure_=nil;
    [self keepCircle];
}
@end
