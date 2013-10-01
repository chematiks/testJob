//
//  CLParserXMLDelegate.h
//  testJobProject
//
//  Created by Администратор on 9/25/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBashData.h"

@interface CLParserXMLDelegate : NSObject <NSXMLParserDelegate>
{
    BOOL m_done;
    BOOL m_isTitle;
    BOOL m_isId;
    BOOL m_isDate;
    
    NSError * m_error;
    
    NSMutableArray * m_Note;
    
    NSMutableString * m_title;
    NSMutableString * m_id;
    NSMutableString * m_date;
    
    CLBashData * currentNote;
}

@property (readonly) BOOL done;

@property (readonly) NSError * error;

@property (readonly) NSArray * notes;

@end
