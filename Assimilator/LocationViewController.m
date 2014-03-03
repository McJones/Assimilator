//
//  LocationViewController.m
//  Assimilator
//
//  Created by Tim Nugent on 11/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "LocationViewController.h"
#import "AssimilatorSearchViewController.h"
#import "UIImage-Grayscale/UIImage+Grayscale.h"
#import "UIView+GlowShadow.h"

@interface LocationViewController ()<AssimilatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *allegianceImageView;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *neutralNodeImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *townLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageThrobber;

@end

@implementation LocationViewController

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

	self.titleLabel.text = self.location[@"title"];
	[self.titleLabel addGlowShadow];
    
    self.townLabel.text = self.location[@"locality"];
    [self.townLabel addGlowShadow];
	
	// text based on locations assimilationability
	if ([[Assimilator sharedAssimilator] canAssimilate:self.location.objectId])
		self.buttonLabel.text = @"Assimilate Node";
	else
		self.buttonLabel.text = @"Temporarily Locked";
	
	// adding a glow to the assimilate button label
	[self.buttonLabel addGlowShadowWithColour:[UIColor orangeColor]];
	
	// adding a glow to the status label
	[self.statusLabel addGlowShadow];
	
	if (self.location[@"imageURL"])
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.location[@"imageURL"]]]];
			image = [image convertToGrayscale];
			dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageThrobber stopAnimating];
				self.locationImageView.image = image;
			});
		});
	}
	else
	{
        [self.imageThrobber stopAnimating];
		[self.locationImageLabel addGlowShadow];
		self.locationImageLabel.hidden = NO;
        self.locationImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.locationImageView.layer.borderWidth = 1.f;
        [self.locationImageView addGlowShadow];
	}
    
    NSNumber *lizardCount = self.location[LIZARD_KEY];
    NSNumber *illuminatiCount = self.location[ILLUM_KEY];
    
    if (lizardCount.intValue == illuminatiCount.intValue)
    {
        self.neutralNodeImageLabel.hidden = NO;
        [self.neutralNodeImageLabel addGlowShadow];
    }
    else if (lizardCount.intValue > illuminatiCount.intValue)
        self.allegianceImageView.image = [UIImage imageNamed:@"LizardPeople"];
    else
        self.allegianceImageView.image = [UIImage imageNamed:@"Illuminati"];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[Assimilator sharedAssimilator].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)assimilateLocationTapped:(id)sender
{
	NSLog(@"attempting to assimilate %@",self.location.objectId);
	if ([[Assimilator sharedAssimilator] canAssimilate:self.location.objectId])
	{
		[[Assimilator sharedAssimilator] assimilate:self.location.objectId];
		[self toggleStatusLabel:NO];
	}
	else
	{
        NSLog(@"cannot assimilate");
		[self popToAssimilatorSearch];
	}
}

- (void)assimilator:(Assimilator *)assimilator didAssimilateLocation:(NSString *)locationUUID
{
	[self popToAssimilatorSearch];
}

- (void)popToAssimilatorSearch
{
	// pop back to the AssimilatorSearchViewController
	for (id viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[AssimilatorSearchViewController class]])
		{
			[self.navigationController popToViewController:viewController animated:YES];
			break;
		}
	}
}

- (void)toggleStatusLabel:(BOOL)hidden
{
	self.statusLabel.hidden = hidden;
    
    self.townLabel.hidden = !hidden;
	self.titleLabel.hidden = !hidden;
	self.buttonLabel.hidden = !hidden;
	self.locationImageView.hidden = !hidden;
    self.locationImageLabel.hidden = !hidden;
	self.allegianceImageView.hidden = !hidden;
    self.neutralNodeImageLabel.hidden = !hidden;
	
	if (hidden)
	{
        [self.imageThrobber startAnimating];
        
		[self.statusLabel.layer removeAllAnimations];
	}
	else
	{
        [self.imageThrobber stopAnimating];
        
		// start search animation
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animation.duration = 2.0;
		animation.repeatCount = HUGE_VALF;
		animation.autoreverses = YES;
		animation.fromValue = @1.f;
		animation.toValue = @0.f;
		[self.statusLabel.layer addAnimation:animation forKey:nil];
	}
}

@end
