import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MyDialogComponent } from './my-dialog/my-dialog.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatDialogModule, MatButtonModule, MatTableModule, MatPaginatorModule, MatTabsModule, MatSelectModule, MatInputModule } from '@angular/material';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AgmCoreModule } from '@agm/core';
import { TableComponent } from './table/table.component';
import { TabsComponent } from './tabs/tabs.component';
import { MatVideoModule } from 'mat-video';
import { VideoModalComponent } from './video-modal/video-modal.component';
import {HistoryComponent}from './history/table.component';
import { AgmJsMarkerClustererModule } from '@agm/js-marker-clusterer';
import { HttpClientModule } from '@angular/common/http';
import {AppService} from './app-component-service';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';


@NgModule({
  declarations: [
    AppComponent,
    MyDialogComponent,
    TableComponent,
    TabsComponent,
    VideoModalComponent,
    HistoryComponent,
    HomeComponent,
    LoginComponent,
    
    
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatDialogModule,MatButtonModule,
    CommonModule,
    FormsModule,
    MatTableModule,
    MatTabsModule,
    MatPaginatorModule,
    HttpClientModule,
    MatSelectModule,
    MatVideoModule,
    MatInputModule,
    AgmJsMarkerClustererModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyCmyAyyRef26cnaJjNWGxV7u7uDdEL8q6M'
    })
  ],
  providers: [AppService],
  bootstrap: [HomeComponent],
  entryComponents: [
    MyDialogComponent,VideoModalComponent
   ]
})
export class AppModule { }
