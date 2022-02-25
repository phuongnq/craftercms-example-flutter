import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { BaseIceComponent } from '../lib/BaseIceComponent';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.css']
})
export class AboutComponent extends BaseIceComponent implements OnInit {
  constructor(router: Router) {
    super(router);
  }
}
