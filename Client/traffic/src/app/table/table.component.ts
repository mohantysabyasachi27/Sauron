import { Component, ViewChild, Input ,SimpleChanges,SimpleChange,OnChanges} from '@angular/core';
import { MatTableDataSource, MatPaginator, MatDialogConfig, MatDialog } from '@angular/material';
import { VideoModalComponent } from '../video-modal/video-modal.component';

export interface PeriodicElement {
  Date: string;
  UserId: number;
  Title: number;
  Address: string;
  Status:string;
}
const ELEMENT_DATA: PeriodicElement[] = [
  {UserId: 1, Date: 'Hydrogen', Title: 1.0079, Address: 'H',Status:'Pending'},
  {UserId: 2, Date: 'Helium', Title: 4.0026, Address: 'He',Status:'Pending'},
  {UserId: 3, Date: 'Lithium', Title: 6.941, Address: 'Li',Status:'Pending'},
  {UserId: 4, Date: 'Beryllium', Title: 9.0122, Address: 'Be',Status:'Pending'},
  {UserId: 5, Date: 'Boron', Title: 10.811, Address: 'B',Status:'Pending'},
  {UserId: 6, Date: 'Carbon', Title: 12.0107, Address: 'C',Status:'Pending'},
  {UserId: 7, Date: 'Nitrogen', Title: 14.0067, Address: 'N',Status:'Pending'},
  {UserId: 8, Date: 'Oxygen', Title: 15.9994, Address: 'O',Status:'Pending'},
  {UserId: 9, Date: 'Fluorine', Title: 18.9984, Address: 'F',Status:'Pending'},
  {UserId: 10, Date: 'Neon', Title: 20.1797, Address: 'Ne',Status:'Pending'},
];

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})

export class TableComponent {
  constructor(public dialog: MatDialog) { }
@Input() tabIndex:number;
@Input() data:any;
  displayedColumns: string[] = ['UserId', 'Date', 'Title', 'Address','Status','actions'];
  dataSource = new MatTableDataSource<PeriodicElement>(ELEMENT_DATA);

  @ViewChild(MatPaginator) paginator: MatPaginator;

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
  }
  OnClick(row)
  {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    dialogConfig.data = {
    UserId: row["UserId"],
    Date: row["Date"],
    Title:row["Title"],
    Address:row["Address"],
    Status:row["Status"]
    };
   const dialogRef = this.dialog.open(VideoModalComponent, dialogConfig);
    console.log(row);
  }
}
