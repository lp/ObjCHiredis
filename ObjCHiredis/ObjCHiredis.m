//
//  ObjCHiredis.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-15.
//  Copyright (c) 2010 Louis-Philippe Perron.
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// 


#import "ObjCHiredis.h"
#import "hiredis.h"

@interface ObjCHiredis ()

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(NSUInteger)size;
- (id)parseReply:(redisReply*)reply;

@end

@implementation ObjCHiredis

- (id)init
{
	self = [super init];
	if (self != nil) {
		
	}	
	return self;
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

+ (id)redis {
	return [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379]];
}

+ (NSString*)ruby { return [[NSBundle bundleForClass:[ObjCHiredis class]] pathForResource:@"redis-objc" ofType:@"rb"]; }

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
