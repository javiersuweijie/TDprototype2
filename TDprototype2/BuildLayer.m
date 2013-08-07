//
//  BuildLayer.m
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BuildLayer.h"
#import "IsometricOperator.h"
#import "IOOObject.h"
#import "Structure.h"
#import "CustomMenu.h"
#import "FightScene.h"

@implementation BuildLayer

CGMutablePathRef path;
CGMutablePathRef unitPath;
CGPoint vert[4];
CGPoint vert2[4];
CGSize winSize;
CGContextRef context;
CGPoint unitEndPoint;
CGPoint unitStartPoint;
id ioObject;

id menu;
id confirm_menu;
id upgrade_menu;

@synthesize filledList,unitAndBoxLayer;
-(id)initFirst
{
    if (self=[super init]) {
        [IsometricOperator init];
        [self standardInit];
        self.unitAndBoxLayer = [CCLayer node];
        [self.unitAndBoxLayer setAnchorPoint:ccp(0,0)];
        [self addChild:self.unitAndBoxLayer];
        self.filledList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWith:(id)boxLayer and:(id)filled_list
{
    if (self=[super init]) {
        [self standardInit];
        self.filledList = filled_list;
        NSLog(@"%@",self.filledList);
        self.unitAndBoxLayer = boxLayer;
        [self.unitAndBoxLayer removeFromParentAndCleanup:NO];
        [self addChild:unitAndBoxLayer];
    }
    return self;
}

-(void)standardInit
{
    winSize = [[CCDirector sharedDirector] winSize];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    [self setContentSize:CGSizeMake(winSize.width*2, winSize.height*2)];
    [self setAnchorPoint:ccp(0,0)];
    [self setPosition:ccp(0,-151)];
    self.isTouchEnabled = YES;
    
    float translate = 22.627*14;
    float tileHeight = 16;
    
    vert2[0] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, -tileHeight)]);
    vert2[1] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, -tileHeight)]);
    vert2[2] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, winSize.height*0.75+tileHeight)]);
    vert2[3] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, winSize.height*0.75+tileHeight)]);
    
    vert[0] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, 0)]);
    vert[1] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, 0)]);
    vert[2] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, winSize.height*0.75)]);
    vert[3] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, winSize.height*0.75)]);
    
    
    CCSprite* background = [CCSprite spriteWithFile:@"background2.png"];
    [background setPosition:vert[0]];
    [background setAnchorPoint:ccp(0,0.5)];
    [self addChild:background z:-1000];
    
    context = UIGraphicsGetCurrentContext();
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, vert[0].x, vert[0].y);
    CGPathAddLineToPoint(path, NULL, vert[1].x, vert[1].y);
    CGPathAddLineToPoint(path, NULL, vert[2].x, vert[2].y);
    CGPathAddLineToPoint(path, NULL, vert[3].x, vert[3].y);
    CGPathCloseSubpath(path);
    
    unitPath = CGPathCreateMutable();
    CGPathMoveToPoint(unitPath, NULL, vert2[0].x, vert2[0].y);
    CGPathAddLineToPoint(unitPath, NULL, vert2[1].x, vert2[1].y);
    CGPathAddLineToPoint(unitPath, NULL, vert2[2].x, vert2[2].y);
    CGPathAddLineToPoint(unitPath, NULL, vert2[3].x, vert2[3].y);
    CGPathCloseSubpath(unitPath);
    
    ioObject = [[IOOObject alloc]initWithList:filledList];
    
    unitEndPoint = ccp(-6,29);
    unitStartPoint = ccp(-6,13);
}

-(void)draw
{
    [super draw];
    ccDrawPoly(vert2, 4, YES);
}

-(void)onEnter
{
    [super onEnter];
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    touchLocation = ccpAdd(touchLocation, ccp(0,11.31));
    if (!CGPathContainsPoint(unitPath, NULL, touchLocation, NO) ) {
        NSLog(@"%@",NSStringFromCGPoint([IsometricOperator gridNumber:touchLocation]));
    }
    if (!CGPathContainsPoint(path, NULL, touchLocation, NO) ) {
        return;
    }
    menu = [[[self parent]getChildByTag:2]getChildByTag:1];
    confirm_menu = [[[self parent]getChildByTag:2]getChildByTag:2];
    if ([[[menu children]objectAtIndex:0] numberOfRunningActions]>0) {
        return;
    }
    if ([confirm_menu isSelected]) {
        return;
    }
    if ([self closeMenu]);
    else {
        if ([Structure isSelectedGlobally]) {
            return;
        }
        CGPoint mid = [self convertToNodeSpace:ccp(winSize.width/2,winSize.height/2)];
        CGPoint moveby = ccpMult(ccpSub(mid, touchLocation),self.scale);
        float dist = ccpDistance(ccp(0,0), moveby);
        id move = [CCMoveBy actionWithDuration:dist/700 position:moveby];
        id ease = [CCEaseOut actionWithAction:move rate:0.5];
        id popMenu = [CCCallFunc actionWithTarget:menu selector:@selector(arrangeCircle)];
        [self runAction:[CCSequence actions:ease, popMenu, nil]];
    }
}

-(BOOL)closeMenu
{
     if (!upgrade_menu) {
        upgrade_menu = [[[self parent]getChildByTag:2]getChildByTag:3];
    }
    if ([upgrade_menu isSelected]) {
        [upgrade_menu keepCircle];
        [upgrade_menu removeFromParentAndCleanup:YES];
        upgrade_menu = nil;
        return YES;
    }
    if ([menu isSelected]) {
        [menu keepCircle];
        return YES;
    }
    if ([confirm_menu isSelected]) {
        [confirm_menu keepCircle];
        return YES;
    }
    return NO;
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer*) gesture
{
    [self closeMenu];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        if ([gesture numberOfTouches]<2) {
            return;
        }
        
        CGPoint touch1 = [gesture locationOfTouch:0 inView:[gesture view]];
        CGPoint touch2 = [gesture locationOfTouch:1 inView:[gesture view]];
        touch1 = [[CCDirector sharedDirector] convertToGL:touch1];
        touch2 = [[CCDirector sharedDirector] convertToGL:touch2];
        
        CGPoint mid = ccpMidpoint(touch1, touch2);
        mid=[self convertToNodeSpace:mid];
        float scale = gesture.scale;
        CGPoint oldCenter = ccp(mid.x*self.scale,mid.y*self.scale);
        self.scale *= scale;
        self.scale = MAX(self.scale, 1);
        self.scale = MIN(self.scale, 5);
        CGPoint newCenter = ccp(mid.x*self.scale,mid.y*self.scale);
        CGPoint delta = ccpSub(oldCenter,newCenter);
        self.position = ccpAdd(self.position, delta);
        self.position = ccp(self.position.x,MAX(-167*(self.scale)-(ccpDistance(vert[1], vert[3])+20)*(self.scale-1), self.position.y));
        
        self.position = ccp(self.position.x,MIN(-148*self.scale, self.position.y));
        self.position = ccp(MAX(-ccpDistance(vert[0], vert[2])*(self.scale-1),self.position.x),self.position.y);
        self.position = ccp(MIN(0,self.position.x),self.position.y);
        gesture.scale = 1;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    
    if (![confirm_menu isSelected]){
        [self closeMenu];
        CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
        translation.y *= -1;
        [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
        self.position = ccpAdd(self.position, translation);
        self.position = ccp(self.position.x,MAX(-167*(self.scale)-(ccpDistance(vert[1], vert[3])-20)*(self.scale-1), self.position.y));
        
        self.position = ccp(self.position.x,MIN(-148*self.scale, self.position.y));
        self.position = ccp(MAX(-ccpDistance(vert[0], vert[2])*(self.scale-1),self.position.x),self.position.y);
        self.position = ccp(MIN(0,self.position.x),self.position.y);
    }
}

-(BOOL)isValid:(CGPoint)point
{
    CGPoint touchGrid = [IsometricOperator gridNumber:point];
    return [GameLayer isValidGrid:touchGrid];
}

-(BOOL)isValidGrid:(CGPoint)grid
{
    if (!CGPathContainsPoint(path, NULL, [IsometricOperator gridToCoord:grid], NO) ) {
        return NO;
    }
    for (Structure* structure in [self.filledList copy]) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
            
        }
    }
    return YES;
}

-(BOOL)isValidUnitGrid:(CGPoint)grid
{
    if (!CGPathContainsPoint(unitPath, NULL, [IsometricOperator gridToCoord:grid], NO) ) {
//        NSLog(@"HOW COME");
        return NO;
    }
    for (Structure* structure in [self.filledList copy]) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
            
        }
    }
    return YES;
}

-(NSArray*)walkableAdjUnitGrid:(CGPoint)grid
{
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);
    
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    
	// Left
    CGPoint left = ccp(grid.x-1,grid.y);
    if ([self isValidUnitGrid:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([self isValidUnitGrid:top]) {
            CGPoint topleft = ccp(grid.x-1,grid.y+1);
            if ([self isValidUnitGrid:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([self isValidUnitGrid:bottom]) {
            CGPoint bottomleft = ccp(grid.x-1,grid.y-1);
            if ([self isValidUnitGrid:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }
    
    if ([self isValidUnitGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
    
    if ([self isValidUnitGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    
	// Right
    CGPoint right = ccp(grid.x+1,grid.y);
    if ([self isValidUnitGrid:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([self isValidUnitGrid:top]) {
            CGPoint topright = ccp(grid.x+1,grid.y+1);
            if ([self isValidUnitGrid:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([self isValidUnitGrid:bottom]) {
            CGPoint bottomright = ccp(grid.x+1,grid.y-1);
            if ([self isValidUnitGrid:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
	return [NSArray arrayWithArray:tmpArray];
    
}

-(Byte)isConnected:(NSArray*)gridArray
{
    BOOL exitNow = NO;
    
    NSMutableArray* stack = [[NSMutableArray alloc]init];
    NSMutableArray* connected = [[NSMutableArray alloc]init];
    NSMutableArray* adj = [NSMutableArray arrayWithArray:[self walkableAdjUnitGrid:unitEndPoint]];
    for (NSValue* value in gridArray) {
        [adj removeObject:value];
    }
    [stack addObjectsFromArray:adj];
    [connected addObjectsFromArray:stack];
    while ([stack count]>0) {
        exitNow = [[[[NSThread currentThread]threadDictionary]valueForKey:@"ThreadShouldExitNow"] boolValue];
        if (exitNow) {
            return 2;
        }
        NSValue* tempValue = [stack objectAtIndex:[stack count]-1];
        [stack removeLastObject];
        NSArray* tempArray = [self walkableAdjUnitGrid:[tempValue CGPointValue]];
        for (NSValue* temp in tempArray) {
            if ([gridArray containsObject:temp]) {}
            else if ([temp isEqualToValue:[NSValue valueWithCGPoint:unitStartPoint]]) {
                return 1;
            }
            else if (![connected containsObject:temp]) {
                [stack addObject:temp];
                [connected addObject:temp];
            }
            else {}
        }
    }
    return 0;
}

-(void)exportData
{
    [ioObject exportStructureListFrom:filledList];
}

-(void)loadData
{
    [self closeMenu];
    NSDictionary* towerD = [ioObject loadTower];
    for (NSString* key in towerD) {
        NSString* tower = [towerD objectForKey:key];
        Structure* sprite = [[NSClassFromString(tower) alloc] initWithPosition:[IsometricOperator gridToCoord:CGPointFromString(key)]];
        [self.unitAndBoxLayer addChild:sprite z:-sprite.position.y];
        [sprite performSelector:@selector(unSelect)];
        if (![tower isEqualToString:@"DummyTower"]) {
            [self.filledList addObject:sprite];
        }
    }
}

-(void)loadUnit
{
    FightScene* scene = [FightScene sceneWith:unitAndBoxLayer And:[filledList copy]];
    [[CCDirector sharedDirector]replaceScene:scene];
}

-(id)placeTower:(NSString*)tower
{
    if (![ResourceLabel subtractGoldBy:[NSClassFromString(tower) cost]]) {
        NSLog(@"not enough gold");
        return nil;
    }
    [self closeMenu];
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    Structure* sprite = [[NSClassFromString(tower) alloc] initWithPosition:touchLocation];
    [self.unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    if (![tower isEqualToString:@"DummyTower"]) {
        [self.filledList addObject:sprite];
    }
    return sprite;
}

-(NSString*)fightOrBuild
{
    return @"build";
}

@end
