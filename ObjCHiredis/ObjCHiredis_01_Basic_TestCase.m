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


@interface ObjCHiredis_01_Basic_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_01_Basic_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
	
	[redis command:@"SET MYSTRING MYVALUE"];
	[redis command:@"RPUSH MYLIST MYVALUE"];
	[redis command:@"SADD MYSET MYVALUE"];
	[redis command:@"ZADD MYZSET 1 MYVALUE"];
	[redis command:@"HSET MYHASH MYKEY MYVALUE"];
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

- (void)test_03_EXISTS {
	id retVal = [redis command:@"EXISTS MYDUMMY"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"EXISTS didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"EXISTS didn't return 0 on failure, got: %d", [retVal integerValue]);
	
	retVal = [redis command:@"EXISTS MYSTRING"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"EXISTS didn't return 1 on success, got: %d", [retVal integerValue]);
}

- (void)test_04_DEL {
	id retVal = [redis command:@"EXISTS MYSTRING"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"EXISTS didn't return 1 on success, got: %d", [retVal integerValue]);
	retVal = [redis command:@"DEL MYSTRING"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"DEL didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"DEL didn't return 1 on success, got: %d", [retVal integerValue]);
	retVal = [redis command:@"EXISTS MYSTRING"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"EXISTS didn't return 0 on failure, got: %d", [retVal integerValue]);	
	retVal = [redis command:@"DEL MYSTRING"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"DEL didn't return 0 on failure, got: %d", [retVal integerValue]);
	
}

- (void)test_05_TYPE {
	id retVal = [redis command:@"TYPE MYKEY"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"TYPE didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"none"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
	
	retVal = [redis command:@"TYPE MYSTRING"];
	STAssertTrue([retVal isEqualToString:@"string"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
	
	retVal = [redis command:@"TYPE MYLIST"];
	STAssertTrue([retVal isEqualToString:@"list"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
	
	retVal = [redis command:@"TYPE MYSET"];
	STAssertTrue([retVal isEqualToString:@"set"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
	
	retVal = [redis command:@"TYPE MYZSET"];
	STAssertTrue([retVal isEqualToString:@"zset"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
	
	retVal = [redis command:@"TYPE MYHASH"];
	STAssertTrue([retVal isEqualToString:@"hash"], @"TYPE didn't return 'none' on an empty key, got: %@", retVal);
}

- (void)test_06_KEYS {
	id retVal = [redis command:@"KEYS NOTHING"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"KEYS didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 0, @"KEYS didn't return an empty array when called on a null key, got: %d", [retVal count]);
	
	retVal = [redis command:@"KEYS MY*"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"KEYS didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 5, @"KEYS didn't return all keys matching pattern, count should be 5, got: %d", [retVal count]);
	STAssertTrue(([retVal containsObject:@"MYSTRING"] && [retVal containsObject:@"MYLIST"] &&
				  [retVal containsObject:@"MYSET"] && [retVal containsObject:@"MYZSET"] &&
				  [retVal containsObject:@"MYHASH"]), @"KEYS didn't return the matching keys");
}

@end
