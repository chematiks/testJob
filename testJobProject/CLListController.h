//
//  CLListController.h
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CLDirection.h"
#import "CLWorker.h"
#import "CLBookkeeping.h"

@interface CLListController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    UITableView * tableViewList;
    NSMutableArray * _direction;
    NSMutableArray * _worker;
    NSMutableArray * _bookkeeping;
    BOOL _edit;
    int changeEntity;
    NSRange range;
}

@property (readonly,strong,nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly,strong,nonatomic) NSManagedObjectContext * managedObjectContext;
@property (readonly,strong,nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) NSMutableArray * direction;
@property (strong,nonatomic) NSMutableArray * worker;
@property (strong,nonatomic) NSMutableArray * bookkeeping;
@property (strong,nonatomic) CLDirection * directionObject;
@property (strong,nonatomic) CLWorker *workerObject;
@property (strong,nonatomic) CLBookkeeping * bookkeepingObject;
@property (nonatomic) BOOL edit;

-(void) saveContext;
-(NSURL *) applicationsDocumentsDirectory;
-(void) deleteElement:(int) classElement;


@end
