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

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(NSUInteger)size;
- (id)parseReply:(redisReply*)reply;

@end

@implementation ObjCHiredis

+ (id)redis {
	return [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379]];
}

+ (id)redis:(NSString*)ipaddress on:(NSNumber*)portnumber {
	ObjCHiredis * redis = [[ObjCHiredis alloc] init];
	[redis autorelease];
	
	if ([redis connect:ipaddress on:portnumber]) {
		return redis;
	} else {
		return nil;
	}
}

- (BOOL)connect:(NSString*)ipaddress on:(NSNumber*)portnumber {
	redisReply *reply;
	
    reply = redisConnect(&fd, [ipaddress UTF8String], [portnumber intValue]);
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

// Private Methods
- (id)parseReply:(redisReply*)reply {
	id retVal;
	if (reply->type == REDIS_REPLY_ERROR) {
		retVal = [NSString stringWithUTF8String:reply->reply];
	} else if (reply->type == REDIS_REPLY_STRING) {
		retVal = [NSString stringWithUTF8String:reply->reply];
	} else if (reply->type == REDIS_REPLY_ARRAY) {
		retVal = [self arrayFromVector:reply->element ofSize:reply->elements];
	} else if (reply->type == REDIS_REPLY_INTEGER) {
		retVal = [NSNumber numberWithLongLong:reply->integer];
	} else if (reply->type == REDIS_REPLY_NIL) {
		retVal = nil;
	}
	else {
		retVal = [NSString stringWithFormat:@"'%@'", [NSString stringWithUTF8String:reply->reply]];
	}
	return retVal;
}

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(NSUInteger)size {
	NSMutableArray * buildArray = [NSMutableArray array];
	for (NSUInteger i = 0; i < size; i++) {
		if (vec[i] != NULL) {
			[buildArray addObject:[self parseReply:vec[i]]];
		} else {
			[buildArray addObject:nil];
		}
		
	}
	return [NSArray arrayWithArray:buildArray];
}

@end
