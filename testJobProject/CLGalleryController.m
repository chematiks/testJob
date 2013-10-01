//
//  CLGalleryController.m
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLGalleryController.h"

@interface CLGalleryController ()

@end

@implementation CLGalleryController

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
    [self.imageView setImage:self.imageObject];
    //[self.imageView setImage:[UIImage imageNamed:@"2.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}
@end
