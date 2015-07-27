//
//  ViewController.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "ViewController.h"
#import "YQL.h"


@interface ViewController ()
@property(nonatomic, strong) YQL* yql;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yql = [[YQL alloc]init];
    
    NSString* queryKeyword = @"iphone 6";
    queryKeyword = [queryKeyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString* queryStr = @"select * from html where url=\"http://www.momoshop.com.tw/mosearch/%@.html\" and xpath='//ul[@id=\"column\"]/li'";
    queryStr = [NSString stringWithFormat:queryStr,queryKeyword];
    
    NSDictionary *results = [self.yql query:queryStr];

    NSArray *itemAry = results[@"query"][@"results"][@"li"];
    for (NSDictionary *itemRaw in itemAry) {
        NSString *property = @"Momo";
        NSString *title = itemRaw[@"p"][0][@"a"][@"title"];
        NSString *url = itemRaw[@"a"][@"href"];
        NSString *imageUrl = @"http://www.momoshop.com.tw/";
        imageUrl = [imageUrl stringByAppendingString:itemRaw[@"a"][@"img"][@"src"]];
        NSInteger price =  [itemRaw[@"p"][1][@"span"][0][@"b"][@"content"] integerValue];
        
        NSLog(@"===========================");
        NSLog(@"%@", property);
        NSLog(@"%@", title);
        NSLog(@"%@", url);
        NSLog(@"%@", imageUrl);
        NSLog(@"%ld", price);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

@end
