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


@end
