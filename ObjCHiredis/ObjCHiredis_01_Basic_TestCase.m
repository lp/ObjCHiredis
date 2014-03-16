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
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
	
	[redis command:@"SET MYSTRING MYVALUE"];
	[redis command:@"RPUSH MYLIST MYVALUE"];
	[redis command:@"SADD MYSET MYVALUE"];
	[redis command:@"ZADD MYZSET 1 MYVALUE"];
	[redis command:@"HSET MYHASH MYKEY MYVALUE"];
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
}

- (void) test_01_Math {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );    
}

- (void)test_02_Init {
	STAssertNotNil(redis, @"Couldn't init... ");
	STAssertTrue([[ObjCHiredis redis:@"localhost" on:[NSNumber numberWithInt:6379]] isKindOfClass:[ObjCHiredis class]],
				 @"ObjCHiredis didn't init properly with specific options");
	ObjCHiredis * tempRedis = [[ObjCHiredis alloc] init];
	STAssertTrue([tempRedis connect:@"127.0.0.1" on:[NSNumber numberWithInt:6379]], @"");
	
	id retVal = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:2]];
	STAssertTrue([retVal isKindOfClass:[ObjCHiredis class]],
				 @"redis:on:db: didn't return an initiated ObjCHiredis, got: %@", [retVal class]);
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

- (void)test_07_RANDOMKEY {
	id retVal = [redis command:@"RANDOMKEY"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"RANDOMKEY didn't return an NSString, got: %@", [retVal class]);
	NSArray * possibles = [NSArray arrayWithObjects:@"MYSTRING",@"MYLIST",@"MYSET",@"MYZSET",@"MYHASH",nil];
	STAssertTrue([possibles containsObject:retVal], @"RANDOMKEY didn't return one of the contained keys, got: %@", retVal);
}

- (void)test_08_RENAME {
	id retVal = [redis command:@"RENAME MYSTRING MYNEWSTRING"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"RENAME didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"OK"], @"RENAME didn't return OK, got: %@", retVal);
	STAssertTrue([[redis command:@"EXISTS MYSTRING"] isEqualToNumber:[NSNumber numberWithInt:0]],
				 @"RENAME didn't rename, old name still exists");
	STAssertTrue([[redis command:@"EXISTS MYNEWSTRING"] isEqualToNumber:[NSNumber numberWithInt:1]],
				 @"RENAME didn't rename, new key does not exists");
	retVal = [redis command:@"RENAME MYDUMMY MYNEWDUMMY"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"RENAME didn't return an NSString when called on a null key, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"ERR no such key"], @"RENAME didn't return 'ERR no such key' when called on a null key, got: %@", retVal);
}

- (void)test_09_RENAMENX {
	id retVal = [redis command:@"RENAMENX MYSTRING MYLIST"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"RENAMENX didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"RENAMENX didn't return 0 on failure, got: %d", [retVal integerValue]);
	retVal = [redis command:@"RENAMENX MYSTRING MYNEWSTRING"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"RENAMENX didn't return 1 on success, got: %d", [retVal integerValue]);
	STAssertTrue([[redis command:@"EXISTS MYSTRING"] isEqualToNumber:[NSNumber numberWithInt:0]],
				 @"RENAMENX didn't rename, old name still exists");
	STAssertTrue([[redis command:@"EXISTS MYNEWSTRING"] isEqualToNumber:[NSNumber numberWithInt:1]],
				 @"RENAMENX didn't rename, new key does not exists");
}

@end
