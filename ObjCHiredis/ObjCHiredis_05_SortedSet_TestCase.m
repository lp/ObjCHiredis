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
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_ZADD {
	id retVal = [redis command:@"ZADD BAG 2 ONION"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZADD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"ZADD didn't return 1 on success, got: %d", [retVal integerValue]);
}


@end
