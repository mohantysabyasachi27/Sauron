import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent  {

  email:string;
  password:string;
  constructor(private router: Router) { }
  OnClick(){
    console.log(this.email);
    console.log(this.password);
    this.router.navigate(['/dashboard']);
  }
}
