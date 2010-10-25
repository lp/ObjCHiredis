//
//  ObjCHiredis_04_Set_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-22.
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

@interface ObjCHiredis_04_Set_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_04_Set_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis command:@"SADD BASKET PRUNE"];
	[redis command:@"SADD BASKET TOMATO"];
	[redis command:@"SADD BASKET ZUCHINI"];
	[redis command:@"SADD BAG TOMATO"];
	[redis command:@"SADD BAG POTATO"];
	[redis command:@"SADD BAG ONION"];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_SADD {
	id retVal = [redis command:@"SADD BASKET BANANA"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SADD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SADD didn't return success of adding member in Set, chould be 1, got: %d", [retVal integerValue]); 
}

- (void)test_02_SREM {
	id retVal = [redis command:@"SREM BASKET PRUNE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SREM didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SREM didn't return 1 on success, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"SREM BASKET ORANGE"] isEqualToNumber:[NSNumber numberWithInt:0]], @"SREM didn't return 0 on failure, got: %d", [[redis command:@"SREM BASKET ORANGE"] integerValue]);
}

- (void)test_03_SPOP {
	id retVal = [redis command:@"SPOP BASKET"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"SPOP didn't return an NSString, got: %@", [retVal class]);
	NSArray * possibles = [NSArray arrayWithObjects:@"PRUNE",@"TOMATO",@"ZUCHINI",nil];
	STAssertTrue([possibles containsObject:retVal], @"SPOP didn't return the popped member, got: %@", retVal);
}

- (void)test_04_SMOVE {
	id retVal = [redis command:@"SMOVE BASKET PURSE PRUNE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SMOVE didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SMOVE didn't return 1 on success, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"SMOVE BASKET PURSE ORANGE"] isEqualToNumber:[NSNumber numberWithInt:0]], @"SMOVE didn't return 0 on failure, got: %d", [retVal integerValue]);
	retVal = [redis command:@"SPOP PURSE"];
	STAssertTrue([retVal isEqualToString:@"PRUNE"], @"SMOVE didn't move PRUNE to BAG, got: %@", retVal);
}

- (void)test_05_SCARD {
	id retVal = [redis command:@"SCARD BASKET"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SCARD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:3]], @"SCARD didn't return the cardinality, should be 3, got: %d", [retVal integerValue]);
	retVal = [redis command:@"SCARD PURSE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SCARD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"SCARD didn't return the cardinality, should be 0, got: %d", [retVal integerValue]);
}

- (void)test_06_SISMEMBER {
	id retVal = [redis command:@"SISMEMBER BASKET TOMATO"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SISMEMBER didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SISMEMBER didn't return 1 on success, got: %d", [retVal integerValue]);
	retVal = [redis command:@"SISMEMBER BASKET POTATO"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SISMEMBER didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"SISMEMBER didn't return 0 on failure, got: %d", [retVal integerValue]);
}

- (void)test_07_SINTER {
	id retVal = [redis command:@"SINTER BASKET BAG"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"SINTER didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 1, @"SINTER didn't return the right number of members, should be 1, got: %d", [retVal count]);
	STAssertTrue([[retVal objectAtIndex:0] isEqualToString:@"TOMATO"], @"SINTER didn't return the right intersecting member, should be TOMATO, got: %@", [retVal objectAtIndex:0]);
}

- (void)test_08_SINTERSTORE {
	id retVal = [redis command:@"SINTERSTORE PURSE BASKET BAG"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SINTERSTORE didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SINTERSTORE didn't return 1 on success, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"SINTERSTORE DUMMY TRUCK VAN"] isEqualToNumber:[NSNumber numberWithInt:0]], @"SINTERSTORE didn't return 0 on failure, got: %d", [[redis command:@"SINTERSTORE DUMMY TRUCK VAN"] integerValue]);

	STAssertTrue([[redis command:@"SISMEMBER PURSE TOMATO"] isEqualToNumber:[NSNumber numberWithInt:1]], @"SINTERSTORE didn't store the result properly, destination key comtains %d positives items", [[redis command:@"SISMEMBER PURSE TOMATO"] integerValue]);
	STAssertTrue([[redis command:@"SCARD PURSE"] isEqualToNumber:[NSNumber numberWithInt:1]], @"SINSTERSTORE didn't store the results properly, destination key contains %d members", [[redis command:@"SCARD PURSE"] integerValue]);
}

- (void)test_09_SUNION {
}


@end
