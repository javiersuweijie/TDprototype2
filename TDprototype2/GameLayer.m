//
//  GameLayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "IsometricOperator.h"
#import "ResourceLabel.h"
#import "CustomMenu.h"
#import "IOOObject.h"

#import "Structure.h"
#import "BasicBlock.h"
#import "FireTower.h"
#import "WorldTree.h"
#import "CanonTower.h"
#import "IceBeamTower.h"
#import "DummyTower.h"
#import "Wall.h"

#import "testPerson.h"
#import "FastPaper.h"
#import "SlowThick.h"
#import "FlyingUnit.h"

@interface GameLayer () {

    
}

@end

@implementation GameLayer
static NSMutableArray* filledList;
static NSMutableArray* unitList;
static CCLayer* unitAndBoxLayer;
static CGSize winSize;
static CGMutablePathRef path;
static CGMutablePathRef unitPath;

BOOL buildingMode = NO;
CCLayer* buildingLayer;
WorldTree* tree;
CGPoint startPoint;
CGPoint endPoint;
CGPoint vert[4];
CGPoint borderVert[4];
CGPoint vert2[4];
NSMutableArray* buildingArray;
CGContextRef context;
id menu;
id confirm_menu;
id upgrade_menu;
IOOObject* ioObject;
BOOL resultFound = NO;

CGPoint targetPoint;
CGPoint unitEndPoint;
-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector] winSize]; 
//    self.contentSize = CGSizeApplyAffineTransform([[CCDirector sharedDirector] winSize],CGAffineTransformMakeScale(2, 2));
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
    self.isTouchEnabled = YES;
//    self.scale = 1.4;
    
    filledList = [[NSMutableArray alloc]init];
    unitList = [[NSMutableArray alloc]init];
    [IsometricOperator init];
    unitAndBoxLayer = [CCLayer node];
    [unitAndBoxLayer setAnchorPoint:ccp(0,0)];
    [self addChild:unitAndBoxLayer];
    [self setAnchorPoint:ccp(0,0)];
    [self setPosition:ccp(0,-151)];
//    [filledList addObject:tree]; //commented out else units cant find path
    
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
    
    NSLog(@"width of map:%f",ccpDistance(vert[0], vert[2]));
    
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
    
    NSLog(@"%f",ccpDistance([IsometricOperator gridToCoord:ccp(0,1)], [IsometricOperator gridToCoord:ccp(1,0)]));
    
    ioObject = [[IOOObject alloc]initWithList:filledList];
    
    targetPoint = [IsometricOperator gridToCoord:ccp(-6,29)];
    unitEndPoint = [IsometricOperator gridToCoord:ccp(-6,13)];
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    NSLog(@"%@",NSStringFromCGPoint([IsometricOperator gridNumber:touchLocation]));
    touchLocation = ccpAdd(touchLocation, ccp(0,11.31));

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
//        if ((scale>1 && self.scale>5.0)||(scale<1 && self.scale<1));
//        else {
//            NSLog(@"%@",NSStringFromCGPoint(mid));
//            self.anchorPoint = mid;
//            self.scale *= scale;
//        
//        }
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

//-(void)draw {
//    ccDrawPoly(vert, 4, YES);
////    ccDrawSolidRect(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height), ccc4FFromccc3B(ccGRAY));
////    ccDrawPoly(vert2, 4, YES);
//    if (buildingMode && !CGPointEqualToPoint(endPoint, startPoint)) {
//        ccDrawLine(startPoint, endPoint);
//    }
//}

-(void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{

    if (buildingMode) {

        if (aPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            startPoint = [aPanGestureRecognizer locationOfTouch:0 inView:[aPanGestureRecognizer view]];
            startPoint = [[CCDirector sharedDirector]convertToGL:startPoint];
            startPoint = [self convertToNodeSpace:startPoint];
            endPoint = startPoint;
        }
        if (aPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            endPoint = [aPanGestureRecognizer locationOfTouch:0 inView:[aPanGestureRecognizer view]];
            endPoint = [[CCDirector sharedDirector]convertToGL:endPoint];
            endPoint = [self convertToNodeSpace:endPoint];
            for (id block in [buildingLayer children]) {
                [filledList removeObject:block];
            }
            for (id block in buildingArray) {
                [block setVisible:NO];
            }
            float angle1 =  ccpAngleSigned(ccp(1,0),ccpSub(endPoint,startPoint));
            int j = 0;
            for (int dist=0; dist<ccpDistance(startPoint, endPoint); dist+=9) {
                if (j>19) {
                    break;
                }
                CGPoint place = ccpAdd(startPoint,ccp(dist*cos(angle1), dist*sin(angle1)));
                place = [IsometricOperator nearestPoint:place];
                if ([GameLayer isValid:place]) {
                    Structure* block = buildingArray[j];
                    for (Structure* block2 in buildingArray) {
                        if (block2.visible&&CGPointEqualToPoint([block position], [block2 position])) {
                            break;
                        }
                        else {
                            [block setPosition:place];
                            [block setVisible:YES];
                            [block unSelect];
                        }
                    }

                    j++;
                }
                
            }
        }
    }
    else if (![confirm_menu isSelected]){
        [self closeMenu];
        CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
        translation.y *= -1;
        [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
//        if ([self convertToNodeSpace:CGPointZero].x<0&&translation.x>0) {
//        }
//        else if ([self convertToNodeSpace:CGPointZero].y<0&&translation.y>0) {
//        }
//        else if ([self convertToNodeSpace:ccp(winSize.width, winSize.height)].x>winSize.width&&translation.x<0) {
//        }
//        else if ([self convertToNodeSpace:ccp(winSize.width, winSize.height)].y>winSize.height&&translation.y<0) {
//        }
//        else {
        self.position = ccpAdd(self.position, translation);
        self.position = ccp(self.position.x,MAX(-167*(self.scale)-(ccpDistance(vert[1], vert[3])-20)*(self.scale-1), self.position.y));
        
        self.position = ccp(self.position.x,MIN(-148*self.scale, self.position.y));
        self.position = ccp(MAX(-ccpDistance(vert[0], vert[2])*(self.scale-1),self.position.x),self.position.y);
        self.position = ccp(MIN(0,self.position.x),self.position.y);
        NSLog(@"%@",NSStringFromCGPoint(self.position));
        NSLog(@"%f",-ccpDistance(vert[0], vert[2])*self.scale);
        NSLog(@"%f",-ccpDistance(vert[1], vert[3])*self.scale);
        
//        }

    }
    if ([aPanGestureRecognizer state]==UIGestureRecognizerStateEnded) {
        buildingMode = NO;
        startPoint = CGPointZero;
        endPoint = CGPointZero;
        for (Structure* block in buildingArray) {
            [filledList removeObject:block];
            if (block.visible) {
                [buildingLayer removeChild:block cleanup:NO];
                [unitAndBoxLayer addChild:block];
                [block unSelect];
                [filledList addObject:block];
            }
        }
        [buildingArray removeAllObjects];
        [buildingLayer removeAllChildrenWithCleanup:YES];
    }
}

+(BOOL)isValid:(CGPoint)point
{
    CGPoint touchGrid = [IsometricOperator gridNumber:point];
    return [GameLayer isValidGrid:touchGrid];
}

+(BOOL)isValidGrid:(CGPoint)grid
{
    if (!CGPathContainsPoint(path, NULL, [IsometricOperator gridToCoord:grid], NO) ) {
        return NO;
    }
    for (Structure* structure in [filledList copy]) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
        
        }
    }
    return YES;
}

+(BOOL)isValidUnitGrid:(CGPoint)grid
{
    if (!CGPathContainsPoint(unitPath, NULL, [IsometricOperator gridToCoord:grid], NO) ) {
        return NO;
    }
    for (Structure* structure in [filledList copy]) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
            
        }
    }
    return YES;
}


+(NSArray*)walkableAdjGrid:(CGPoint)grid
{

    
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);

    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);

	// Left
    CGPoint left = ccp(grid.x-1,grid.y);
    if ([GameLayer isValidGrid:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([GameLayer isValidGrid:top]) {
            CGPoint topleft = ccp(grid.x-1,grid.y+1);
            if ([GameLayer isValidGrid:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([GameLayer isValidGrid:bottom]) {
            CGPoint bottomleft = ccp(grid.x-1,grid.y-1);
            if ([GameLayer isValidGrid:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }
    
    if ([GameLayer isValidGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
    
    if ([GameLayer isValidGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    
	// Right
    CGPoint right = ccp(grid.x+1,grid.y);
    if ([GameLayer isValidGrid:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([GameLayer isValidGrid:top]) {
            CGPoint topright = ccp(grid.x+1,grid.y+1);
            if ([GameLayer isValidGrid:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([GameLayer isValidGrid:bottom]) {
            CGPoint bottomright = ccp(grid.x+1,grid.y-1);
            if ([GameLayer isValidGrid:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
	return [NSArray arrayWithArray:tmpArray];
    
}


+(NSArray*)walkableAdjUnitGrid:(CGPoint)grid
{
    
    
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);
    
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    
	// Left
    CGPoint left = ccp(grid.x-1,grid.y);
    if ([GameLayer isValidUnitGrid:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([GameLayer isValidUnitGrid:top]) {
            CGPoint topleft = ccp(grid.x-1,grid.y+1);
            if ([GameLayer isValidUnitGrid:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([GameLayer isValidUnitGrid:bottom]) {
            CGPoint bottomleft = ccp(grid.x-1,grid.y-1);
            if ([GameLayer isValidUnitGrid:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }
    
    if ([GameLayer isValidUnitGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
    
    if ([GameLayer isValidUnitGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    
	// Right
    CGPoint right = ccp(grid.x+1,grid.y);
    if ([GameLayer isValidUnitGrid:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([GameLayer isValidUnitGrid:top]) {
            CGPoint topright = ccp(grid.x+1,grid.y+1);
            if ([GameLayer isValidUnitGrid:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([GameLayer isValidUnitGrid:bottom]) {
            CGPoint bottomright = ccp(grid.x+1,grid.y-1);
            if ([GameLayer isValidUnitGrid:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
	return [NSArray arrayWithArray:tmpArray];
    
}


+(Byte)isConnected:(NSArray*)gridArray
{
    BOOL exitNow = NO;
    
    NSMutableArray* stack = [[NSMutableArray alloc]init];
    NSMutableArray* connected = [[NSMutableArray alloc]init];
    NSMutableArray* adj = [NSMutableArray arrayWithArray:[GameLayer walkableAdjUnitGrid:(ccp(-6,29))]];
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
        NSArray* tempArray = [GameLayer walkableAdjUnitGrid:[tempValue CGPointValue]];
        for (NSValue* temp in tempArray) {
            if ([gridArray containsObject:temp]) {}
            else if ([temp isEqualToValue:[NSValue valueWithCGPoint:ccp(-6,13)]]) {
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

-(void)testSP
{
    Unit* person = [[testPerson alloc]initWithPosition:unitEndPoint moveTo:targetPoint];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnFastPaper
{
    Unit* person = [[FastPaper alloc]initWithPosition:unitEndPoint moveTo:targetPoint];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnSlowThick
{
    Unit* person = [[SlowThick alloc]initWithPosition:unitEndPoint moveTo:targetPoint];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnFlyingUnit
{
    Unit* person = [[FlyingUnit alloc]initWithPosition:unitEndPoint moveTo:targetPoint];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)placeBlueTileAt:(CGPoint)point
{
    CGPoint ppoint = [unitAndBoxLayer convertToNodeSpace:point];
    BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:ppoint];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}
-(id)placeBlueTile
{
//    buildingMode = YES;
//    buildingArray = [[NSMutableArray alloc]init];
//    buildingLayer = [CCLayer node];
//    [self addChild:buildingLayer];
//    for (int i= 0;i<20;i++) {
//        id block = [[BasicBlock alloc]initWithPosition:ccp(-100, -100)];
//        [block setVisible:NO];
//        [filledList addObject:block];
//        [buildingArray addObject:block];
//        [buildingLayer addChild:block];
//    }
    [self closeMenu];
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
//    BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:touchLocation];
    Structure* sprite = [[Wall alloc]initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
    return sprite;
}

-(id)placeFireTower
{
    if (![ResourceLabel subtractGoldBy:[FireTower cost]]) {
        NSLog(@"not enough gold");
        return nil;
    }
    [self closeMenu];
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    FireTower* sprite = [[FireTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
    return sprite;
}

-(id)placeCanon
{
    if (![ResourceLabel subtractGoldBy:[CanonTower cost]]) {
        NSLog(@"not enough gold");
        return nil;
    }
    [self closeMenu];
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    CanonTower* sprite = [[CanonTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
    return sprite;
}

-(id)placeIce
{
    if (![ResourceLabel subtractGoldBy:[IceBeamTower cost]]) {
        NSLog(@"not enough gold");
        return nil;
    }
    [self closeMenu];
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    IceBeamTower* sprite = [[IceBeamTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
    return sprite;
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
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    if (!([[sprite getName]isEqualToString:@"DummyTower"])) {
        [filledList addObject:sprite];
    }
    return sprite;
}

-(void)exportData
{
    [ioObject exportStructureListFrom:filledList];
}

-(void)loadData
{
    NSDictionary* towerD = [ioObject load];
    for (NSString* key in towerD) {
        NSString* tower = [towerD objectForKey:key];
        NSLog(@"%@",tower);
        Structure* sprite = [[NSClassFromString(tower) alloc] initWithPosition:[IsometricOperator gridToCoord:CGPointFromString(key)]];
        NSLog(@"%@",sprite);
        [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
        [sprite performSelector:@selector(unSelect)];
        if (!([[sprite getName]isEqualToString:@"DummyTower"])) {
            [filledList addObject:sprite];
        }
    }
}

+(NSMutableArray*)getUnitArray
{
    return unitList;
}
+(NSMutableArray*)getFilledArray
{
    return filledList;
}

-(void)draw
{
//    ccDrawSolidPoly(vert, 4, ccc4f(236, 240, 241, 1));
    ccDrawPoly(vert, 4, YES);
    ccPointSize(5);
    
    CGPoint mid = [self convertToNodeSpace:ccp(winSize.width/2,winSize.height/2)];
    ccDrawPoint(ccpIntersectPoint(vert[0], vert[2], vert[1], vert[3]));
    ccDrawPoint(mid);
}

-(float)getScale
{
    return self.scale;
}


@end
