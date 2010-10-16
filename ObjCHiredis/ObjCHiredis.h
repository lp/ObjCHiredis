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

- (BOOL)connect;
- (id)command:(NSString*)command;

@end
