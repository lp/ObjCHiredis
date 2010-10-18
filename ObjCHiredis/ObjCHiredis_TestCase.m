//
//  ObjCHiredis_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-15.
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


@interface ObjCHiredis_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void) test_01_Math {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );    
}

- (void)test_02_Init {
	STAssertNotNil(redis, @"Couldn't init... ");
}

- (void)test_03_String {
	STAssertTrue([[redis command:@"SET FOO BAR"] isEqualToString:@"OK"] , @"Couldn't SET, got %@", [redis command:@"SET FOO BAR"]);
	STAssertTrue([[redis command:@"GET FOO"] isEqualToString:@"BAR"] , @"Couldn't GET, got %@", [redis command:@"GET BAR"]);
}

- (void)test_11_List {
	STAssertTrue([[redis command:@"RPUSH BASKET APPLE"] isKindOfClass:[NSNumber class]], @"Couldn't RPUSH, got %@", [redis command:@"RPUSH BASKET APPLE"]);
	STAssertTrue([[redis command:@"RPOP BASKET"] isKindOfClass:[NSString class]], @"Couldn't RPOP, got %@", [redis command:@"RPOP BASKET"]);
	[redis command:@"RPUSH BASKET BANANA"];
	STAssertTrue([[redis command:@"RPOP BASKET"] isEqualToString:@"BANANA"], @"Couldn't RPOP, got %@", [redis command:@"RPOP BASKET"]);
	[redis command:@"RPUSH BASKET PRUNE"];
	[redis command:@"RPUSH BASKET TOMATO"];
	[redis command:@"RPUSH BASKET ZUCHINI"];
	STAssertTrue([[redis command:@"LRANGE BASKET 0 1"] isKindOfClass:[NSArray class]], @"Couldn't LRANGE, got %@", [redis command:@"LRANGE BASKET 0 1"]);
	STAssertTrue([[redis command:@"LRANGE BASKET 0 1"] count] == 2 , @"Couldn't LRANGE length, got %d", [[redis command:@"LRANGE BASKET 0 1"] count]);
}

- (void)test_12_Hash {
	STAssertTrue([[redis command:@"HSET assets tonka pebbles"] isKindOfClass:[NSNumber class]], @"Couldn't HSET, got: %@", [redis command:@"HSET assets tonka pebbles"]);
	STAssertTrue([[redis command:@"HGET assets tonka"] isKindOfClass:[NSString class]], @"Couldn't HGET, got: %@", [redis command:@"HGET assets tonka"]);
	STAssertTrue([[redis command:@"HGET assets tonka"] isEqualToString:@"pebbles"], @"Couldn't HGET, got: %@", [redis command:@"HGET assets tonka"]);
	STAssertTrue([[redis command:@"HGETALL assets"] isKindOfClass:[NSArray class]], @"Couldn't HGETALL, got: %@", [[redis command:@"HGETALL assets"] componentsJoinedByString:@"_"]);
	STAssertTrue([[redis command:@"HGETALL assets"] count] == 2, @"Couldn't HGETALL, got: %d", [[redis command:@"HGETALL assets"] count]);
	STAssertTrue([[[redis command:@"HGETALL assets"] objectAtIndex:0] isEqualToString:@"tonka"], @"Couldn't HGETALL, got: %@", [[redis command:@"HGETALL assets"] objectAtIndex:0]);
	STAssertTrue([[[redis command:@"HGETALL assets"] objectAtIndex:1] isEqualToString:@"pebbles"], @"Couldn't HGETALL, got: %@", [[redis command:@"HGETALL assets"] objectAtIndex:1]);
}


@end
