//
//  UpgradeMenu.m
//  TDprototype2
//
//  Created by Javiersu on 21/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UpgradeMenu.h"
#import "GameLayer.h"
#import "CustomMenu.h"
#import "CustomMenuItem.h"
#import "ConfirmMenu.h"

@implementation UpgradeMenu
@synthesize current;
id game_layer;
id confirm_menu;
float left_padding = 10;
NSMutableArray* stringArray;

- (id) initWithCurrent:(id)current_ andStrings:(NSString*)string1, ... {
    stringArray = [[NSMutableArray alloc]init];
    va_list args;
    va_start(args, string1);
    NSMutableArray *buttonArray = [[NSMutableArray alloc]init];
    [self addExtraButtons:buttonArray withString:string1 vaList:args];
    va_end(args);
    
    [self addDefaultButtons:buttonArray];
    
    self = [super initWithArray:[NSArray arrayWithArray:buttonArray]];
    
    self.current = current_;
    return self;
}

-(void)addExtraButtons:(NSMutableArray*)buttonArray withString:(NSString*)string1 vaList: (va_list) args
{
    CustomMenuItem * menuItem = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:NSSelectorFromString([NSString stringWithFormat:@"do1Action"])];
    CCLabelTTF* label = [CCLabelTTF labelWithString:string1 fontName:@"Helvetica" fontSize:8];
    [label setAnchorPoint:ccp(0,0)];
    [label setPosition:ccp(left_padding, 0)];
    [menuItem addChild:label];
    [stringArray addObject:string1];
    [buttonArray addObject:menuItem];
    
    NSString *string;
    short i=2;
    while((string = va_arg(args, id))) {
        CustomMenuItem * menuItem = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:NSSelectorFromString([NSString stringWithFormat:@"do%dAction",i])];
        CCLabelTTF* label = [CCLabelTTF labelWithString:string fontName:@"Helvetica" fontSize:8];
        [label setAnchorPoint:ccp(0,0)];
        [label setPosition:ccp(left_padding, 0)];
        [menuItem addChild:label];
        [stringArray addObject:string];
        [buttonArray addObject:menuItem];
        i++;
    }
}

-(void)addDefaultButtons:(NSMutableArray*)buttonArray
{
    CustomMenuItem * sell = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(sell)];
    CCLabelTTF* sellLabel = [CCLabelTTF labelWithString:@"Sell" fontName:@"Helvetica" fontSize:8];
    [sellLabel setAnchorPoint:ccp(0,0)];
    [sellLabel setPosition:ccp(left_padding, 0)];
    [sell addChild:sellLabel];
    [buttonArray addObject:sell];
}

-(void)onEnter
{
    [super onEnter];
    game_layer = [[[self parent]parent]getChildByTag:1];
    [self setPosition:ccp([[CCDirector sharedDirector]winSize].width/2, [[CCDirector sharedDirector]winSize].height/2)];
}

-(void) do1Action
{
    NSLog(@"touched 1 by %@",self.current);
    [self keepCircle];
    [confirm_menu openWithStructure:[game_layer placeTower:[stringArray objectAtIndex:0]]andCurrent:self.current];
}
-(void) do2Action
{
    NSLog(@"touched 2");
    [self keepCircle];
    [confirm_menu openWithStructure:[game_layer placeTower:[stringArray objectAtIndex:1]]andCurrent:self.current];
}
-(void) do3Action
{
    NSLog(@"touched 3");
    [self keepCircle];
    [confirm_menu openWithStructure:[game_layer placeTower:[stringArray objectAtIndex:2]]andCurrent:self.current];
}
-(void) do4Action
{
    NSLog(@"touched 4");
    [self keepCircle];
    [confirm_menu openWithStructure:[game_layer placeTower:[stringArray objectAtIndex:3]]andCurrent:self.current];
}
-(void) sell
{
    [self.current sell];
    [self keepCircle];
}

@end
