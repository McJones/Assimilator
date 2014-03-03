//
//  Assimilator.m
//  Assimilator
//
//  Created by Tim Nugent on 10/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

// the search radius to find nearby assimilation nodes in km
#define SEARCH_RADIUS 0.1

#import "Assimilator.h"

static Assimilator *_sharedAssimilator;

@implementation Assimilator

+ (Assimilator *)sharedAssimilator
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedAssimilator = [[Assimilator alloc] init];
		_sharedAssimilator.locations = [NSMutableDictionary dictionary];
	});
	
	return _sharedAssimilator;
}

- (void)assimilate:(NSString *)locationUUID
{
	NSLog(@"asimilating: %@",locationUUID);
	// find the correct object in Parse
	PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    query.limit = 20;
	[query getObjectInBackgroundWithId:locationUUID block:^(PFObject *object, NSError *error)
	{
		if (!error)
		{
			// update its count for the player team
			NSString *teamKey = nil;
			if (self.allegiance == LIZARD_PEOPLE)
				teamKey = LIZARD_KEY;
			else
				teamKey = ILLUM_KEY;
			
			[object incrementKey:teamKey];
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (succeeded)
				{
					if ([self.delegate respondsToSelector:@selector(assimilator:didAssimilateLocation:)])
					{
						[self.delegate assimilator:self didAssimilateLocation:locationUUID];
					}
				}
			}];
		}
	}];
	// update the date of the location
	self.locations[locationUUID] = [NSDate date];
	NSDictionary *locs = [NSDictionary dictionaryWithDictionary:self.locations];
	[[NSUserDefaults standardUserDefaults] setObject:locs forKey:@"locations"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)canAssimilate:(NSString *)locationUUID
{
	NSDate *lastAssimilated = self.locations[locationUUID];
	NSLog(@"lastAssimilated:%@",lastAssimilated);
	if (lastAssimilated == nil || [lastAssimilated timeIntervalSinceNow] > 1800)
	{
		return YES;
	}
	return NO;
}

- (void)findNearbyLocations:(CLLocation *)location
{
	// create a fetch to find all PFObjects nearby to that location
	PFQuery *query = [PFQuery queryWithClassName:@"Location"];
	PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:location];
	[query whereKey:@"position" nearGeoPoint:point withinKilometers:SEARCH_RADIUS];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (!error)
		{
            // if there actually some locations nearby
            if (objects.count > 0)
            {
                // tell the delegate about it and pass over the returned array
                if ([self.delegate respondsToSelector:@selector(assimilator:didFindNearbyLocations:)])
                    [self.delegate assimilator:self didFindNearbyLocations:objects];
            }
            // else tell the delegate
            else
            {
                if ([self.delegate respondsToSelector:@selector(assimilator:failedToFindNearbyLocation:)])
                    [self.delegate assimilator:self failedToFindNearbyLocation:nil];
            }
		}
        else
        {
            // tell the delegate about it
            if ([self.delegate respondsToSelector:@selector(assimilator:failedToFindNearbyLocation:)])
                [self.delegate assimilator:self failedToFindNearbyLocation:error];
        }
	}];
}

- (void)resetGame
{
    self.delegate = nil;
    self.locations = nil;
    
    // wiping the userdefaults
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"locations"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"allegiance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)stringUUID
{
	CFUUIDRef temp = CFUUIDCreate(kCFAllocatorDefault);
	NSString *uuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, temp);
	CFRelease(temp);
	return uuid;
}

@end
