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
    if(this.email=="admin" && this.password=="admin"){
    this.router.navigate(['/dashboard']);
    }else
    alert("Wrong combination :please enter again");
  }
}
