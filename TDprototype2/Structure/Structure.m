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
}
@end

@implementation Structure
@synthesize gridPosition,cost;

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

    
    if (canBeMoved) {
        self.isTouchEnabled = YES;
//        [self setOpacity:100];
//        isSelected = YES;
        tempPosition = self.position;
    }
}

-(void)unSelect
{
    [self setOpacity:255];
    [downArrows setVisible:NO];
    isSelected = NO;
    [pan setEnabled:NO];
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (canBeMoved) {
        if (isSelected) {
            [self unSelect];
            [[GameLayer getFilledArray]addObject:self];
        }
        else {
            [self setOpacity:100];
            [downArrows setVisible:YES];
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
        CGPoint translation = [gesture translationInView:gesture.view];
        translation.y *= -1;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        tempPosition = ccpAdd(tempPosition, translation);
        CGPoint newPoint = [IsometricOperator nearestPoint:tempPosition];
        if (!CGPointEqualToPoint(newPoint,self.position)) {
            for (NSValue* points in [self createGridPosition:newPoint]) {
                if (![GameLayer isValidGrid:[points CGPointValue]]) {
                    return;
                }
            }
            [self setPosition:newPoint];
        }
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
@end
