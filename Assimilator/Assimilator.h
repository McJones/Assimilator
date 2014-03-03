//
//  Assimilator.h
//  Assimilator
//
//  Created by Tim Nugent on 10/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import <Parse/Parse.h>

@class Assimilator;
@protocol AssimilatorDelegate <NSObject>

@optional

// fires once a list of nearby locations has been found
- (void)assimilator:(Assimilator *)assimilator didFindNearbyLocations:(NSArray *)locations;
// fires if there were no locations found or an error encountered finding locations
- (void)assimilator:(Assimilator *)assimilator failedToFindNearbyLocation:(NSError *)error;
// fires once a location has been assimilated
- (void)assimilator:(Assimilator *)assimilator didAssimilateLocation:(NSString *)locationUUID;

@end

@interface Assimilator : NSObject

// delegate for the Assimilator
@property (weak,nonatomic) id <AssimilatorDelegate> delegate;
// keeps track of the players allegiance
@property (assign) Allegiance allegiance;
// keeps track of all locations found so far
@property (strong) NSMutableDictionary *locations;

// returns the shared singleton assimilator
+ (Assimilator *)sharedAssimilator;
// checks if a location is allowed to be assimilated
- (BOOL)canAssimilate:(NSString *)locationUUID;
// assimilates a location for your team
- (void)assimilate:(NSString *)locationUUID;
// finds nearby locations and will tell its delegate once done
- (void)findNearbyLocations:(CLLocation *)location;
// resets the game
- (void)resetGame;

@end
