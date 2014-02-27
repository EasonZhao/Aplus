//
//  SBXml.h
//  MeAppOA
//
//  Created by absir on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SBXml)

- (id)xmlValue;

@end

@interface NSData (SBXml)

- (id)xmlValue;

@end

@interface SBXml : NSObject

+ (id)SBXml:(const char *)bytes;

@end
