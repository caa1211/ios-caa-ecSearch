//
//  MomoSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "MomoSearch.h"
#import "YQL.h"

@interface MomoSearch ()
  @property (strong, nonatomic) NSMutableArray *result;
  @property(nonatomic, strong) YQL* yql;
  @property(strong, nonatomic) dispatch_queue_t queryQueue;
  @property(nonatomic, strong) NSString *baseImageUrlStr;
  @property(nonatomic, strong) NSString *queryString;
@end



@implementation MomoSearchItem

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"a.href" : @"url",
                                                       @"a.img.src" : @"imageUrl",
                                                       @"tmpTitle" : @"title",
                                                       @"tmpPrice" : @"price",
                                                       @"property" : @"property",
                                                       @"desc" : @"desc"
                                                       }];
}

-(void)setImageUrl:(NSString*)url
{
    NSString *baseImageUrlStr = @"http://www.momoshop.com.tw";
    url = [baseImageUrlStr stringByAppendingString:url];
    [super setImageUrl:url];
}

@end

@implementation MomoSearch

-(id)init {
    self = [super init];
    if(self){
       self.yql = [[YQL alloc]init];
       self.queryQueue = dispatch_queue_create("momo_queue", nil);
       self.queryString = @"select * from html where url=\"http://www.momoshop.com.tw/mosearch/%@.html\" and xpath='//ul[@id=\"column\"]/li'";
       self.baseImageUrlStr = @"http://www.momoshop.com.tw";
    }
    return self;
}


-(NSMutableArray *) searchWithKeyword:(NSString*)keyword {
    NSString* queryKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* queryStr = [NSString stringWithFormat:self.queryString,queryKeyword];
    
    NSDictionary *results = [self.yql query:queryStr];
    NSMutableArray* resAry = [[NSMutableArray alloc]init];

    if ( ![results[@"query"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"][@"li"] isEqual:[NSNull null]])
    {
        NSArray *itemAry = results[@"query"][@"results"][@"li"];
        
        for (NSDictionary *itemRaw in itemAry) {
            NSError *err;
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:itemRaw];
            
            if ([itemRaw[@"p"] isKindOfClass:[NSArray class]]){
                [dic setValue:itemRaw[@"p"][0][@"a"][@"title"] forKey:@"tmpTitle"];
                
                if ([dic[@"p"][1][@"span"] isKindOfClass:[NSArray class]]) {
                    [dic setValue:itemRaw[@"p"][1][@"span"][0][@"b"][@"content"] forKey:@"tmpPrice"];
                }
            }
            
            [dic setObject:@"" forKey:@"desc"];
            [dic setObject:@"Momo" forKey:@"property"];
            
            MomoSearchItem *momoitem = [[MomoSearchItem alloc]initWithDictionary:dic error:&err];
            [resAry addObject:momoitem];
        }
        
    }
    
    return resAry;
}

-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
    
    dispatch_async(self.queryQueue, ^{
        
        NSMutableArray* resAry = [self searchWithKeyword:keyword];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(resAry, nil);
        });
        
    });
}


@end
