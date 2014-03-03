//
//  AssimilatorSearchViewController.m
//  Assimilator
//
//  Created by Tim Nugent on 10/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "AssimilatorSearchViewController.h"
#import "Assimilator.h"
#import "LocationListViewController.h"
#import "UIView+GlowShadow.h"
@import QuartzCore;

@interface AssimilatorSearchViewController ()<AssimilatorDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationmanager;
@property (weak, nonatomic) IBOutlet UILabel *throbberView;
@property (weak, nonatomic) IBOutlet UILabel *userIsBeingUppityLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation AssimilatorSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// adding a glow shadow to the throbber
    [self.throbberView addGlowShadow];
	
    [self.aboutLabel addGlowShadowWithColour:[UIColor orangeColor]];
    
	// start search for nearby locations
	self.locationmanager = [[CLLocationManager alloc] init];
	self.locationmanager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    // start search animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.duration = 2.0;
	animation.repeatCount = HUGE_VALF;
	animation.autoreverses = YES;
	animation.fromValue = @1.f;
	animation.toValue = @0.f;
	[self.throbberView.layer addAnimation:animation forKey:nil];
	
	[Assimilator sharedAssimilator].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// start searching for a location
	[self.locationmanager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationmanager stopUpdatingLocation];
	// grab the most recent location and pass it to the assimilator to find nearby points
	CLLocation *location = [locations lastObject];
    NSLog(@"Latitude:%f.Longitude:%f",location.coordinate.latitude,location.coordinate.longitude);
	[[Assimilator sharedAssimilator] findNearbyLocations:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Oops,%@",error);
	
	if (error.code == kCLErrorDenied)
	{
		// bug the user about it
		self.throbberView.hidden = YES;
		
		// showing the we kinda need location label
		[self.userIsBeingUppityLabel addGlowShadow];
		self.userIsBeingUppityLabel.hidden = NO;
		
		[self.locationmanager stopUpdatingLocation];
	}
	else
	{
		// yeah great error handling there Tim...
		[self.locationmanager startUpdatingLocation];
	}
}
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
	self.userIsBeingUppityLabel.hidden = YES;
	self.throbberView.hidden = NO;
}

- (void)assimilator:(Assimilator *)assimilator didFindNearbyLocations:(NSArray *)locations
{
    // push the list of locations onto the view stack
    [self performSegueWithIdentifier:@"locationsFoundSegue" sender:locations];
    // temporary hack
    [Assimilator sharedAssimilator].delegate = nil;
}

- (void)assimilator:(Assimilator *)assimilator failedToFindNearbyLocation:(NSError *)error
{
    // start searching again
    // might be worth putting in some sort of after x seconds give up for real
    // pop up a message saying try again later
    [self.locationmanager startUpdatingLocation];
    NSLog(@"Something has gone wrong");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [Assimilator sharedAssimilator].delegate = nil;
	if ([segue.identifier isEqualToString:@"locationsFoundSegue"])
	{
		LocationListViewController *vc = segue.destinationViewController;
		vc.locations = sender;
	}
}

@end
