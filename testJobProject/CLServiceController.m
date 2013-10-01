//
//  CLServiceController.m
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLServiceController.h"
#import "CLParserXMLDelegate.h"
#import "CLBashData.h"

@interface CLServiceController ()

@end

@implementation CLServiceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//загрузка и парсинг данных
-(void) loadDataXml
{
    self.arrayNote =[NSMutableArray array];
    NSString * stringURL=@"http://bash.zennexgroup.com/service/ru/get.php?type=last";
    NSURL * url=[[NSURL alloc] initWithString:stringURL];
    
    CLParserXMLDelegate * delegate=[CLParserXMLDelegate new];
    
    NSXMLParser * parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:delegate];
    [parser parse];
    
    while (!delegate.done) sleep(1);
    if (delegate.error==nil) {
    }else{
        NSLog(@"error %@",delegate.error);}
    
    self.arrayNote=[NSMutableArray arrayWithArray:delegate.notes];
    
    [url release];
    [delegate release];
    [parser release];
}

//отображаю информацию и останавливаю троббер
-(void) showText
{
    NSString * text=self.textView.text;
    for (int i=1; i<self.arrayNote.count-1; i++) {
        CLBashData * printNote=[self.arrayNote objectAtIndex:i];
        if (printNote.dateNote)
            text=[text stringByAppendingString:printNote.dateNote];
        if (printNote.textNote)
            text=[text stringByAppendingString:printNote.textNote];
    }
    
    [self.trobber stopAnimating];
    
    self.textView.text=text;
}

//во втором потоке загружаю данные, после загрузки возвращаюсь в главный тред и отображаю информацию
-(void) backgroundPotok
{
    [self loadDataXml];
    
    [self performSelectorOnMainThread:@selector(showText) withObject:nil waitUntilDone:YES];
}

//перед показом вьюхи запускаю троббер и отправляю загрузку контента во 2 поток
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.text=[NSString stringWithFormat:@"      "];
    
    [self.trobber startAnimating];
    
    [self performSelectorInBackground:@selector(backgroundPotok) withObject:nil];
}

-(void) dealloc
{
    [_textView release];
    [_trobber release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
