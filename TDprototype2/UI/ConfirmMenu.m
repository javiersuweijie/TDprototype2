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
@synthesize current,structure;
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

-(void)openWithStructure:(Structure *)structure_
{
    if (!structure_) {
        return;
    }
//    NSLog(@"OPEN");
    self.structure = structure_;
    [self setVisible:YES];
    [self arrangeCircle];
}

-(void)openWithStructure:(Structure *)structure_ andCurrent:(Structure *)currentStruct
{
    if (!self.current) {
        NSLog(@"set current");
        self.current = currentStruct;
        self.current.visible = NO;
    }
    [self openWithStructure:structure_];
}

-(void)confirm
{
    if (self.current) {
        [self.current unSelect];
        [self.current removeFromParentAndCleanup:YES];
        self.current = nil;
    }
    [self.structure unSelect];
    [self keepCircle];
}

-(void)cancel
{
    if (!self.current) {
        self.current.visible = YES;
    }
    [self.structure unSelect];
    [self.structure removeFromParentAndCleanup:YES];
    self.structure=nil;
    [self keepCircle];
}
@end
