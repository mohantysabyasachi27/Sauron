import { Component } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MyDialogComponent } from './my-dialog/my-dialog.component';
import {VideoModalComponent} from './video-modal/video-modal.component';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'traffic';
  selected=1;
  constructor(public dialog: MatDialog) { }
  lat: number = 51.678418;
  lng: number = 7.809007;

  openModal() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    dialogConfig.width="60%";
    dialogConfig.height="70%"
    dialogConfig.data = {
    UserId: 1,
    Date: this.selected
    };
   const dialogRef = this.dialog.open(MyDialogComponent, dialogConfig);
   dialogRef.afterClosed().subscribe(result => {
   console.log("Dialog was closed" )
   console.log(result)
   });
  }
}
