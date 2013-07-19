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


@interface Structure () {
    NSString* name;
    CGPoint tempPosition; //used for snapping to grid
    BOOL canBeMoved;
    BOOL isSelected;
    UIGestureRecognizer* pan;
    CCSprite* downArrows;
    CGSize structureSize;
    CGPoint vert[4];
}
@end

@implementation Structure
@synthesize gridPosition,cost;

static BOOL isSelectedGlobal;

//-(id)initWithFile:(NSString *)filename {
//    self=[super initWithFile:filename];
//    if (![ResourceLabel subtractGoldBy:self.cost]) {
//        return nil;
//    }
//    else {
//        return self;
//    }
//}
-(void)onEnter
{
    [super onEnter];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
    [pan setEnabled:YES];
    pan.delegate = self;
    isSelectedGlobal = NO;
    
    vert[0] = [IsometricOperator gridToCoord:ccp(0,0)];
    vert[1] = [IsometricOperator gridToCoord:ccp(0,1)];
    vert[2] = [IsometricOperator gridToCoord:ccp(1,1)];
    vert[3] = [IsometricOperator gridToCoord:ccp(1,0)];
    
    if (canBeMoved) {
        self.isTouchEnabled = YES;
        [self setOpacity:100];
        isSelected = YES;
        tempPosition = self.position;
    }
}

-(void)draw
{
    [super draw];
    if (isSelected) {
        for (NSValue* points in [self createGridPosition:self.position]) {
            if (![GameLayer isValidGrid:[points CGPointValue]]) {
                ccDrawSolidPoly(vert, 4, ccc4f(255, 0, 0, 0.1));
                break;
            }
        }
        
    }


}

-(void)unSelect
{
    [self setOpacity:255];
    isSelected = NO;
    isSelectedGlobal = NO;
    [pan setEnabled:NO];
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (canBeMoved) {
        if (isSelected) {
            [self unSelect];
            [[GameLayer getFilledArray]addObject:self];
        }
        else if (!isSelectedGlobal) {
            [self setOpacity:100];
            [downArrows setVisible:YES];
            isSelectedGlobal = YES;
            isSelected = YES;
            [pan setEnabled:YES];
            [[GameLayer getFilledArray]removeObject:self];
        }
    }
    else return;
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (isSelected) {
//        NSLog(@"%f",self.scale);
        CGPoint translation = [gesture translationInView:gesture.view];
        translation.y *= -1;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        translation = ccpMult(translation, 1/[[self parent]parent].scale);
        tempPosition = ccpAdd(tempPosition, translation);
        CGPoint newPoint = [IsometricOperator nearestPoint:tempPosition];
        [self setPosition:newPoint];
//        if (!CGPointEqualToPoint(newPoint,self.position)) {
//            for (NSValue* points in [self createGridPosition:newPoint]) {
//                if (![GameLayer isValidGrid:[points CGPointValue]]) {
//                    return;
//                }
//            }
//            [self setPosition:newPoint];
//        }
    }
    
    else {
        
    }
}

-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    self.gridPosition = [self createGridPosition:position];
    [[self parent] reorderChild:self z:[self getZHeight]];
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

-(void)onExit
{
    [super onExit];
    [ResourceLabel addGoldBy:self.cost];
}

+(int)cost
{
    mustOverride();
}

+(BOOL)isSelectedGlobally
{
    return isSelectedGlobal;
}

+(void)setIsSelectedGlobally:(BOOL)bool_
{
    isSelectedGlobal = bool_;
}
@end
