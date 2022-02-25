import {Directive, DoCheck, ElementRef, Input, KeyValueChanges, KeyValueDiffer, KeyValueDiffers, Renderer2} from '@angular/core';

@Directive({
  selector: '[ngAttributes]'
})
export class NgAttributesDirective implements DoCheck {
  private _ngAttributes: {[key: string]: string}|null = null;
  private _differ: KeyValueDiffer<string, string|number>|null = null;

  constructor(
      private _ngEl: ElementRef, private _differs: KeyValueDiffers, private _renderer: Renderer2) {}

  @Input('ngAttributes')
  set appNgAttributes(values: {[klass: string]: any}|null) {
    this._ngAttributes = values;
    if (!this._differ && values) {
      this._differ = this._differs.find(values).create();
    }
  }

  ngDoCheck() {
    if (this._differ) {
      const changes = this._differ.diff(this._ngAttributes!);
      if (changes) {
        this._applyChanges(changes);
      }
    }
  }

  private _setAttributes(nameAndUnit: string, value: string|number|null|undefined): void {
    const [name, unit] = nameAndUnit.split('.');
    value = value != null && unit ? `${value}${unit}` : value;

    if (value != null) {
      this._renderer.setAttribute(this._ngEl.nativeElement, name, value as string);
    } else {
      this._renderer.removeAttribute(this._ngEl.nativeElement, name);
    }
  }

  private _applyChanges(changes: KeyValueChanges<string, string|number>): void {
    changes.forEachRemovedItem((record) => this._setAttributes(record.key, null));
    changes.forEachAddedItem((record) => this._setAttributes(record.key, record.currentValue));
    changes.forEachChangedItem((record) => this._setAttributes(record.key, record.currentValue));
  }

}
