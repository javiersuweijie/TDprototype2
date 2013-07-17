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
IOOObject* ioObject;

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
//    [filledList addObject:tree]; //commented out else units cant find path
    
    float translate = 22.627*14;
    
    vert[0] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, 0)]);
    vert[1] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width, 0)]);
    vert[2] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width, winSize.height*1.5)]);
    vert[3] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, winSize.height*1.5)]);
    
    CCSprite* background = [CCSprite spriteWithFile:@"gridfloor.png"];
    [background setPosition:vert[0]];
    [background setAnchorPoint:ccp(0,0.5)];
    [background setColor:ccc3(129, 229, 0)];
    [self addChild:background z:-1000];
    
    context = UIGraphicsGetCurrentContext();
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, vert[0].x, vert[0].y);
    CGPathAddLineToPoint(path, NULL, vert[1].x, vert[1].y);
    CGPathAddLineToPoint(path, NULL, vert[2].x, vert[2].y);
    CGPathAddLineToPoint(path, NULL, vert[3].x, vert[3].y);
    CGPathCloseSubpath(path);
    
    NSLog(@"%f",ccpDistance([IsometricOperator gridToCoord:ccp(0,1)], [IsometricOperator gridToCoord:ccp(1,0)]));
    
    [self schedule:@selector(gridChecker:) interval:0.5];
    
    ioObject = [[IOOObject alloc]initWithList:filledList];
}
int i = 0;
-(void)gridChecker:(ccTime)dt
{
    vert2[0] = [IsometricOperator gridToCoord:ccp(-2,i)];
    vert2[1] = [IsometricOperator gridToCoord:ccp(-2,i+1)];
    vert2[2] = [IsometricOperator gridToCoord:ccp(-2+1,i+1)];
    vert2[3] = [IsometricOperator gridToCoord:ccp(-2+1,i)];
    i++;
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    touchLocation = ccpAdd(touchLocation, ccp(0,11.31));
    if (!CGPathContainsPoint(path, NULL, touchLocation, NO) ) {
        return;
    }
    menu = [[[self parent]getChildByTag:2]getChildByTag:1];
    if ([[[menu children]objectAtIndex:0] numberOfRunningActions]>0) {
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
    if ([menu isSelected]) {
        [menu keepCircle];
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
        self.scale = MAX(self.scale, 0.5);
        self.scale = MIN(self.scale, 5);
        CGPoint newCenter = ccp(mid.x*self.scale,mid.y*self.scale);
        CGPoint delta = ccpSub(oldCenter,newCenter);
        self.position = ccpAdd(self.position, delta);
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
    [self closeMenu];
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
    else {
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
    for (Structure* structure in filledList) {
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
	if ([GameLayer isValidGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    if ([GameLayer isValidGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
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

-(void)testSP
{
    Unit* person = [[testPerson alloc]initWithPosition:vert[0] moveTo:[IsometricOperator nearestPoint:ccp(864, 316.784)]];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnFastPaper
{
    Unit* person = [[FastPaper alloc]initWithPosition:vert[0] moveTo:[IsometricOperator nearestPoint:tree.position]];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnSlowThick
{
    Unit* person = [[SlowThick alloc]initWithPosition:vert[0] moveTo:[IsometricOperator nearestPoint:tree.position]];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)spawnFlyingUnit
{
    Unit* person = [[FlyingUnit alloc]initWithPosition:vert[0] moveTo:[IsometricOperator nearestPoint:tree.position]];
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
    BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
    return sprite;
}

-(void)placeFireTower
{
    [self closeMenu];
    if (![ResourceLabel subtractGoldBy:[FireTower cost]]) {
        NSLog(@"not enough gold");
        return;
    }
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    FireTower* sprite = [[FireTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}

-(void)placeCanon
{
    [self closeMenu];
    if (![ResourceLabel subtractGoldBy:[CanonTower cost]]) {
        NSLog(@"not enough gold");
        return;
    }
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    CanonTower* sprite = [[CanonTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}

-(void)placeIce
{
    [self closeMenu];
    if (![ResourceLabel subtractGoldBy:[IceBeamTower cost]]) {
        NSLog(@"not enough gold");
        return;
    }
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    IceBeamTower* sprite = [[IceBeamTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
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
        CCSprite* sprite = [[NSClassFromString(tower) alloc] initWithPosition:CGPointFromString(key)];
        NSLog(@"%@",sprite);
        [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
        [filledList addObject:sprite];
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
    ccDrawPoly(vert, 4, YES);
    ccDrawPoly(vert2, 4, YES);
    ccPointSize(5);
    
    CGPoint mid = [self convertToNodeSpace:ccp(winSize.width/2,winSize.height/2)];
    ccDrawPoint(ccpIntersectPoint(vert[0], vert[2], vert[1], vert[3]));
    ccDrawPoint(mid);

    
}




@end
