//
//  ObjCHiredis_09_Publish_Subscribe.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-11-13.
//  Copyright 2010 Modul. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>

#ifdef IOS
#import "ObjCHiredis.h"
#endif

#ifndef IOS
#import "ObjCHiredis/ObjCHiredis.h"
#endif

@interface ObjCHiredis_09_Publish_Subscribe : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_09_Publish_Subscribe

- (void)setUp {
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
}

- (void)test_01_SUBSCRIBE {
	id retVal = [redis command:@"SUBSCRIBE CHANNELZ"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"SUBSCRIBE didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([[retVal objectAtIndex:0] isEqualToString:@"subscribe"], @"SUBSCRIBE didn't return 'subscribe' as first argument, got: %@", [retVal objectAtIndex:0]);
	STAssertTrue([[retVal objectAtIndex:1] isEqualToString:@"CHANNELZ"], @"SUBSCRIBE didn't return 'CHANNELZ' as second argument, got: %@", [retVal objectAtIndex:1]);
	STAssertTrue([[retVal objectAtIndex:2] isEqualToNumber:[NSNumber numberWithInt:1]], @"SUBSCRIBE didn't return 1 as third argument, got: %d", [retVal objectAtIndex:2]);
	
	[NSThread detachNewThreadSelector:@selector(publishSome) toTarget:self withObject:nil];
	
	retVal = [redis getReply];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"getReply didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([[retVal objectAtIndex:0] isEqualToString:@"message"], @"getReply didn't return 'message' as first argument, got: %@", [retVal objectAtIndex:0]);
	STAssertTrue([[retVal objectAtIndex:1] isEqualToString:@"CHANNELZ"], @"CHANNELZ didn't return 'CHANNELZ' as second argument, got: %@", [retVal objectAtIndex:1]);
	STAssertTrue([[retVal objectAtIndex:2] isEqualToString:@"GOMAMA!"], @"SUBSCRIBE didn't return GOMAMA! as third argument, got: %@", [retVal objectAtIndex:2]);
	
}

// Helper Method
- (void)publishSome {
	ObjCHiredis * redisT = [ObjCHiredis redis];
	[NSThread sleepForTimeInterval:0.5];
	[redisT command:@"PUBLISH CHANNELZ GOMAMA!"];
	[redisT close];
	[NSThread exit];
}


@end
