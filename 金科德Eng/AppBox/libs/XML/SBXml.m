//
//  SBXml.m
//  MeAppOA
//
//  Created by absir on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SBXml.h"

@implementation NSString (SBXml)

- (id)xmlValue
{
    return [SBXml SBXml:[self UTF8String]];
}

@end

@implementation NSData (SBXml)

- (id)xmlValue
{
    return [SBXml SBXml:[self bytes]];
}

@end

@implementation SBXml

- (id)parser:(const char *)bytes
{
    return NULL;
}

+ (id)SBXml:(const char *)bytes
{
    SBXml *parser = [[self alloc] init];
    id result = [parser parser:bytes];
    [parser release];
    return result;
}

@end






