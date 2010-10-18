//
//  ObjCHiredis.h
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-15.
//  Copyright 2010 Modul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCHiredis : NSObject {
	int fd;
}

+ (id)redis;
+ (id)redis:(NSString*)ipaddress on:(NSNumber*)portnumber;
- (BOOL)connect:(NSString*)ipaddress on:(NSNumber*)portnumber;
- (id)command:(NSString*)command;

@end
