//
//  ObjCHiredis_06_Hash_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-20.
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

@interface ObjCHiredis_06_Hash_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_06_Hash_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis command:@"HSET BASKET TOMATO 6"];
	[redis command:@"HSET BASKET PRUNE 10"];
	[redis command:@"HSET BASKET ZUCHINI 3"];
	[redis command:@"HSET BAG TOMATO ITALIAN"];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_HSET {
	id retVal = [redis command:@"HSET BASKET PEACH 2"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"HSET didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"HSET didn't return 1 on success, got: %d", [retVal integerValue]);
}

- (void)test_02_HGET {
	id retVal = [redis command:@"HGET BASKET TOMATO"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"HGET didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"6"], @"HGET didn't return proper value, should be 6, got: %@", retVal);
	retVal = [redis command:@"HGET BAG BACON"];
	STAssertNil(retVal,@"HGET didn't return nil on a null key, got %@", retVal);
}

- (void)test_03_HMGET {
	id retVal = [redis command:@"HMGET BASKET PRUNE ZUCHINI"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"HMGET didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 2, @"HMGET didn't return an array of right size, should be 2, got: %d", [retVal count]);
	STAssertTrue(([[retVal objectAtIndex:0] isEqualToString:@"10"] && [[retVal objectAtIndex:1] isEqualToString:@"3"]),
				  @"HMGET didn't return proper values");
}

- (void)test_04_HMSET {
	id retVal = [redis command:@"HMSET BAG ONION 8 POTATO 20"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"HMSET didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"OK"], @"HMSET didn't return a success string, should be OK, got: %@", retVal);
	STAssertTrue([[redis command:@"HGET BAG POTATO"] isEqualToString:@"20"], @"HMSET didn't set the values properly");
}

- (void)test_05_HSETNX {
	id retVal = [redis command:@"HSETNX BAG ONION 8"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"HSETNX didn't return an NSNumber, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"HSETNX didn't return 1 on success, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"HGET BAG ONION"] isEqualToString:@"8"], @"HSETNX didn't set the values properly");
	retVal = [redis command:@"HSETNX BASKET TOMATO 10"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"HSETNX didn't return 0 on failure, got: %d", [retVal integerValue]);
}

- (void)test_06_HINCRBY {
	id retVal = [redis command:@"HINCRBY BASKET PRUNE 5"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"HINCRBY didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:15]], @"HINCRBY didn't increment the value, should be 15, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"HGET BASKET PRUNE"] isEqualToString:@"15"], @"HINCRBY didn't increment the value, should be 15, got: %@", [redis command:@"HGET BASKET PRUNE"]);
	retVal = [redis command:@"HINCRBY BASKET CHERRY 2"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"HINCRBY didn't return an NSNumber, got: %@", retVal);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:2]], @"HINCRBY didn't increment a non numeric string, should be 2, got: %d", [retVal integerValue]);
}

@end
