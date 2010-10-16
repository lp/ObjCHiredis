//
//  ObjCHiredis.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-15.
//  Copyright 2010 Modul. All rights reserved.
//

#import "ObjCHiredis.h"
#import "hiredis.h"

@interface ObjCHiredis ()

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(int)size;
- (id)parseReply:(redisReply*)reply;

@end

@implementation ObjCHiredis

+ (id)redis {
	ObjCHiredis * hiredis = [[ObjCHiredis alloc] init];
	[hiredis autorelease];
	
	if ([hiredis connect]) {
		return hiredis;
	} else {
		return nil;
	}
}

- (BOOL)connect {
	redisReply *reply;
	
    reply = redisConnect(&fd, "127.0.0.1", 6379);
    if (reply != NULL) {
        NSLog(@"Connection error: %s", reply->reply);
        return NO;
    } else {
		return YES;
	}
}

- (id)command:(NSString*)command
{
	redisReply *reply = redisCommand(fd,[command UTF8String]);
	id retVal = [self parseReply:reply];
    freeReplyObject(reply);
	return retVal;
}

- (id)parseReply:(redisReply*)reply {
	id retVal;
	if (reply->type == REDIS_REPLY_ERROR) {
		retVal = nil;
	} else if (reply->type == REDIS_REPLY_STRING) {
		retVal = [NSString stringWithUTF8String:reply->reply];
	} else if (reply->type == REDIS_REPLY_ARRAY) {
		retVal = [self arrayFromVector:reply->element ofSize:reply->elements];
	} else if (reply->type == REDIS_REPLY_INTEGER) {
		retVal = [NSNumber numberWithLongLong:reply->integer];
	} else {
		retVal = nil;
	}
	return retVal;
}

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(int)size {
	NSMutableArray * buildArray = [NSMutableArray array];
	for (int i; i < size; i++) {
		if (vec[i] != NULL) {
			[buildArray addObject:[self parseReply:vec[i]]];
		} else {
			[buildArray addObject:nil];
		}
		
	}
	return [NSArray arrayWithArray:buildArray];
}

@end
