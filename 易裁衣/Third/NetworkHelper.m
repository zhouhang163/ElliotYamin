//  SFExtension
//  https://github.com/paintingStyle/SFExtension.git
//  Copyright © paintingStyle. All rights reserved.

#import "NetworkHelper.h"
#import <AFNetworking.h>
//#import "MBProgressHUD+SFExtension.h"

static NSString * const kAFNetworkingLockName = @"com.alamofire.networking.operation.lock";

@interface NetworkHelper()

@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation NetworkHelper

@synthesize outputStream = _outputStream;

- (void)showNetWorkErrorHUD {
    
//    if (![GlobalConfiguration showNetWorkErrorHUD]) {
//        return;
//    }
//   [RKDropdownAlert title:[GlobalConfiguration netWorkErrorString] backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    
}

+(void)cancelAllOperations{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

/**
 *  建立网络请求单例
 */
+ (id)shareInstance{
    static NetworkHelper *helper;
    static dispatch_once_t onceToken;
    
    __weak NetworkHelper *weakSelf = helper;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[NetworkHelper alloc]init];
            weakSelf.lock = [[NSRecursiveLock alloc] init];
            weakSelf.lock.name = kAFNetworkingLockName;
        }
    });
    return helper;
}


/**
 *  GET请求
 */
- (void)GET:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{
    
    //网络检查
    [NetworkHelper checkingNetworkResult:^(NetworkStatus status) {
        if (status == StatusNotReachable) {
            
            [self showNetWorkErrorHUD];
//            if ([GlobalConfiguration networkErrorSkipRequest]) {
//                return;
//            }
           
        }
    }];
    
    //断言
    NSAssert(url != nil, @"url不能为空");
    
    // !!! 注意有中文UTF-8编码 否则装换成NSURL失败
    url =  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    //使用AFNetworking进行网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //因为服务器返回的数据如果不是application/json格式的数据
    //需要以NSData的方式接收,然后自行解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    //发起get请求
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //将返回的数据转成json数据格式
        id result = [self tryToParseData:responseObject];
        
        //通过block，将数据回掉给用户
        if (success) success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //通过block,将错误信息回传给用户
        if (failure)  {
            failure(error);
        };
        
        [self showNetWorkErrorHUD];
        
    }];
}


// 解析json数据
- (id)tryToParseData:(id)json {
    
    if (!json || json == (id)kCFNull) return nil;
    
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        dic = json;
        
    } else if ([json isKindOfClass:[NSString class]]) {
        
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
        
    } else if ([json isKindOfClass:[NSData class]]) {
        
        jsonData = json;
        
    }
    
    /**
     
     typedef NS_OPTIONS(NSUInteger, NSJSONReadingOptions) {
     //创建的数组或者字典应该是可变的
     NSJSONReadingMutableContainers = (1UL << 0),
     //返回的JSON对象中字符串的值类型为NSMutableString
     NSJSONReadingMutableLeaves = (1UL << 1),
     //允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
     NSJSONReadingAllowFragments = (1UL << 2)
     }
     
     */
    
    if (jsonData) {
        
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
        
    }
    
    return dic;
}


/**
 *  POST请求
 */
- (void)POST:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{
    
    //网络检查
    [NetworkHelper checkingNetworkResult:^(NetworkStatus status) {
        if (status == StatusNotReachable) {
            [self showNetWorkErrorHUD];
//            if ([GlobalConfiguration networkErrorSkipRequest]) {
//                return;
//            }
        }
    }];
    
    //断言
    NSAssert(url != nil, @"url不能为空");
    
    // !!! 注意有中文UTF-8编码 否则装换成NSURL失败
    url =  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        //将返回的数据转成json数据格式
        id result = [self tryToParseData:responseObject];
        
        //通过block，将数据回掉给用户
        if (success) success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //通过block,将错误信息回传给用户
        if (failure) failure(error);
    }];
}


/**
 *  向服务器上传文件
 */
- (void)POST:(NSString *)url
   Parameter:(NSDictionary *)parameter
        Data:(NSData *)fileData FieldName:(NSString *)fieldName
    FileName:(NSString *)fileName MimeType:(NSString *)mimeType
     Success:(void (^)(id))success
     Failure:(void (^)(NSError *))failure{
    
    //网络检查
    [NetworkHelper checkingNetworkResult:^(NetworkStatus status) {
        if (status == StatusNotReachable) {
            [self showNetWorkErrorHUD];
//            if ([GlobalConfiguration networkErrorSkipRequest]) {
//                return;
//            }
        }
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:fieldName fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //将返回的数据转成json数据格式
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        //将返回的数据转成json数据格式
        if (success) success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //通过block,将错误信息回传给用户
        if (failure) failure(error);
    }];
}


/**
 *  下载文件
 */
- (void)downloadFileWithRequestUrl:(NSString *)url
                         Parameter:(NSDictionary *)patameter
                         SavedPath:(NSString *)savedPath
                          Complete:(void (^)(NSData *data, NSError *error))complete
                          Progress:(void (^)(id downloadProgress, double currentValue))progress{
    //网络检查
    [NetworkHelper checkingNetworkResult:^(NetworkStatus status) {
        if (status == StatusNotReachable) {
            [self showNetWorkErrorHUD];
//            if ([GlobalConfiguration networkErrorSkipRequest]) {
//                return;
//            }
        }
    }];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //AFN3.0URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        double progressValue = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        if (progress) progress(downloadProgress, progressValue);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:savedPath != nil ? savedPath : path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        // filePath就是下载文件的位置，可以直接拿来使用
        NSData *data;
        if (!error) {
            data = [NSData dataWithContentsOfURL:filePath];
        }
        if (complete) complete(data, error);
    }];
    
    //默认下载操作是挂起的，须先手动恢复下载。
    [downloadTask resume];
}


/**
 *  NSData上传文件
 */
- (void)updataDataWithRequestStr:(NSString *)str
                        FromData:(NSData *)fromData
                        Progress:(void(^)(NSProgress *uploadProgress))progress
                      Completion:(void(^)(id object,NSError *error))completion{
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager uploadTaskWithRequest:request fromData:fromData progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) progress(uploadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (completion) completion(responseObject,error);
    }];
}


/**
 *  NSURL上传文件
 */
- (void)updataFileWithRequestStr:(NSString *)str
                        FromFile:(NSURL *)fromUrl
                        Progress:(void(^)(NSProgress *uploadProgress))progress
                      Completion:(void(^)(id object,NSError *error))completion{
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager uploadTaskWithRequest:request fromFile:fromUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) progress(uploadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (completion) completion(responseObject,error);
    }];
}


/**
 *   监听网络状态的变化
 */
+ (void)checkingNetworkResult:(void (^)(NetworkStatus))result {
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            if (result) result(StatusUnknown);
            
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            if (result) result(StatusNotReachable);
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            if (result) result(StatusReachableViaWWAN);
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            if (result) result(StatusReachableViaWiFi);
            
        }
    }];
}

//- (NSOutputStream *)outputStream {
//    if (!_outputStream) {
//        self.outputStream = [NSOutputStream outputStreamToMemory];
//    }
//    
//    return _outputStream;
//}
//
//- (void)setOutputStream:(NSOutputStream *)outputStream {
//    [self.lock lock];
//    if (outputStream != _outputStream) {
//        if (_outputStream) {
//            [_outputStream close];
//        }
//        _outputStream = outputStream;
//    }
//    [self.lock unlock];
//}

@end
