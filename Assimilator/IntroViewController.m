//
//  ViewController.m
//  Assimilator
//
//  Created by Tim Nugent on 9/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "IntroViewController.h"
#import "UIView+GlowShadow.h"

@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (strong, nonatomic) NSArray *messageList;
@property (nonatomic) NSInteger messageCount;
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.messageList = @[@"Welcome Back Agent",@"Though I am Afraid It Is Only For Bad News",@"They Are Everywhere",@"We Never Questioned",@"Why Do We Have So Many Heritage Buildings?",@"Just A Quirk Of History",@"We Were Wrong",@"They Were Both\nHiding In Them",@"Making Them Home",@"Every One Is Now Their Bastion",@"But They Both Made A Mistake",@"One We Can Use",@"I Am Upgrading Your Phone",@"You Should Be Able To Locate And Claim Their Buildings Nodes",@"Forcing A Change In Ownership",@"At Least Until One Of Their Operatives Can Undo It",@"We May Have Lost Our War",@"But We Can Disrupt Theirs",@"Time To Pick A Side Agent"];
    
    [self.storyLabel addGlowShadow];
    
    [self.tapLabel addGlowShadowWithColour:[UIColor orangeColor]];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.duration = 2.0;
	animation.repeatCount = HUGE_VALF;
	animation.autoreverses = YES;
	animation.fromValue = @1.f;
	animation.toValue = @0.f;
    [self.tapLabel.layer addAnimation:animation forKey:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.messageCount = 0;
    self.storyLabel.text = self.messageList[self.messageCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapped:(id)sender
{
    self.messageCount++;
    if (self.messageCount >= self.messageList.count)
        [self performSegueWithIdentifier:@"introCompleteSegue" sender:self];
    else
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.storyLabel.alpha = 0.f;
                         }
                         completion:^(BOOL finished) {
                             self.storyLabel.text = self.messageList[self.messageCount];
                             [UIView animateWithDuration:0.5
                                              animations:^{
                                                  self.storyLabel.alpha = 1.f;
                                              }];
                         }];
    }
}

@end
