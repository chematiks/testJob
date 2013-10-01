//
//  CLDetailListViewController.m
//  testJobProject
//
//  Created by Администратор on 9/26/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLDetailListViewController.h"
#import "CLListController.h"

@interface CLDetailListViewController ()

@end

@implementation CLDetailListViewController

//метод создания интерфейса
-(void) initInterfaceLabelAndField
{
    [labelDetailTimeFrom removeFromSuperview];
    [labelSeatNumber removeFromSuperview];
    [fieldSeatNumber removeFromSuperview];
    [labelTypeBuch removeFromSuperview];
    [fieldTypeBuch removeFromSuperview];
    
    labelDetailTimeFrom=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 285.0, 120.0, 21.0)];
    labelDetailTimeFrom.font=[UIFont systemFontOfSize:14];
    labelDetailTimeFrom.textColor=[UIColor blackColor];
    
    labelDetailTimeTo=[[UILabel alloc] initWithFrame:CGRectMake(220.0, 285.0, 30.0, 21.0)];
    labelDetailTimeTo.font=[UIFont systemFontOfSize:14];
    labelDetailTimeTo.textColor=[UIColor blackColor];
    labelDetailTimeTo.text=@"до:";
    
    fieldDetailTimeFrom=[[UITextField alloc] initWithFrame:CGRectMake(135, 281, 60, 30)];
    fieldDetailTimeFrom.borderStyle=UITextBorderStyleRoundedRect;
    fieldDetailTimeFrom.font=[UIFont systemFontOfSize:14];
    fieldDetailTimeFrom.autocorrectionType=UITextAutocorrectionTypeNo;
    [fieldDetailTimeFrom addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldDetailTimeFrom addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldDetailTimeFrom addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    fieldDetailTimeTo=[[UITextField alloc] initWithFrame:CGRectMake(245, 281, 60, 30)];
    fieldDetailTimeTo.borderStyle=UITextBorderStyleRoundedRect;
    fieldDetailTimeTo.font=[UIFont systemFontOfSize:14];
    fieldDetailTimeTo.autocorrectionType=UITextAutocorrectionTypeNo;
    [fieldDetailTimeTo addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldDetailTimeTo addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldDetailTimeTo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.view addSubview:labelDetailTimeTo];
    [self.view addSubview:fieldDetailTimeFrom];
    [self.view addSubview:fieldDetailTimeTo];
    
    labelSeatNumber=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 320.0, 180.0, 21.0)];
    labelSeatNumber.font=[UIFont systemFontOfSize:14];
    labelSeatNumber.textColor=[UIColor blackColor];
    labelSeatNumber.text=@"Номер рабочего места:";
    fieldSeatNumber=[[UITextField alloc] initWithFrame:CGRectMake(205, 316, 100, 30)];
    fieldSeatNumber.borderStyle=UITextBorderStyleRoundedRect;
    fieldSeatNumber.font=[UIFont systemFontOfSize:14];
    fieldSeatNumber.autocorrectionType=UITextAutocorrectionTypeNo;
    [fieldSeatNumber addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldSeatNumber addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldSeatNumber addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    labelTypeBuch=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 355.0, 180.0, 21.0)];
    labelTypeBuch.font=[UIFont systemFontOfSize:14];
    labelTypeBuch.textColor=[UIColor blackColor];
    labelTypeBuch.text=@"Тип бухгалтера:";
    fieldTypeBuch=[[UITextField alloc] initWithFrame:CGRectMake(205, 351, 100, 30)];
    fieldTypeBuch.borderStyle=UITextBorderStyleRoundedRect;
    fieldTypeBuch.font=[UIFont systemFontOfSize:14];
    fieldTypeBuch.autocorrectionType=UITextAutocorrectionTypeNo;
    [fieldTypeBuch addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldTypeBuch addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldTypeBuch addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.navigationItem setTitle:@"Detail"];
    
    [self.view addSubview:labelDetailTimeFrom];
    [self.view addSubview:labelSeatNumber];
    [self.view addSubview:fieldSeatNumber];
    [self.view addSubview:labelTypeBuch];
    [self.view addSubview:fieldTypeBuch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inputClass=4;
    [self initInterfaceLabelAndField];

    UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(unlockInterface:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    //заполнение элементов вида данными, в случае редактирования записи
    NSInteger numberViewcontrollers= [self.navigationController.viewControllers count];
    CLListController *listController=[self.navigationController.viewControllers objectAtIndex:numberViewcontrollers-2];
    if (listController.workerObject) {
        self.segmentControl.selectedSegmentIndex=1;
        inputClass=1;
        [self changeTypeList:self.segmentControl];
        NSString * nameSurname=listController.workerObject.nameSurname;
        self.surnameField.text=[self getSurname:nameSurname];
        self.nameLabel.text=[self getName:nameSurname];
        self.otchestvoLabel.text=[self getOtchestvo:nameSurname];
        self.salaryLabel.text=listController.workerObject.salary;
        fieldSeatNumber.text=listController.workerObject.seatNumber;
        NSString * time=listController.workerObject.dinnerTime;
        fieldDetailTimeFrom.text=[self getTimeFrom:time];
        fieldDetailTimeTo.text=[self getTimeTo:time];
    }else
        if (listController.directionObject) {
            self.segmentControl.selectedSegmentIndex=0;
            inputClass=0;
            [self changeTypeList:self.segmentControl];
            NSString * nameSurname=listController.directionObject.nameSurname;
            self.surnameField.text=[self getSurname:nameSurname];
            self.nameLabel.text=[self getName:nameSurname];
            self.otchestvoLabel.text=[self getOtchestvo:nameSurname];
            self.salaryLabel.text=listController.directionObject.salary;
            NSString * time=listController.directionObject.businessHours;
            fieldDetailTimeFrom.text=[self getTimeFrom:time];
            fieldDetailTimeTo.text=[self getTimeTo:time];
        }else{
            self.segmentControl.selectedSegmentIndex=2;
            inputClass=2;
            [self changeTypeList:self.segmentControl];
            NSString * nameSurname=listController.bookkeepingObject.nameSurname;
            self.surnameField.text=[self getSurname:nameSurname];
            self.nameLabel.text=[self getName:nameSurname];
            self.otchestvoLabel.text=[self getOtchestvo:nameSurname];
            self.salaryLabel.text=listController.bookkeepingObject.salary;
            fieldSeatNumber.text=listController.bookkeepingObject.seatNumber;
            NSString * time=listController.bookkeepingObject.dinnerTime;
            fieldDetailTimeFrom.text=[self getTimeFrom:time];
            fieldDetailTimeTo.text=[self getTimeTo:time];
            fieldTypeBuch.text=listController.bookkeepingObject.typeBookkeeping;
        }
    
    //если мы просматриваем запись, то блокируем внесение изменений
    if (listController.edit) [self lockInterface];
    //если добавили новую запись то не блокируем ввод данных
    else [self unlockInterface:self];

}

//метод блокировки интерфейса
-(void) lockInterface
{
    self.nameLabel.enabled=NO;
    self.surnameField.enabled=NO;
    self.otchestvoLabel.enabled=NO;
    self.salaryLabel.enabled=NO;
    self.segmentControl.enabled=NO;
    fieldDetailTimeFrom.enabled=NO;
    fieldDetailTimeTo.enabled=NO;
    fieldSeatNumber.enabled=NO;
    fieldTypeBuch.enabled=NO;
}

//метод разблокировки интерфейса
-(void) unlockInterface:(id)sender
{
    UIBarButtonItem * saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPress:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    self.nameLabel.enabled=YES;
    self.surnameField.enabled=YES;
    self.otchestvoLabel.enabled=YES;
    self.salaryLabel.enabled=YES;
    self.segmentControl.enabled=YES;
    fieldDetailTimeFrom.enabled=YES;
    fieldDetailTimeTo.enabled=YES;
    fieldSeatNumber.enabled=YES;
    fieldTypeBuch.enabled=YES;
}

//получение данных о времени старта из строки
-(NSString *) getTimeFrom:(NSString *) string
{
    range.length=2;
    range.location=0;
    return [string substringWithRange:range];
}

//получение данных о времени финиша из строки
-(NSString *) getTimeTo:(NSString *) string
{
    range.length=2;
    range.location=2;
    return [string substringWithRange:range];
}

//получение имени из строки ФИО
-(NSString *) getName:(NSString *)nameSurname
{
    range.location=range.length+1;
    range.length=nameSurname.length-range.location;
    nameSurname=[nameSurname substringWithRange:range];
    range.length=[nameSurname rangeOfString:@" "].location;
    range.location=0;
    return [nameSurname substringWithRange:range];
}

//получение фамилии из строки ФИО
-(NSString *) getSurname:(NSString *)nameSurname
{
    range.length=[nameSurname rangeOfString:@" "].location;
    range.location=0;
    return [nameSurname substringWithRange:range];
}

//получение отчетсва из строки ФИО
-(NSString *) getOtchestvo:(NSString *)nameSurname
{
    range.location=[nameSurname rangeOfString:@" "].location+1;
    range.length=[nameSurname length]-range.location;
    nameSurname=[nameSurname substringWithRange:range];
    range.location=[nameSurname rangeOfString:@" "].location+1;
    range.length=[nameSurname length]-range.location;
    return [nameSurname substringWithRange:range];
}

//метод сохрания изменений
-(void) saveButtonPress:(id)sender
{
    NSInteger numberViewcontrollers= [self.navigationController.viewControllers count];
    CLListController *listController=[self.navigationController.viewControllers objectAtIndex:numberViewcontrollers-2];
    if (self.segmentControl.selectedSegmentIndex==0){
        
        if (!listController.directionObject) {
            listController.directionObject=[[[CLDirection alloc] init] autorelease];
        }
        if (self.segmentControl.selectedSegmentIndex!=inputClass)
            [listController deleteElement:inputClass];
        listController.directionObject.nameSurname=[NSString stringWithFormat:@"%@ %@ %@",self.surnameField.text,self.nameLabel.text,self.otchestvoLabel.text];
        listController.directionObject.salary=self.salaryLabel.text;
        listController.directionObject.businessHours=[self getTimeToSave];
    }else
        if (self.segmentControl.selectedSegmentIndex==1) {
            if (! listController.workerObject) {
                listController.workerObject=[[[CLWorker alloc] init]autorelease];
            }
            if (self.segmentControl.selectedSegmentIndex!=inputClass)
                [listController deleteElement:inputClass];
            listController.workerObject.nameSurname=[NSString stringWithFormat:@"%@ %@ %@",self.surnameField.text,self.nameLabel.text,self.otchestvoLabel.text];
            listController.workerObject.dinnerTime=[self getTimeToSave];
            listController.workerObject.seatNumber=fieldSeatNumber.text;
            listController.workerObject.salary=self.salaryLabel.text;
        }else{
            if (!listController.bookkeepingObject) {
                listController.bookkeepingObject=[[[CLBookkeeping alloc] init]autorelease];
            }
            if (self.segmentControl.selectedSegmentIndex!=inputClass)
                [listController deleteElement:inputClass];
            listController.bookkeepingObject.nameSurname=[NSString stringWithFormat:@"%@ %@ %@",self.surnameField.text,self.nameLabel.text,self.otchestvoLabel.text];
            listController.bookkeepingObject.dinnerTime=[self getTimeToSave];
            listController.bookkeepingObject.seatNumber=fieldSeatNumber.text;
            listController.bookkeepingObject.salary=self.salaryLabel.text;
            listController.bookkeepingObject.typeBookkeeping=fieldTypeBuch.text;
        }
    
    [listController saveContext];

    [[self navigationController] popToRootViewControllerAnimated:YES];
}

//получние времени старта и финиша в одной строке
-(NSString *) getTimeToSave;
{
    if ([fieldDetailTimeFrom.text length]==0) fieldDetailTimeFrom.text=@"??";
    if ([fieldDetailTimeTo.text length]==0) fieldDetailTimeTo.text=@"??";
    if ([fieldDetailTimeFrom.text length]<2) {
        fieldDetailTimeFrom.text=[NSString stringWithFormat:@"0%@",fieldDetailTimeFrom.text];
    }
    if ([fieldDetailTimeTo.text length]<2) {
        fieldDetailTimeTo.text=[NSString stringWithFormat:@"0%@",fieldDetailTimeTo.text];
    }
    return [NSString stringWithFormat:@"%@%@",fieldDetailTimeFrom.text,fieldDetailTimeTo.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//метод настройки интерфейса после смены категории данных
- (IBAction)changeTypeList:(id)sender {
    NSInteger selectedSegment=self.segmentControl.selectedSegmentIndex;
    if (selectedSegment==0) {
        [self addDirectionDetail];
    }
    if (selectedSegment==1) {
        [self addWorkerDetail];
    }
    if (selectedSegment==2) {
        [self addBookkeeperDetail];
    }
}

//при выборе категории руководства
-(void) addDirectionDetail
{
    labelDetailTimeFrom.text=@"Часы приема с:";
    fieldTypeBuch.hidden=YES;
    labelTypeBuch.hidden=YES;
    labelSeatNumber.hidden=YES;
    fieldSeatNumber.hidden=YES;
}

//при выборе категории сотрудника
-(void) addWorkerDetail
{
    labelDetailTimeFrom.text=@"Время обеда с:";
    fieldTypeBuch.hidden=YES;
    labelTypeBuch.hidden=YES;
    labelSeatNumber.hidden=NO;
    fieldSeatNumber.hidden=NO;
}

//при выборе категории бухгалтера
-(void) addBookkeeperDetail
{
    [self addWorkerDetail];
    fieldTypeBuch.hidden=NO;
    labelTypeBuch.hidden=NO;
    labelSeatNumber.hidden=NO;
    fieldSeatNumber.hidden=NO;
}

- (void)dealloc {
    [_segmentControl release];
    [_nameLabel release];
    [_otchestvoLabel release];
    [_salaryLabel release];
    [super dealloc];
}

//метод устранения клавиатуры после нажатия кнопки возврата
-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

//после редактирования возращаем все элементы на место
- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame=CGRectMake(0, 0, 320, 480);
    [UIView commitAnimations];
}

//если редактируем запись, сдвигаем весь интерфейс так, чтобы выл виден вводимый текст
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    float deltaY=[self getDeltaY:sender];
    self.view.frame=CGRectMake(0, deltaY, 320, 480);
    [UIView commitAnimations];
}

//метод получени величины смещения
-(float) getDeltaY:(UITextField *) sender{
    float deltaY=0;
    if (sender==_salaryLabel)
        deltaY=-10.f;
    if (sender==fieldDetailTimeFrom||sender==fieldDetailTimeTo)
        deltaY=-50.f;
    if (sender==fieldSeatNumber)
        deltaY=-85.f;
    if (sender==fieldTypeBuch)
        deltaY=-120.f;
    
    return deltaY;
}

@end
