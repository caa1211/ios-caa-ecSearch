//
//  PcHomeSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "PcHomeSearch.h"
#import <AFHTTPRequestOperationManager.h>

@interface PcHomeSearch ()
    @property(nonatomic, strong) AFHTTPRequestOperationManager *requestMamager;
@end


@implementation PcHome24Item
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"name": @"title",
                                                       @"picS": @"imageUrl",
                                                       @"Id": @"url",
                                                       @"describe": @"desc",
                                                       @"price": @"price"
                                                       }];
}

-(void)setImageUrl:(NSString*)url
{
    NSString *baseImageUrlStr = @"http://ec1img.pchome.com.tw";
    url = [baseImageUrlStr stringByAppendingString:url];
    [super setImageUrl:url];
}

-(void)setUrl:(NSString*)url
{
    NSString *baseUrlStr = @"http://24h.pchome.com.tw/prod/";
    url = [baseUrlStr stringByAppendingString:url];
    [super setUrl:url];
}

@end



@implementation PcHomeSearch

-(NSString *) propertyName {
    return @"PCHome";
}

-(id)init {
    self = [super init];
    if(self){
        self.requestMamager = [[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}

-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
 
    
    [self.requestMamager GET:@"http://ecshweb.pchome.com.tw/search/v3.3/all/results" parameters:@{@"q": keyword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSArray *itemAry = responseObject[@"prods"];
        NSMutableArray* resAry = [[NSMutableArray alloc]init];
        for (NSDictionary *itemRaw in itemAry) {
            
            NSError *err;
            PcHome24Item *item = [[PcHome24Item alloc]initWithDictionary:itemRaw error:&err];
            item.property = self.propertyName;
            [resAry addObject:item];
        }
        
        completion(resAry, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }] ;
    
     
}

@end
