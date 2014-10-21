#import "MasterViewController.h"

@interface MasterViewController() <UITableViewDataSource>
@property NSArray *trojans;
@end


@implementation MasterViewController

-(IBAction)onTrojanConquest:(UITextField *)sender
{
    NSManagedObject *trojan = [NSEntityDescription insertNewObjectForEntityForName:@"Trojan" inManagedObjectContext:self.managedObjectContext];
    [trojan setValue:sender.text forKey:@"name"];
    [trojan setValue:@(arc4random_uniform(10)+1) forKey:@"prowess"];
    [self.managedObjectContext save:nil]; 
    [self loadData];

    sender.text = @"";
    [sender resignFirstResponder];
}

-(void)viewDidLoad
{
    [self loadData];
}

-(void)loadData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Trojan"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prowess >= %d", 5];

    request.predicate = predicate;
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    self.trojans = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *trojan = [self.trojans objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [trojan valueForKey:@"name"];
    cell.detailTextLabel.text = [[trojan valueForKey:@"prowess"] stringValue];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trojans.count;
}
@end