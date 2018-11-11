import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MyDialogComponent } from './my-dialog/my-dialog.component';
import {VideoModalComponent} from './video-modal/video-modal.component';
import { AppService } from './app-component-service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'traffic';
  selected=0;
  constructor(public dialog: MatDialog,private _appService:AppService) { }
  lat: number = 51.678418;
  lng: number = 7.809007;
  locations:any=[{}];
  ngOnInit(){
    this.onChangeofDropdown();
  }
  onChangeofDropdown(){
        var d = new Date();
    d.setDate(d.getDate()-this.selected);
    var date=d.getDate();
    var month=d.getMonth()+1;
    var year=d.getFullYear();
    var newDate=year+"-"+month+"-"+date;
    var data:any;
    this._appService.getPending("admin@asu.edu",newDate,1).subscribe(res=>{
      data=res;
    
    this.lat=data[0]["latitude"];
    this.lng=data[0]["longitude"];
    this.locations=[{}];
    data.forEach(element => {
      var Latitude,Longitude;
      Latitude=element["latitude"];
      Longitude=element["longitude"];
      this.locations.push({Longitude,Latitude});
    });
  });
  }
  openModal() {
    if(this.selected==0){}
    else{
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    dialogConfig.width="60%";
    dialogConfig.height="70%"
    dialogConfig.data = {
    UserId: "admin@asu.edu",
    Date: this.selected,
    TabIndex:1
    };
   const dialogRef = this.dialog.open(MyDialogComponent, dialogConfig);
   dialogRef.afterClosed().subscribe(result => {
   console.log("Dialog was closed" )
   this.onChangeofDropdown();
   });
  }
}
}
