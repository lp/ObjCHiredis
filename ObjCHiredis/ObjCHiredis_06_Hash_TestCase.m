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
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
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
