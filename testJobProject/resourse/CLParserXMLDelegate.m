//
//  CLParserXMLDelegate.m
//  testJobProject
//
//  Created by Администратор on 9/25/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLParserXMLDelegate.h"
#import "CLBashData.h"

@implementation CLParserXMLDelegate

@synthesize done=m_done;
@synthesize notes=m_Note;
@synthesize error=m_error;

-(void) dealloc
{
    [m_error dealloc];
    [m_Note release];
    [super dealloc];
}

//парсинг толька начался, делаем отметку и заводим массив для хранения данных
-(void) parserDidStartDocument:(NSXMLParser *)parser{
    m_done=NO;
    m_Note=[NSMutableArray new];
}

//если закончился документ
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    m_done=YES;
}

-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    m_done=YES;
    m_error=[parseError retain];
}

-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    m_done =YES;
    m_error=[validationError retain];
}

//если находим начало цитаты создаем контейнер для данных
//если находим начало одного из полей, отмечаем с каким полем работаем и создаем строку для хранения данного поля
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([[elementName lowercaseString] isEqualToString:@"quote"])
        currentNote=[[CLBashData alloc] init];
    if ([[elementName lowercaseString] isEqualToString:@"id"])
    {
        m_isId=[[elementName lowercaseString] isEqualToString:@"id"];
        m_isDate=NO; m_isTitle=NO;
        m_id=[NSMutableString new];
    }
    if ([[elementName lowercaseString] isEqualToString:@"date"])
    {
        m_isDate=[[elementName lowercaseString] isEqualToString:@"date"];
        m_isId=NO; m_isTitle=NO;
        m_date=[NSMutableString new];
    }
    if ([[elementName lowercaseString] isEqualToString:@"text"])
    {
        m_isTitle=[[elementName lowercaseString] isEqualToString:@"text"];
        m_isId=NO; m_isDate=NO;
        m_title=[NSMutableString new];
    }
}

//если находим конец цитаты пушим данные в массив
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([[elementName lowercaseString] isEqualToString:@"quote"])
    {
        currentNote.idNote=m_id;
        currentNote.dateNote=m_date;
        currentNote.textNote=m_title;
        [m_Note addObject:currentNote];
        
        m_isDate=NO;
        m_isId=NO;
        m_isTitle=NO;
        [currentNote release];
    }
}

//если сейчас обрабатывается одно из полей, записываем в его строку данные
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (m_isTitle) {
        [m_title appendString:string];
    }
    if (m_isId) {
        [m_id appendString: string];
    }
    if (m_isDate){
        [m_date appendString:string];
    }
}

@end
