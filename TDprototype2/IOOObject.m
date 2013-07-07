//
//  IOObject.m
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//
//

#import "IOOObject.h"
#import "Structure.h"

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;    
}
@end

@implementation IOOObject
NSArray* list_;

-(id)initWithList:(NSArray*)list {
    if (self=[super init]) {
        list_=list;
    }
    return self;
}

-(NSString*)exportStructureListFrom:(NSArray*)filledList
{
    NSMutableDictionary* array = [[NSMutableDictionary alloc]init];
    for (Structure* structure in filledList) {
        [array setObject:[structure getName]  forKey:NSStringFromCGPoint(structure.position)];
    }
    NSData* data = [array toJSON];
    NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(string);
    return string;
}

-(void)sendData
{
    NSString *post = [NSString stringWithFormat:@"api_key=%@&game_id=%@&response=%@&username=%@key=%@value=%@",
                      [self urlEncodeValue:@"c3980e65244e55d733f5bec89d54b71b9c708cd1"]
                      ,[self urlEncodeValue:@"70c2bee046"]
                      ,[self urlEncodeValue:@"json"]
                      ,[self urlEncodeValue:@"javier"]
                      ,[self urlEncodeValue:@"game_state"]
                      ,[self urlEncodeValue:[self exportStructureListFrom:list_]]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.scoreoid.com/v1/setPlayerData"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    id a=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    a=nil;
}
                                    
- (NSString *)urlEncodeValue:(NSString *)str
    {
        NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
        return result;
    }
@end
