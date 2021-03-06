//
//  UILayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"
#import "ResourceLabel.h"
#import "Structure Menu.h"
#import "ConfirmMenu.h"
#import "UpgradeMenu.h"
#import "FightButton.h"

@implementation UILayer
CGSize winSize;
UIGestureRecognizer *tapGestureRecognizer;
Structure_Menu* menu;
ConfirmMenu* confirmMenu;
-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector]winSize];
    menu = [[Structure_Menu alloc]init];
    [self addChild:menu z:1 tag:1];
    
    confirmMenu = [[ConfirmMenu alloc]init];
    [self addChild:confirmMenu z:2 tag:2];
    
    id resource = [[ResourceLabel alloc]init];
    [self addChild:resource];
    
    [menu setConfirmMenu:confirmMenu];
    
    FightButton *fight_button = [FightButton node];
    [self addChild:fight_button];

//    UnitMenu* unit_menu = [UnitMenu node];
//    [self addChild:unit_menu];
}

-(id)addUpgradeMenuOf:(Structure*)prev to:(NSString*)string, ...
{
    return nil;
}
@end
