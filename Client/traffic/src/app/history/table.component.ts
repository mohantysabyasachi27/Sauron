import { Component, ViewChild, Input ,SimpleChanges,SimpleChange,OnChanges} from '@angular/core';
import { MatTableDataSource, MatPaginator, MatDialogConfig, MatDialog } from '@angular/material';


export interface PeriodicElement {
  Date: string;
  UserId: number;
  Title: number;
  Address: string;
  Status:string;
  Category:string;
  Comment:string;
}
const ELEMENT_DATA: PeriodicElement[] = [
  {UserId: 1, Date: 'Hydrogen', Title: 1.0079, Address: 'H',Status:'Pending',Category:'ABC',Comment:'Heyhbsrhbsrhv hs ev'},
  {UserId: 2, Date: 'Helium', Title: 4.0026, Address: 'He',Status:'Pending',Category:'BCD',Comment:'hbsrhbshvbHS V'},
];

@Component({
  selector: 'app-history',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})

export class HistoryComponent {
  constructor() { }
@Input() tabIndex:number;

  displayedColumns: string[] = ['UserId', 'Date', 'Title', 'Address','Status','Category','Comment'];
  dataSource = new MatTableDataSource<PeriodicElement>(ELEMENT_DATA);

  @ViewChild(MatPaginator) paginator: MatPaginator;

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
  }
  
}
