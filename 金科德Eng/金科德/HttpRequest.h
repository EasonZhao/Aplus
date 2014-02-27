//
//  HttpRequest.h
//  
//
//  Created by Yangliu on 13-7-2.
//  Copyright (c) 2013年 Yangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface HttpRequest : NSObject

+(NSString*)requestWithGetMethodWithHUD:(BOOL)is url:(NSString *)url;
+(NSString*)requestWithGetMethodWithHUD:(BOOL)is urlFormat:(id)formatstring,...;
+(NSString*)requestWithPostMethodWithHUD:(BOOL)is url:(NSString *)url values:(NSDictionary*)postValueDic;

@end
