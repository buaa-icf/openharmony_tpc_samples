import * as index from 'rxjs/ajax';
import { describe, expect } from '../../hypium';
import { it } from '../../It'

export default function ajaxTest() {
  describe('index', () => {
    it('should export static ajax observable creator functions', () => {
      expect(index.ajax != undefined && index.ajax != null).assertTrue();
    });

    it('should export Ajax data classes', () => {
      expect(index.AjaxError != undefined && index.AjaxError != null).assertTrue();
      expect(index.AjaxTimeoutError != undefined && index.AjaxTimeoutError != null).assertTrue();
      // Interfaces can be checked by creating a variable of that type
      let ajaxRequest: index.AjaxRequest;
      let ajaxResponse: index.AjaxResponse<object>;
    });
  });
}
