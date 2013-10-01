//
//  CLListTableViewCell.m
//  testJobProject
//
//  Created by Администратор on 9/27/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLListTableViewCell.h"

@implementation CLListTableViewCell

@synthesize surnameNameLabel=_surnameNameLabel;
@synthesize salaryLabel=_salaryLabel;
@synthesize hourLabel=_hourLabel;
@synthesize numberWorkPlaceLabel=_numberWorkPlaceLabel;
@synthesize typeBookkeepingLabel=_typeBookkeepingLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // создание вида ячейки и инициализация всех элементов
        _mainViewCell=[[UIView alloc] initWithFrame:CGRectMake(0,0,320,85)];
        
        _surnameNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 300, 15)];
        _surnameNameLabel.font=[UIFont systemFontOfSize:13];
        _surnameNameLabel.textColor=[UIColor blackColor];
        
        _salaryLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 19, 300, 15)];
        _salaryLabel.font=[UIFont systemFontOfSize:11];
        _salaryLabel.textColor=[UIColor blackColor];
        
        _hourLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 36, 300, 15)];
        _hourLabel.font=[UIFont systemFontOfSize:11];
        _hourLabel.textColor=[UIColor blackColor];
        
        _numberWorkPlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 53, 300, 15)];
        _numberWorkPlaceLabel.font=[UIFont systemFontOfSize:11];
        _numberWorkPlaceLabel.textColor=[UIColor blackColor];
        
        _typeBookkeepingLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 70, 300, 15)];
        _typeBookkeepingLabel.font=[UIFont systemFontOfSize:11];
        _typeBookkeepingLabel.textColor=[UIColor blackColor];
        
        //добавление к общему виду всех элементов
        [_mainViewCell addSubview:_surnameNameLabel];
        [_mainViewCell addSubview:_salaryLabel];
        [_mainViewCell addSubview:_hourLabel];
        [_mainViewCell addSubview:_numberWorkPlaceLabel];
        [_mainViewCell addSubview:_typeBookkeepingLabel];
        [self addSubview:_mainViewCell];
    }
    return self;
}

//если стиль ячейки становится редактируемым то сдвигаем все элементы на 45 пикселей
//если вернули стиль ячейки в нередактируемый, возвращаем все элементы обратно
-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    int dRigth=50;
    int dLeft=5;
    if (editing) {
        CGRect rect=_surnameNameLabel.frame;
        rect.origin.x=dRigth;
        _surnameNameLabel.frame=rect;
        rect=_salaryLabel.frame;
        rect.origin.x=dRigth;
        _salaryLabel.frame=rect;
        rect=_hourLabel.frame;
        rect.origin.x=dRigth;
        _hourLabel.frame=rect;
        rect=_numberWorkPlaceLabel.frame;
        rect.origin.x=dRigth;
        _numberWorkPlaceLabel.frame=rect;
        rect=_typeBookkeepingLabel.frame;
        rect.origin.x=dRigth;
        _typeBookkeepingLabel.frame=rect;
    }else{
        CGRect rect=_surnameNameLabel.frame;
        rect.origin.x=dLeft;
        _surnameNameLabel.frame=rect;
        rect=_salaryLabel.frame;
        rect.origin.x=dLeft;
        _salaryLabel.frame=rect;
        rect=_hourLabel.frame;
        rect.origin.x=dLeft;
        _hourLabel.frame=rect;
        rect=_numberWorkPlaceLabel.frame;
        rect.origin.x=dLeft;
        _numberWorkPlaceLabel.frame=rect;
        rect=_typeBookkeepingLabel.frame;
        rect.origin.x=dLeft;
        _typeBookkeepingLabel.frame=rect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
