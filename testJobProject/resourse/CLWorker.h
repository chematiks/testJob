//
//  CLWorker.h
//  testJobProject
//
//  Created by Администратор on 9/25/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLStaff.h"

@interface CLWorker : CLStaff

@property (nonatomic,strong) NSString * seatNumber;
@property (nonatomic,strong) NSString * dinnerTime;

@end
