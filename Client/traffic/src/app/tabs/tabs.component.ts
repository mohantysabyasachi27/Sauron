import { Component, OnInit, Input, ViewChild } from '@angular/core';
import { MatTabChangeEvent } from '@angular/material';
import { HistoryComponent } from '../history/table.component';
import { TableComponent } from '../table/table.component';

@Component({
  selector: 'app-tabs',
  templateUrl: './tabs.component.html',
  styleUrls: ['./tabs.component.css']
})
export class TabsComponent {
  index:number=0;
  @Input() prop1:any;
  @ViewChild(HistoryComponent) history:HistoryComponent;
  @ViewChild(TableComponent) table:TableComponent;
  onClick(event:MatTabChangeEvent){
    this.index=event.index;
    if(this.index==0)
    {
      this.table.ApiHitPending();
    }
    else this.history.ApiHitHistory();
  }
}
