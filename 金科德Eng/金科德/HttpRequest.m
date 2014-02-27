//
//  HttpRequest.m
//  
//
//  Created by Yangliu on 13-7-2.
//  Copyright (c) 2013年 Yangliu. All rights reserved.
//

#import "HttpRequest.h"
#import "Tooles.h"

@interface RequestDelegate : NSObject
{
    CFRunLoopRef currentLoop;
}

@property(nonatomic,retain)NSString *response;

@end

@implementation RequestDelegate
@synthesize response;

-(id) initWithRunLoop: (CFRunLoopRef)runLoop
{
    if (self = [super init]) currentLoop = runLoop;
	return self;
}

-(void)requestDidFinished:(ASIHTTPRequest*)request
{
    [Tooles removeHUD];
    self.response = [request responseString];
    
    CFRunLoopStop(currentLoop);
}

-(void)requestDidFailed:(ASIHTTPRequest*)request
{
    [Tooles removeHUD];
    self.response = [request.error localizedDescription];
    CFRunLoopStop(currentLoop);
}

@end

@implementation HttpRequest

+(NSString*)requestWithGetMethodWithHUD:(BOOL)is url:(NSString *)url
{
    CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
    RequestDelegate *mDelegate = [[[RequestDelegate alloc]initWithRunLoop:currentLoop] autorelease];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = 30.;
    request.numberOfTimesToRetryOnTimeout = 3;
    [request setDelegate:mDelegate];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    if (is) {
        [Tooles showHUD:@""];
    }
    
    CFRunLoopRun();
    NSLog(@"%@\n  response\n%@",url,mDelegate.response);
    return mDelegate.response;
}

+(NSString*)requestWithGetMethodWithHUD:(BOOL)is urlFormat:(id)formatstring, ...
{
    va_list arglist;
	va_start(arglist, formatstring);
	id url = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
    return [self requestWithGetMethodWithHUD:is url:url];
}

+(NSString*)requestWithPostMethodWithHUD:(BOOL)is url:(NSString *)url values:(NSDictionary *)postValueDic
{
    if (![postValueDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
    RequestDelegate *mDelegate = [[[RequestDelegate alloc]initWithRunLoop:currentLoop] autorelease];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *keys = [postValueDic allKeys];
    for (NSString *key in keys)
    {
        NSString *val = [postValueDic objectForKey:key];
        if (![val isKindOfClass:[NSString class]]) {
            continue;
        }
        [request setPostValue:val forKey:key];
    }
    [request setDelegate:mDelegate];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    if (is) {
        [Tooles showHUD:@""];
    }
    CFRunLoopRun();
    NSLog(@"%@\n response\n%@",url,mDelegate.response);
    return mDelegate.response;
}

@end
