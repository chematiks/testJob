//
//  CLListController.m
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLListController.h"
#import "CLDetailListViewController.h"
#import "CLListTableViewCell.h"

@interface CLListController ()

@end

@implementation CLListController

static NSString * const kIndex=@"index";
static NSString * const kNameSurname=@"nameSurname";
static NSString * const kSalary=@"salary";
static NSString * const kDinnerTime=@"dinnerTime";
static NSString * const kSeatNumber=@"seatNumber";
static NSString * const kTypeBookkeeping=@"typeBookkeeping";
static NSString * const kBusinessHours=@"businessHours";

static NSString * const eDirection=@"Direction";
static NSString * const eBookkeepping=@"Bookkeeping";
static NSString * const eWorker=@"Worker";

@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize direction=_direction;
@synthesize worker=_worker;
@synthesize bookkeeping=_bookkeeping;
@synthesize edit=_edit;

//инициализация модели данных
-(NSManagedObjectModel * ) managedObjectModel{
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    
    NSURL * modelURL=[[NSBundle mainBundle] URLForResource:@"listDB" withExtension:@"momd"];
    _managedObjectModel =[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return  _managedObjectModel;
}

//инициализация хранилища
-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator !=nil)
        return _persistentStoreCoordinator;
    NSURL *storeURL=[[self applicationsDocumentsDirectory] URLByAppendingPathComponent:@"listDB.sqlite"];
    NSError * error=nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"error %@ %@",error,[error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

-(NSURL *) applicationsDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//инициализация контекста
-(NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext !=nil)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator * coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

//процедура удаления объекта, запускается в случае изменения категории редактируемой ячейки
-(void) deleteElement:(int) classElement
{
    changeEntity=classElement;
    NSManagedObjectContext * context=[self managedObjectContext];
    if (classElement==0){
        for (NSManagedObject * obj in _direction) {
            if ([obj valueForKey:kIndex]==self.directionObject.index) {
                [context deleteObject:obj];
                break;
            }
        }
    }else
        if (classElement==1){
            for (NSManagedObject * obj in _worker) {
                if ([obj valueForKey:kIndex]==self.workerObject.index) {
                    [context deleteObject:obj];
                    break;
                }
            }
        }else{
            for (NSManagedObject * obj in _bookkeeping) {
                if ([obj valueForKey:kIndex]==self.bookkeepingObject.index) {
                    [context deleteObject:obj];
                    break;
                }
            }
        }
    [self loadDataOnListDB];
    [tableViewList reloadData];
}

//сохранение в базе контекста
-(void) saveContext
{
    NSManagedObjectContext * context=[self managedObjectContext];
    
    //если хотябы один объект есть, проверяем
    if (self.workerObject||self.directionObject||self.bookkeepingObject){
        //если это объект сотрудника, и была смена категории объекта
        if (self.workerObject&& changeEntity!=1){
            NSManagedObject * object=nil;
            if (_edit==YES){
                //если мы редактируем старый элемент
                for (NSManagedObject * obj in _worker) {
                    //если находим объект с таким же индексом то перезаписываем его
                    if ([obj valueForKey:kIndex]==self.workerObject.index) {
                        object=obj;
                        break;
                    }
                }
            }
            else{
                //если объект не редактировался, создаем новый объект
                object=[NSEntityDescription insertNewObjectForEntityForName:eWorker inManagedObjectContext:context];
                //даем ему уникальный индекс
                [object setValue:[self getUniqueIndex:_worker] forKey:kIndex];
            }
            //заполняем все поля данными
            [object setValue:self.workerObject.nameSurname forKey:kNameSurname];
            [object setValue:self.workerObject.salary forKey:kSalary];
            [object setValue:self.workerObject.dinnerTime forKey:kDinnerTime];
            [object setValue:self.workerObject.seatNumber forKey:kSeatNumber];
        }else
            //аналогично для других типов объекта
            if (self.directionObject && changeEntity!=0){
                NSManagedObject * object=nil;
                if (_edit==YES){
                    for (NSManagedObject * obj in _direction) {
                        if ([obj valueForKey:kIndex]==self.directionObject.index) {
                            object=obj;
                            break;
                        }
                    }
                }
                else{
                    object=[NSEntityDescription insertNewObjectForEntityForName:eDirection inManagedObjectContext:context];
                    [object setValue:[self getUniqueIndex:_direction] forKey:kIndex];
                }
                [object setValue:self.directionObject.nameSurname forKey:kNameSurname];
                [object setValue:self.directionObject.salary forKey:kSalary];
                [object setValue:self.directionObject.businessHours forKey:kBusinessHours];
                
            }else{
                NSManagedObject * object=nil;
                if (_edit==YES){
                    for (NSManagedObject * obj in _bookkeeping) {
                        if ([obj valueForKey:kIndex]==self.bookkeepingObject.index) {
                            object=obj;
                            break;
                        }
                    }
                }
                else{
                    object=[NSEntityDescription insertNewObjectForEntityForName:eBookkeepping inManagedObjectContext:context];
                    [object setValue:[self getUniqueIndex:_bookkeeping] forKey:kIndex];
                }
                [object setValue:self.bookkeepingObject.nameSurname forKey:kNameSurname];
                [object setValue:self.bookkeepingObject.salary forKey:kSalary];
                [object setValue:self.bookkeepingObject.dinnerTime forKey:kDinnerTime];
                [object setValue:self.bookkeepingObject.seatNumber forKey:kSeatNumber];
                [object setValue:self.bookkeepingObject.typeBookkeeping forKey:kTypeBookkeeping];
            }
    }
    //сохраняем контекст и перезагружаем данные и таблицу
    NSError * error=nil;
    NSManagedObjectContext * managedObjectContext=[self managedObjectContext];
    if (managedObjectContext !=nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"error %@ %@", error,[error userInfo]);
        }
    }

    _edit=NO;
    [self loadDataOnListDB];
    [tableViewList reloadData];
}

//получение уникального индекса
//так как каждый новый объект получает индекс больше индекса любого объекта, он помещается в конец секции
-(NSNumber *) getUniqueIndex:(NSMutableArray *) array
{
    int k=0;
    NSMutableArray * arrayIndex=[NSMutableArray array];
    for (int i=0;i<[array count];i++)
    {
        [arrayIndex addObject:[[array objectAtIndex:i]valueForKey:kIndex]];
    }
    NSNumber * maxIndex=[NSNumber numberWithInt:0];
    for (NSNumber * index in arrayIndex)
        if (index<maxIndex)
            maxIndex=index;
    k=[maxIndex intValue];
    k++;
    return [NSNumber numberWithInteger:k];
}

//загрузка данных
-(void) loadDataOnListDB
{
    NSManagedObjectContext * context=[self managedObjectContext];
    NSFetchRequest * request=[[NSFetchRequest alloc] init];
    NSEntityDescription * entityW=[NSEntityDescription entityForName:eWorker inManagedObjectContext:context];
    [request setEntity:entityW];
    //сортируем объекты по индексу
    NSSortDescriptor * sortDescriptor=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
    NSArray *sortDescriptors=@[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    NSFetchedResultsController * aFetchResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchResultsController.delegate=self;
    self.fetchedResultsController=aFetchResultsController;
    
    NSArray * results=[context executeFetchRequest:request error:nil];
    _worker=[[NSMutableArray alloc] initWithArray:results];
    
    NSEntityDescription * entityD=[NSEntityDescription entityForName:eDirection inManagedObjectContext:context];
    [request setEntity:entityD];
    NSSortDescriptor * sortDescriptorD=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
    NSArray *sortDescriptorsD=@[sortDescriptorD];
    [request setSortDescriptors:sortDescriptorsD];
    [sortDescriptorD release];
    
    NSArray * resultsD=[context executeFetchRequest:request error:nil];
    _direction=[[NSMutableArray alloc] initWithArray:resultsD];
    
    NSEntityDescription * entityB=[NSEntityDescription entityForName:eBookkeepping inManagedObjectContext:context];
    [request setEntity:entityB];
    
    NSSortDescriptor * sortDescriptorB=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
    NSArray *sortDescriptorsB=@[sortDescriptorB];
    [request setSortDescriptors:sortDescriptorsB];
    [sortDescriptorB release];
    
    NSArray * resultsB=[context executeFetchRequest:request error:nil];
    _bookkeeping=[[NSMutableArray alloc] initWithArray:resultsB];
    [request release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //получаем информации хранящейся в базе
    [self loadDataOnListDB];

    //добавление элементоав контроллера навигации
    [self.navigationItem setTitle:@"List"];
    UIBarButtonItem * goToDetailView=[[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(goToDetail)];
    [self.navigationItem setRightBarButtonItem:goToDetailView];
    [goToDetailView release];
    
    UIBarButtonItem * backButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [backButton release];
    _edit=NO;

    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    //создание таблицы
    tableViewList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    tableViewList.rowHeight=85;
    tableViewList.sectionFooterHeight=02;
    tableViewList.sectionHeaderHeight=20;
    tableViewList.scrollEnabled=YES;
    tableViewList.showsVerticalScrollIndicator=YES;
    tableViewList.userInteractionEnabled=YES;
    tableViewList.bounces=YES;
    tableViewList.dataSource=self;
    tableViewList.delegate=self;
    [self.view addSubview:tableViewList];
    [tableViewList release];
}

//переключение стиля таблицы и ячеек в редактируемый и не редактируемый
-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (tableViewList.editing){
        tableViewList.editing=NO;
    }else{
        tableViewList.editing=YES;
    }
}

//метод удаления строки из таблицы и записи которая соответствует данной строке в базе
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext * context=[self managedObjectContext];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        _edit=YES;
        if (indexPath.section==0) {
            [context deleteObject:[_direction objectAtIndex:indexPath.row]];
            [_direction removeObjectAtIndex:indexPath.row];
            
        }else
            if (indexPath.section==1){
                [context deleteObject:[_worker objectAtIndex:indexPath.row]];
                [_worker removeObjectAtIndex:indexPath.row];
            }else{
                [context deleteObject:[_bookkeeping objectAtIndex:indexPath.row]];
                [_bookkeeping removeObjectAtIndex:indexPath.row];
            }
    }
    [tableViewList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveContext];
}

//после возращения из окна детализации снимаем выделение ячейки
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableViewList deselectRowAtIndexPath:[tableViewList indexPathForSelectedRow] animated:YES];
}

//возвращает колличество ячеек в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger countStringinsection;
    if (section==0) {
        countStringinsection=[_direction count];
    }else
    if (section==1) {
        countStringinsection=[_worker count];
    }else{
        countStringinsection=[_bookkeeping count];
    }
    return countStringinsection;
}

//возвращает количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//получение время старта из строки
-(NSString *) getTimeFrom:(NSString *) string
{
    range.length=2;
    range.location=0;
    return [string substringWithRange:range];
}

//получение времени финиша из строки
-(NSString *) getTimeTo:(NSString *) string
{
    range.length=2;
    range.location=2;
    return [string substringWithRange:range];
}

//редактируемый стиль ячеек всегда только стиль удаления
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//создание ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellId=@"cellid";

    CLListTableViewCell * cell=[[CLListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [self configureCell:cell atIndexPath:indexPath];
    return [cell autorelease];
    
}

//высота заголовка секции
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

//создание вида секции
-(UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView=[[UIView alloc] init];
    headerView.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    headerView.frame=CGRectMake(0, 0, 320, 50);
    
    UIImageView * imageViewHeader=[[UIImageView alloc] init];
    imageViewHeader.frame=CGRectMake(1, 1, 48, 48);
    
    UILabel * headerTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(62, 0, 200, 50)];
    headerTitleLabel.font=[UIFont systemFontOfSize:24];
    headerTitleLabel.textColor=[UIColor blackColor];
    NSString * imageName;
    if (section==0) {
        imageName=@"direction.png";
        headerTitleLabel.text=@"Direction";
    }else
    if (section==1) {
        imageName=@"worker.png";
        headerTitleLabel.text=@"Worker";
    }else{
        imageName=@"bookkeeping.png";
        imageViewHeader.frame=CGRectMake(0, 0, 50, 50);
        headerTitleLabel.text=@"Bookkeeping";    }
    UIImage * imageHeader=[UIImage imageNamed:imageName];
    imageViewHeader.image=imageHeader;
    [headerView addSubview:imageViewHeader];
    [headerView addSubview:headerTitleLabel];
    [imageViewHeader release];
    [headerTitleLabel release];
    return [headerView autorelease];
    return nil;
}

//переход к контроллеру детализации по кнопке +
-(void) goToDetail
{
    _edit=NO;
    self.workerObject=nil;
    self.bookkeepingObject=nil;
    self.directionObject=nil;
    CLDetailListViewController * detailViewController=[[CLDetailListViewController alloc] init];
    [[self navigationController] pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

//переход к контроллеру детализации с редактирование ячейки
-(void) goToDetailWithObject
{
    _edit=YES;
    CLDetailListViewController * detailViewController=[[CLDetailListViewController alloc] init];
    [[self navigationController] pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

//после нажатия ячейки, передаем данные о ячейке в специальное свойство, для доступа к нему из контроллера детализации
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext * context=[self managedObjectContext];
    NSFetchRequest * request=[[NSFetchRequest alloc] init];
    
    if (indexPath.section==0){
        NSEntityDescription * entityD=[NSEntityDescription entityForName:eDirection inManagedObjectContext:context];
        [request setEntity:entityD];
        NSSortDescriptor * sortDescriptorD=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
        NSArray *sortDescriptorsD=@[sortDescriptorD];
        [request setSortDescriptors:sortDescriptorsD];
        [sortDescriptorD release];
        NSArray * resultsD=[context executeFetchRequest:request error:nil];
        _direction=[[NSMutableArray alloc] initWithArray:resultsD];
        NSManagedObject *object=[_direction objectAtIndex:indexPath.row];
        self.directionObject=[[[CLDirection alloc]init] autorelease];
        self.directionObject.nameSurname=[object valueForKey:kNameSurname];
        self.directionObject.salary=[object valueForKey:kSalary];
        self.directionObject.businessHours=[object valueForKey:kBusinessHours];
        self.directionObject.index=[object valueForKey:kIndex];
    }
    else
        if (indexPath.section==1){
            NSEntityDescription * entityW=[NSEntityDescription entityForName:eWorker inManagedObjectContext:context];
            [request setEntity:entityW];
            NSSortDescriptor * sortDescriptorW=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
            NSArray *sortDescriptorsW=@[sortDescriptorW];
            [request setSortDescriptors:sortDescriptorsW];
            [sortDescriptorW release];
            NSArray * results=[context executeFetchRequest:request error:nil];
            _worker=[[NSMutableArray alloc] initWithArray:results];
            NSManagedObject *object;
            object=[_worker objectAtIndex:indexPath.row];
            self.workerObject=[[[CLWorker alloc]init]autorelease];
            self.workerObject.nameSurname=[object valueForKey:kNameSurname];
            self.workerObject.salary=[object valueForKey:kSalary];
            self.workerObject.dinnerTime=[object valueForKey:kDinnerTime];
            self.workerObject.seatNumber=[object valueForKey:kSeatNumber];
            self.workerObject.index=[object valueForKey:kIndex];
         }else{
             NSEntityDescription * entityB=[NSEntityDescription entityForName:eBookkeepping inManagedObjectContext:context];
             [request setEntity:entityB];
             NSSortDescriptor * sortDescriptorB=[[NSSortDescriptor alloc] initWithKey:kIndex ascending:NO];
             NSArray *sortDescriptorsB=@[sortDescriptorB];
             [request setSortDescriptors:sortDescriptorsB];
             [sortDescriptorB release];
             NSArray * resultsB=[context executeFetchRequest:request error:nil];
             _bookkeeping=[[NSMutableArray alloc] initWithArray:resultsB];
             NSManagedObject *object=[_bookkeeping objectAtIndex:indexPath.row];
             self.bookkeepingObject=[[[CLBookkeeping alloc]init]autorelease];
             self.bookkeepingObject.nameSurname=[object valueForKey:kNameSurname];
             self.bookkeepingObject.salary=[object valueForKey:kSalary];
             self.bookkeepingObject.dinnerTime=[object valueForKey:kDinnerTime];
             self.bookkeepingObject.seatNumber=[object valueForKey:kSeatNumber];
             self.bookkeepingObject.typeBookkeeping=[object valueForKey:kTypeBookkeeping];
             self.bookkeepingObject.index=[object valueForKey:kIndex];
        }
    [request release];
    _edit=YES;
    [self goToDetailWithObject];
}

//заполнение ячейки данными
- (void)configureCell:(CLListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject * object;
    if (indexPath.section==0){
        object=[_direction objectAtIndex:indexPath.row];
        NSString * time=[object valueForKey:kBusinessHours];
        cell.hourLabel.text=[NSString stringWithFormat:@"Часы приема с %@ до %@",[self getTimeFrom:time],[self getTimeTo:time]];
    }else{
        if (indexPath.section==1){
            object=[_worker objectAtIndex:indexPath.row];
            NSString * time=[object valueForKey:kDinnerTime];
            cell.hourLabel.text=[NSString stringWithFormat:@"Обед с %@ до %@",[self getTimeFrom:time],[self getTimeTo:time]];
            cell.numberWorkPlaceLabel.text=[NSString stringWithFormat:@"Номер рабочего места: %@",[object valueForKey:kSeatNumber]];
        }else{
            object=[_bookkeeping objectAtIndex:indexPath.row];
            NSString * time=[object valueForKey:kDinnerTime];
            cell.hourLabel.text=[NSString stringWithFormat:@"Обед с %@ до %@",[self getTimeFrom:time],[self getTimeTo:time]];
            cell.numberWorkPlaceLabel.text=[NSString stringWithFormat:@"Номер рабочего места: %@",[object valueForKey:kSeatNumber]];
            cell.typeBookkeepingLabel.text=[NSString stringWithFormat:@"Тип бухгалтера: %@",[object valueForKey:kTypeBookkeeping]];
        }
    }
    cell.surnameNameLabel.text=[object valueForKey:kNameSurname];
    cell.salaryLabel.text=[NSString stringWithFormat:@"Зарплата: %@",[object valueForKey:kSalary]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
