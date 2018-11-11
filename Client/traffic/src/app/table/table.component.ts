import { Component, ViewChild, Input ,SimpleChanges,SimpleChange,OnChanges} from '@angular/core';
import { MatTableDataSource, MatPaginator, MatDialogConfig, MatDialog } from '@angular/material';
import { VideoModalComponent } from '../video-modal/video-modal.component';
import { AppService } from '../app-component-service';
import { getLocaleDateTimeFormat } from '@angular/common';
import { PeriodicElement } from '../PeriodicElement';

const ELEMENT_DATA: PeriodicElement[] = [];

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})

export class TableComponent {
  constructor(public dialog: MatDialog,private _appservice:AppService) { }
@Input() tabIndex:number;
@Input() data:any;
  displayedColumns: string[] = ['ticketId', 'date', 'address','status','actions'];
  dataSource = new MatTableDataSource<PeriodicElement>(ELEMENT_DATA);
  DATA:PeriodicElement[];
  @ViewChild(MatPaginator) paginator: MatPaginator;

  ngAfterViewInit(){
    if(this.tabIndex==0) console.log("wah wah");
  }
  ngOnInit() {
    var d = new Date();
    d.setDate(d.getDate()-this.data["Date"]);
    var date=d.getDate();
    var month=d.getMonth()+1;
    var year=d.getFullYear();
    var newDate=year+"-"+month+"-"+date;
    //console.log(newDate);
     this._appservice.getPending(this.data["UserId"],newDate,1).subscribe(res=>{this.DATA=res;
     // console.log(this.DATA);
      this.dataSource=new MatTableDataSource<PeriodicElement>(this.DATA);
    });

    
  }
  ApiHitPending(){
    
    var d = new Date();
    d.setDate(d.getDate()-this.data["Date"]);
    var date=d.getDate();
    var month=d.getMonth()+1;
    var year=d.getFullYear();
    var newDate=year+"-"+month+"-"+date;
    this._appservice.getPending(this.data["UserId"],newDate,1).subscribe(res=>{this.DATA=res;
      // console.log(this.DATA);
       this.dataSource=new MatTableDataSource<PeriodicElement>(this.DATA);
     });
  }
  OnClick(row)
  {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    dialogConfig.data = row
   const dialogRef = this.dialog.open(VideoModalComponent, dialogConfig);
   dialogRef.afterClosed().subscribe(result => {
    //console.log("Dialog was closed" )
    //console.log(result);
    this.ApiHitPending();
    });
  }
}
