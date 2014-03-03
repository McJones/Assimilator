//
//  AboutPageViewController.m
//  Assimilator
//
//  Created by Tim Nugent on 18/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "AboutPageViewController.h"
#import "UIView+GlowShadow.h"
#import "AssimilatorSearchViewController.h"
#import "Assimilator.h"

@interface AboutPageViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

@end

@implementation AboutPageViewController

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
    
    [self.buttonLabel addGlowShadowWithColour:[UIColor orangeColor]];
    [self.webview loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"assimilator" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToTheFieldPressed:(id)sender
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
- (IBAction)resetGameTap:(id)sender
{
    [[Assimilator sharedAssimilator] resetGame];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-  (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
