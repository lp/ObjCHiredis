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
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
	[redis command:@"ZADD BASKET 2 PRUNE"];
	[redis command:@"ZADD BASKET 4 TOMATO"];
	[redis command:@"ZADD BASKET 6 ZUCHINI"];
	[redis command:@"ZADD BAG 1 TOMATO"];
	[redis command:@"ZADD BAG 2 POTATO"];
	[redis command:@"ZADD BAG 3 ONION"];
	[redis command:@"ZADD BAG 3.6 KNIFE"];
	[redis command:@"ZADD BAG 3.3 SAUSAGE"];
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
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

- (void)test_03_ZINCRBY {
	id retVal = [redis command:@"ZINCRBY BAG 1 ONION"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"ZINCRBY didn't return an NSString, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"4"], @"ZINCRBY didn't return the new score, should be 4, got %@", retVal);
	retVal = [redis command:@"ZINCRBY BAG 5 BACON"];
	STAssertTrue([retVal isEqualToString:@"5"], @"ZINCRBY didn't return the set score, should be 5, got %@", retVal);
}

- (void)test_04_ZRANK {
	id retVal = [redis command:@"ZRANK BASKET TOMATO"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZRANK didn't return an NSNumber, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"ZRANK didn't return the rank number, should be 1, got %d", [retVal integerValue]);
	STAssertNil([redis command:@"ZRANK BAG BACON"], @"ZRANK didn't return nil on undefined member, got: %@", [redis command:@"ZRANK BAG BACON"]);
}

- (void)test_05_ZREVRANK {
	id retVal = [redis command:@"ZREVRANK BASKET ZUCHINI"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZREVRANK didn't return an NSNumber, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"ZREVRANK didn't return the reversed renk number, should be 0, got %d", [retVal integerValue]);
	STAssertNil([redis command:@"ZREVRANK BAG BACON"], @"ZREVRANK didn't return nil on undefined member, got: %@", [redis command:@"ZREVRANK BAG BACON"]);
}

- (void)test_06_ZRANGE {
	id retVal = [redis command:@"ZRANGE BASKET 0 1"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"ZRANGE didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 2, @"ZRANGE didn't return an NSArray of proper size, should be 2, got: %d", [retVal count]);
	STAssertTrue(([[retVal objectAtIndex:0] isEqualToString:@"PRUNE"] && [[retVal objectAtIndex:1] isEqualToString:@"TOMATO"]),
				 @"ZRANGE didn't return the proper set members");
	retVal = [redis command:@"ZRANGE PURSE 3 6"];
	STAssertTrue([retVal count] == 0, @"ZRANGE didn't return an empty NSArray, got: %@", [retVal count]);
}

- (void)test_07_ZREVRANGE {
	id retVal = [redis command:@"ZREVRANGE BASKET 0 1"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"ZREVRANGE didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 2, @"ZREVRANGE didn't return an NSArray of proper size, should be 2, got: %d", [retVal count]);
	STAssertTrue(([[retVal objectAtIndex:0] isEqualToString:@"ZUCHINI"] && [[retVal objectAtIndex:1] isEqualToString:@"TOMATO"]),
				 @"ZREVRANGE didn't return the proper set members");
	retVal = [redis command:@"ZREVRANGE PURSE 3 6"];
	STAssertTrue([retVal count] == 0, @"ZREVRANGE didn't return an empty NSArray, got: %@", [retVal count]);
}

- (void)test_08_ZRANGEBYSCORE {
	id retVal = [redis command:@"ZRANGEBYSCORE BASKET 0 4"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"ZRANGEBYSCORE didn't return an NSArray, got: %@", retVal);
	STAssertTrue([retVal count] == 2, @"ZRANGEBYSCORE didn't return an NSArray of proper size, should be 2, got: %d", [retVal count]);
	STAssertTrue(([[retVal objectAtIndex:0] isEqualToString:@"PRUNE"] && [[retVal objectAtIndex:1] isEqualToString:@"TOMATO"]),
				 @"ZRANGEBYSCORE didn't return the proper set members");
	retVal = [redis command:@"ZRANGEBYSCORE PURSE 3 6"];
	STAssertTrue([retVal count] == 0, @"ZVRANGEBYSCORE didn't return an empty NSArray, got: %@", [retVal count]);
}

- (void)test_09_ZCOUNT {
	id retVal = [redis command:@"ZCOUNT BAG 3 4"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZCOUNT didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:3]], @"ZCOUNT didn't return right value, should be 3, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZCOUNT PURSE 0 99"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"ZCOUNT didn't return 0 on empty key call, got: %d", [retVal integerValue]);
}

- (void)test_10_ZCARD {
	id retVal = [redis command:@"ZCARD BAG"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZCARD didn't return an NSNumber, got %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:5]], @"ZCARD didn't return right value, should be 5, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZCARD PURSE"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"ZCARD didn't return 0 on empty key call, got: %d", [retVal integerValue]);
}

- (void)test_11_ZSCORE {
	id retVal = [redis command:@"ZSCORE BASKET TOMATO"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"ZSCORE didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"4"], @"ZSCORE didn't return the right value, should be 4, got %@", retVal);
	retVal = [redis command:@"ZSCORE BAG BACON"];
	STAssertNil(retVal, @"ZSCORE didn't return nil on a null member, got: %@", retVal);
}

- (void)test_12_ZREMRANGEBYRANK {
	id retVal = [redis command:@"ZREMRANGEBYRANK BAG 3 4"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZREMRANGEBYRANK didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:2]], @"ZREMRANGEBYRANK didn't return the number of removed members, should be 2, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZREMRANGEBYRANK PURSE 0 99"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"ZREMRANGEBYRANK didn't return 0 on null set, got: %d", [retVal integerValue]);
}

- (void)test_13_ZREMRANGEBYSCORE {
	id retVal = [redis command:@"ZREMRANGEBYSCORE BAG 3 4"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZREMRANGEBYSCORE didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:3]], @"ZREMRANGEBYSCORE didn't return the number of removed members, should be 3, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZREMRANGEBYSCORE PURSE 0 99"];
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:0]], @"ZREMRANGEBYSCORE didn't return 0 on null set, got: %d", [retVal integerValue]);
}

- (void)test_14_ZINTERSTORE {
	id retVal = [redis command:@"ZINTERSTORE PURSE 2 BASKET BAG"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZINTERSTORE didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"ZINTERSTORE didn't return the number of intersecting members stored, should be 1, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZSCORE PURSE TOMATO"];
	STAssertTrue([retVal isEqualToString:@"5"], @"ZINTERSTORE didn't SUM the score by default, should be 5, got: %@", retVal);
}

- (void)test_15_ZUNIONSTORE {
	id retVal = [redis command:@"ZUNIONSTORE PURSE 2 BASKET BAG AGGREGATE MAX"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"ZUNIONSTORE didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:7]], @"ZUNIONSTORE didn't return the number of unioned members stored, should be 7, got: %d", [retVal integerValue]);
	retVal = [redis command:@"ZSCORE PURSE TOMATO"];
	STAssertTrue([retVal isEqualToString:@"4"], @"ZUNIONSTORE didn't MAX the score at stated, should be 4, got: %@", retVal);
}

@end
