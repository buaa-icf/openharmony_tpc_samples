export default class CommonResultBean {
    beforeStr: Array<string> = new Array<string>();
    afterStr: Array<string> = new Array<string>();

    constructor() {
        if (!this.beforeStr) {
            this.beforeStr = new Array<string>();
        }
        if (!this.afterStr) {
            this.afterStr = new Array<string>();
        }
    }

    public setBefore(arr: Array<string>) {
        if (!arr) {
            return;
        }
        this.beforeStr = arr;
    }

    public setAfter(arr: Array<string>) {
        if (!arr) {
            return;
        }
        this.afterStr = arr;
    }
}