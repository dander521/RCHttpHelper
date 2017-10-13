//
//  RCHttpHelper.h
//  HttpRequestDemo
//
//  Created by 程荣刚 on 2017/10/13.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 网络请求方式枚举
 */
typedef NS_ENUM(NSInteger, RCHttpHelperRequestType) {
    RCHttpHelperRequestTypeGet, /**< Get */
    RCHttpHelperRequestTypePost /**< Post */
};

@interface RCHttpHelper : NSObject

#pragma mark - Singleton

/**
 请求单例
 */
+ (instancetype)sharedHelper;

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
       failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure;

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
        failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure;

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
                     failure:(void (^)(AFHTTPSessionManager *, NSError *))failure;

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
                       failure:(void (^)(AFHTTPSessionManager *, NSError *))failure;

#pragma mark - Download Method





@end
