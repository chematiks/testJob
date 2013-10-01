//
//  CLBashData.h
//  testJobProject
//
//  Created by Администратор on 9/25/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
//контейнер для хранения одной цитаты
@interface CLBashData : NSObject

//заводим три строки свойства для хранения полей одной цитаты
@property (nonatomic,strong) NSString * idNote;
@property (nonatomic,strong) NSString * dateNote;
@property (nonatomic,strong) NSString * textNote;

@end
