//
//  ObjCHiredis_05_SortedSet_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-26.
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

@interface ObjCHiredis_05_SortedSet_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end


@implementation ObjCHiredis_05_SortedSet_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis command:@"ZADD BASKET 1 PRUNE"];
	[redis command:@"ZADD BASKET 2 TOMATO"];
	[redis command:@"ZADD BASKET 3 ZUCHINI"];
	[redis command:@"ZADD BAG 1 TOMATO"];
	[redis command:@"ZADD BAG 2 POTATO"];
	[redis command:@"ZADD BAG 3 ONION"];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_ZADD {
	id retVal = [redis command:@"ZADD PURSE 1 BRUSH"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZADD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"ZADD didn't return 1 on success, got: %d", [retVal integerValue]);
}

- (void)test_02_ZREM {
	id retVal = [redis command:@"ZREM BAG ONION"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZREM didn't return an NSNumber, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"ZREM didn't return 1 on success, got %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"ZREM BAG CHERRY"] isEqualToNumber:[NSNumber numberWithInt:0]], @"ZREM didn't return 0 on failure, got %d", [[redis command:@"ZREM BAG CHERRY"] integerValue]); 
}


@end
