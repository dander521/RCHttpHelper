//
//  RCHttpHelper.m
//  HttpRequestDemo
//
//  Created by 程荣刚 on 2017/10/13.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import "RCHttpHelper.h"

@interface RCHttpHelper ()

@property (nonatomic,strong) AFHTTPSessionManager * manager;

@end

@implementation RCHttpHelper

#pragma mark - Singleton

+ (instancetype)sharedHelper {
    static RCHttpHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[RCHttpHelper alloc] init];
        }
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [RCHttpHelper defaultNetManager];
    }
    return self;
}

// 防止AFN请求造成内存泄漏
+ (AFHTTPSessionManager*)defaultNetManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        manager.requestSerializer.timeoutInterval = 60;
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"text/plain",nil];
    });
    return manager;
}

#pragma mark - Basic Request Method

/**
 Get网络请求基类
 
 @param getUrl 请求接口
 @param headParams 请求头参数
 @param bodyParams 请求体参数
 @param success 成功
 @param failure 失败
 */
- (void)getUrl:(NSString *)getUrl
    headParams:(NSDictionary *)headParams
    bodyParams:(NSDictionary*)bodyParams
       success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
       failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure {
    if (!getUrl || getUrl.length == 0) {
        return;
    }
    
    for (NSString *key in [headParams allKeys]) {
        NSString *value = [headParams objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [self.manager GET:getUrl parameters:bodyParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
        success(self.manager, returnDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self.manager, error);
    }];
}

/**
 Post网络请求基类
 
 @param postUrl 请求接口
 @param headParams 请求头参数
 @param bodyParams 请求体参数
 @param success 成功
 @param failure 失败
 */
- (void)postUrl:(NSString *)postUrl
     headParams:(NSDictionary *)headParams
     bodyParams:(NSDictionary*)bodyParams
        success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
        failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure {
    if (!postUrl || postUrl.length == 0) {
        return;
    }
    
    for (NSString *key in [headParams allKeys]) {
        NSString *value = [headParams objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [self.manager POST:postUrl parameters:bodyParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
        success(self.manager, returnDic);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self.manager,error);
    }];
}

#pragma mark - Upload Images/Video Method

/**
 Post上传单张或多张图片
 
 @param postUrl 上传接口
 @param headParams 请求头参数
 @param bodyParams 请求体参数
 @param imageKeysArray 上传图片对应服务器key
 @param imagesArray 图片数组
 @param progress 进度值
 @param success 成功
 @param failure 失败
 */
- (void)uploadPicWithPostUrl:(NSString *)postUrl
                  headParams:(NSDictionary *)headParams
                  bodyParams:(NSDictionary*)bodyParams
                   imageKeys:(NSArray *)imageKeysArray
                      images:(NSArray *)imagesArray
                    progress:(void (^)(CGFloat))progress
                     success:(void (^)(AFHTTPSessionManager *, id))success
                     failure:(void (^)(AFHTTPSessionManager *, NSError *))failure {
    if (!postUrl || postUrl.length == 0) {
        return;
    }
    
    if (!imageKeysArray || imageKeysArray.count == 0 || !imagesArray || imagesArray.count == 0) {
        return;
    }
    
    for (NSString *key in [headParams allKeys]) {
        NSString *value = [headParams objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [self.manager POST:postUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imagesArray != nil && imagesArray.count > 0) {
            for (int i = 0 ; i < imagesArray.count; i++) {
                NSData *imageData = imagesArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
                if (imageKeysArray.count == 1) {
                    [formData appendPartWithFileData:imageData name:imageKeysArray.firstObject fileName:fileName mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:imageData name:imageKeysArray[i] fileName:fileName mimeType:@"image/jpeg"];
                }
            }
        }
    }
              progress: ^(NSProgress * _Nonnull uploadProgress) {
                  progress(uploadProgress.fractionCompleted);
              }
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   success(_manager, responseObject);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(nil,error);
               }];
}

/**
 Post上传单个或多个视频
 
 @param postUrl 上传接口
 @param headParams 请求头参数
 @param bodyParams 请求体参数
 @param videosKeyArray 上传视频对应服务器key
 @param videosArray 视频data数组
 @param progress 进度值
 @param success 成功
 @param failure 失败
 */
- (void)uploadVideoWithPostUrl:(NSString *)postUrl
                    headParams:(NSDictionary *)headParams
                    bodyParams:(NSDictionary*)bodyParams
                     videosKey:(NSArray *)videosKeyArray
                   videosArray:(NSArray *)videosArray
                      progress:(void (^)(CGFloat))progress
                       success:(void (^)(AFHTTPSessionManager *, id))success
                       failure:(void (^)(AFHTTPSessionManager *, NSError *))failure {
    if (!postUrl || postUrl.length == 0) {
        return;
    }
    
    if (!videosKeyArray || videosKeyArray.count == 0 || !videosArray || videosArray.count == 0) {
        return;
    }
    
    for (NSString *key in [headParams allKeys]) {
        NSString *value = [headParams objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }

    [self.manager POST:postUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (videosArray != nil && videosArray.count > 0) {
            for (int i = 0 ; i < videosArray.count; i++) {
                NSData *imageData = videosArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.mp4", str, i];
                if (videosKeyArray.count == 1) {
                    [formData appendPartWithFileData:imageData name:videosKeyArray.firstObject fileName:fileName mimeType:@"video/mp4"];
                } else {
                    [formData appendPartWithFileData:imageData name:videosKeyArray[i] fileName:fileName mimeType:@"video/mp4"];
                }
            }
        }
    }
                  progress: ^(NSProgress * _Nonnull uploadProgress) {
                      progress(uploadProgress.fractionCompleted);
                  }
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       success(_manager, responseObject);
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       failure(nil,error);
                   }];
}

#pragma mark - Custom Method

/**
 JSON字符串转字典

 @param jsonString 字符串
 @return 字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
