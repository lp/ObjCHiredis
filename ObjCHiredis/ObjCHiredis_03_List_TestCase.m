//
//  ObjCHiredis_03_List_TestCase.m
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

@interface ObjCHiredis_03_List_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_03_List_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_RPUSH {
	id retVal = [redis command:@"RPUSH BASKET APPLE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"RPUSH returned class is not NSNumber, got %d", [retVal class]);
	STAssertTrue([retVal integerValue] == 1, @"RPUSH return value is wrong, got %d", [retVal integerValue]);
}

- (void)test_02_LPUSH {
	id retVal = [redis command:@"LPUSH BASKET APPLE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"LPUSH returned class is not NSNumber, got %d", [retVal class]);
	STAssertTrue([retVal integerValue] == 1, @"LPUSH return value is wrong, got %d", [retVal integerValue]);
}

- (void)test_04_LRANGE {
	[redis command:@"RPUSH BASKET PRUNE"];
	[redis command:@"RPUSH BASKET TOMATO"];
	[redis command:@"RPUSH BASKET ZUCHINI"];
	STAssertTrue([[redis command:@"LRANGE BASKET 0 2"] isKindOfClass:[NSArray class]], @"LRANGE didn't return an Array, got %@", [[redis command:@"LRANGE BASKET 0 2"] class]);
	STAssertTrue([[redis command:@"LRANGE BASKET 0 2"] count] == 3 , @"LRANGE returned bad length, should be 3, got %d", [[redis command:@"LRANGE BASKET 0 2"] count]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:0] isEqualToString:@"PRUNE"], @"LRANGE returned wrong objects, should be PRUNE, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:0]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:1] isEqualToString:@"TOMATO"], @"LRANGE returned wrong objects, should be TOMATO, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:1]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:2] isEqualToString:@"ZUCHINI"], @"LRANGE returned wrong objects, should be ZUCHINI, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:2]);
}

- (void)test_09_RPOP {
	[redis command:@"RPUSH BASKET BANANA"];
	STAssertTrue([[redis command:@"RPOP BASKET"] isEqualToString:@"BANANA"], @"Couldn't RPOP, got %@", [redis command:@"RPOP BASKET"]);

}

@end
