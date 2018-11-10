import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-tabs',
  templateUrl: './tabs.component.html',
  styleUrls: ['./tabs.component.css']
})
export class TabsComponent {
  index:number=0;
  @Input() prop1:any;
  test(a){
    this.index=a.index;
  }
}
