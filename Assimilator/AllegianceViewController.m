//
//  AllegianceViewController.m
//  Assimilator
//
//  Created by Tim Nugent on 10/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "AllegianceViewController.h"
#import "Assimilator.h"
#import "UIView+GlowShadow.h"

@interface AllegianceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *illuminatiButton;
@property (weak, nonatomic) IBOutlet UIButton *lizardPeopleButton;

@end

@implementation AllegianceViewController

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
    [self.titleLabel addGlowShadow];
    
    self.lizardPeopleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.illuminatiButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"lizardPeopleSegue"])
	{
		[Assimilator sharedAssimilator].allegiance = LIZARD_PEOPLE;
		[[NSUserDefaults standardUserDefaults] setObject:LIZARD_KEY forKey:@"allegiance"];
	}
	else
	{
		[Assimilator sharedAssimilator].allegiance = ILLUMINATI;
		[[NSUserDefaults standardUserDefaults] setObject:ILLUM_KEY forKey:@"allegiance"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
