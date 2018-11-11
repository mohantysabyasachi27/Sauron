import { Component, ViewChild, Input ,SimpleChanges,SimpleChange,OnChanges} from '@angular/core';
import { MatTableDataSource, MatPaginator, MatDialogConfig, MatDialog } from '@angular/material';
import { AppService } from '../app-component-service';
import { PeriodicElement } from '../PeriodicElement';


const ELEMENT_DATA: PeriodicElement[] = [
];

@Component({
  selector: 'app-history',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})

export class HistoryComponent {
  constructor(private _appservice:AppService) { }
  @Input() tabIndex:number;
  @Input() data:any;
  displayedColumns: string[] = ['ticketId', 'date', 'address','status','category','details'];
  dataSource = new MatTableDataSource<PeriodicElement>(ELEMENT_DATA);
  DATA:PeriodicElement[];
  @ViewChild(MatPaginator) paginator: MatPaginator;

  ngOnInit() {
    var d = new Date();
    d.setDate(d.getDate()-this.data["Date"]);
    var date=d.getDate();
    var month=d.getMonth()+1;
    var year=d.getFullYear();
    var newDate=year+"-"+month+"-"+date
  }
  ApiHitHistory(){
    var d = new Date();
    d.setDate(d.getDate()-this.data["Date"]);
    var date=d.getDate();
    var month=d.getMonth()+1;
    var year=d.getFullYear();
    var newDate=year+"-"+month+"-"+date;
    this._appservice.getPending(this.data["UserId"],newDate,2).subscribe(res=>{this.DATA=res;
      // console.log(this.DATA);
       this.dataSource=new MatTableDataSource<PeriodicElement>(this.DATA);
     });
  }
  
}
