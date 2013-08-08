//
//  Structure.m
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

#import "Structure.h"
#import "IsometricOperator.h"
#import "InfoPanel.h"
#import "ConfirmMenu.h"
#import "UpgradeMenu.h"
//#import "GameLayer.h"
#import "FightLayer.h"
#import "BuildLayer.h"

@interface Structure () {
    NSString* name;
    BOOL canBeMoved;
    BOOL isSelected;
    UIGestureRecognizer* pan;
    CCSprite* downArrows;
    CGSize structureSize;
    CGSize winSize;
    CGPoint vert[4];
    BOOL checked;
    BOOL isValid;
    BOOL isChecking;
    CGPoint validPoint;
    BOOL isRed;
    id uilayer;
    id info_panel;
    id gamelayer;
    id confirm_menu;
    id menu;
}
@end

@implementation Structure
@synthesize gridPosition,cost,spriteFile,array;

static BOOL isSelectedGlobal;
static NSMutableArray* threadArray;

-(void)onEnter
{
    [super onEnter];
    [self.texture setAntiAliasTexParameters];
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
    [pan setEnabled:YES];
    pan.delegate = self;
    isSelectedGlobal = NO;
    self.isTouchEnabled = YES;
    vert[0] = [IsometricOperator gridToCoord:ccp(0,0)];
    vert[1] = [IsometricOperator gridToCoord:ccp(0,1)];
    vert[2] = [IsometricOperator gridToCoord:ccp(1,1)];
    vert[3] = [IsometricOperator gridToCoord:ccp(1,0)];

    isSelected = NO;
    threadArray = [[NSMutableArray alloc]init];

    winSize = [[CCDirector sharedDirector]winSize];
    gamelayer = [[self parent] parent];
    uilayer = [[gamelayer parent]getChildByTag:2];
    if ([[gamelayer fightOrBuild] isEqualToString:@"fight"]) {
        self.array = [gamelayer getUnitArray];
        [self setCanBeMoved:NO];
    }
    else {
        [self setCanBeMoved:YES];
        if (!checked) {
            [self performSelectorInBackground:@selector(checkValidPosition) withObject:nil];
        }
    }
}

-(void)draw
{
    [super draw];
    if (isRed) {
        isRed = NO;
        [self setColor:ccWHITE];
    }
    if (!isValid) {
        [self setColor:ccc3(192, 57, 43)];
        isRed = YES;
    }
    
}

-(void)checkValidPosition
{
    if ([threadArray count]>0) {
        for (NSMutableDictionary* dict in threadArray) {
            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"ThreadShouldExitNow"];
        }
        [threadArray removeAllObjects];
    }
    
    NSMutableDictionary* threadDict = [[NSThread currentThread]threadDictionary];
    [threadDict setValue:[NSNumber numberWithBool:NO] forKey:@"ThreadShouldExitNow"];
    [threadArray addObject:threadDict];
    
    for (NSValue* points in gridPosition) {
        if (![gamelayer isValidGrid:[points CGPointValue]]) {
            checked = YES;
            isValid = NO;
            return;
        }
    }
    Byte test = [gamelayer isConnected:gridPosition];
    if (test == 2) {
        return;
    }
    if (test==0) {
        checked = YES;
        isValid = NO;
        return;
    }
    checked = YES;
    isValid = YES;
}

-(void)unSelect
{
    [self setOpacity:255];
    isSelected = NO;
    isSelectedGlobal = NO;
    [pan setEnabled:NO];
    [info_panel removeFromParentAndCleanup:YES];
    [confirm_menu keepCircle];
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self tap:gesture];
}

-(void)tap:(UITapGestureRecognizer*)gesture
{
    if (canBeMoved) {
        if (isSelected) {
            [self unSelect];
            [[gamelayer filledList]addObject:self];
        }
        else if (!isSelectedGlobal) {
            if (![[self getName]isEqual:@"Wall"]) {
                info_panel = [[InfoPanel alloc]initWithStructure:self];
                [uilayer addChild:info_panel];
            }
            [self setOpacity:100];
            [downArrows setVisible:YES];
            isSelectedGlobal = YES;
            isSelected = YES;
            [pan setEnabled:YES];
            [[gamelayer filledList]removeObject:self];
        }
    }
    else return;
}

-(void)createMenuAfterTouch
{

    CGPoint touchLocation = self.position;
    //    NSLog(@"%@",NSStringFromCGPoint([IsometricOperator gridNumber:touchLocation]));
    touchLocation = ccpAdd(touchLocation, ccp(0,11.31*2));
    
    menu = [[[gamelayer parent]getChildByTag:2]getChildByTag:1];
    confirm_menu = [[[gamelayer parent]getChildByTag:2]getChildByTag:2];
    if ([[[menu children]objectAtIndex:0] numberOfRunningActions]>0) {
        return;
    }
    if ([confirm_menu isSelected]) {
        return;
    }
    if ([gamelayer closeMenu]);
    else {
        if ([Structure isSelectedGlobally]) {
            return;
        }
        UpgradeMenu* upgrademenu = [[UpgradeMenu alloc]initWithCurrent:self andStrings:@"FireTower2",nil ];
        [uilayer addChild:upgrademenu z:3 tag:3];
        CGPoint mid = [gamelayer convertToNodeSpace:ccp(winSize.width/2,winSize.height/2)];
        CGPoint moveby = ccpMult(ccpSub(mid, touchLocation),[gamelayer scaleX]);
        float dist = ccpDistance(ccp(0,0), moveby);
        id move = [CCMoveBy actionWithDuration:dist/700 position:moveby];
        id ease = [CCEaseOut actionWithAction:move rate:0.5];
        id popMenu = [CCCallFunc actionWithTarget:upgrademenu selector:@selector(arrangeCircle)];
        [gamelayer runAction:[CCSequence actions:ease, popMenu, nil]];
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        validPoint = self.position;
    }
    
    if (isSelected) {
        CGPoint translation = [gesture translationInView:gesture.view];
        translation.y *= -1;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        translation = ccpMult(translation, 1/[[self parent]parent].scale);
        self.tempPosition = ccpAdd(self.tempPosition, translation);
        CGPoint newPoint = [IsometricOperator nearestPoint:self.tempPosition];
        if (!CGPointEqualToPoint(newPoint,self.position)) {
            [self setPosition:newPoint];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded && checked) {
        if (!isValid) {
            self.tempPosition = validPoint;
            [self setPosition:validPoint];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded){
        if (!isChecking) {
            isChecking = YES;
            [self schedule:@selector(continueChecking)];
        }
    }
}

-(void)continueChecking
{
    if (!checked) {
        return;
    }
    else if (!isValid){
        self.tempPosition = validPoint;
        [self setPosition:validPoint];
        [self unschedule:@selector(continueChecking)];
        isChecking = NO;
    }
    else {
        [self unschedule:@selector(continueChecking)];
        isChecking = NO;
    }
}

-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    checked=NO;
    self.gridPosition = [self createGridPosition:position];
    [[self parent] reorderChild:self z:[self getZHeight]];
    if (isSelected&&!checked) {
        [self performSelectorInBackground:@selector(checkValidPosition) withObject:nil];
    }
}

-(NSArray*)createGridPosition:(CGPoint)point
{
    CGPoint baseGrid = [IsometricOperator gridNumber:point];
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (int h = 0; h < structureSize.height; h++) {
        for (int w = 0; w < structureSize.width; w++) {
            
            [tempArray addObject:[NSValue valueWithCGPoint:ccp(baseGrid.x-w,baseGrid.y+h)]];
        }
    }
    return [tempArray copy];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%f, %f, %@",self.position.x,self.position.y,name];
}

-(void)setName:(NSString*)n
{
    name = n;
}

-(NSString*)getName
{
    return name;
}

-(void)setCanBeMoved:(BOOL)b
{
    canBeMoved = b;
}

-(void)setSize:(CGSize)size
{
    structureSize = size;
}

-(float)getZHeight
{
    if (structureSize.height>1) {
        return -self.position.y-(contentSize_.height/4);
    }
    else return -self.position.y;
}

-(void)sell
{
    [ResourceLabel addGoldBy:self.cost];
    [[gamelayer filledList]removeObject:self];
    [self removeFromParentAndCleanup:YES];
}

-(void)onExit
{
    [super onExit];
    [self unscheduleAllSelectors];
    [self removeAllChildrenWithCleanup:YES];
}

+(int)cost
{
    mustOverride();
}

-(float)dps
{
    return 0;
}

-(NSString*)aoe
{
    return nil;
}

+(BOOL)isSelectedGlobally
{
    return isSelectedGlobal;
}

+(void)setIsSelectedGlobally:(BOOL)bool_
{
    isSelectedGlobal = bool_;
}

-(void)removeFromParentAndCleanup:(BOOL)cleanup
{
    [super removeFromParentAndCleanup:cleanup];
    if (isSelected){
        [self unSelect];
    }
}
@end
