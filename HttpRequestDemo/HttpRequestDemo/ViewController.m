//
//  ViewController.m
//  HttpRequestDemo
//
//  Created by 程荣刚 on 2017/10/13.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import "ViewController.h"
#import "RCHttpHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCHttpHelper sharedHelper] getUrl:@"https://httpbin.org/get" headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    [[RCHttpHelper sharedHelper] postUrl:@"https://httpbin.org/post" headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
