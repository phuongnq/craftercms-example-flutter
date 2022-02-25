import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { BaseIceComponent } from '../lib/BaseIceComponent';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent extends BaseIceComponent implements OnInit {
  constructor(router: Router) {
    super(router);
  }
}
