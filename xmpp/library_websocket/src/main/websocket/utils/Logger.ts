
import hilog from '@ohos.hilog'

const debug: boolean = true;

export class Logger {
    private  static domain: number = 0x0001;
    private static tag: string = 'smack---';
    private static FORMAT: string = `%{public}s`;

    /**
     * set tag to distinguish log
     *
     * @param {string} log - Log needs to be printed
     */
    public  static setTag(tagStr: string) {
        if (tagStr) {
            this.tag = tagStr;
        }
    }

    /**
     * set domain to distinguish log
     *
     * @param {string} log - Log needs to be printed
     */
    public  static setDomain(domain: number) {
        this.domain = domain;
    }

    /**
     * print info level log
     *
     * @param {string} log - Log needs to be printed
     */
    public static info(...args: any) {
        if (debug) {
            hilog.info(this.domain, this.tag, this.FORMAT, args.join(` `));
        }
    }

    /**
     * print debug level log
     *
     * @param {string} log - Log needs to be printed
     */
    public static debug(...args) {
        if (debug) {
            hilog.debug(this.domain, this.tag, this.FORMAT, args.join(` `));
        }
    }

    /**
     * print error level log
     *
     * @param {string} log - Log needs to be printed
     */
    public static error(...args) {
        if (debug) {
            hilog.error(this.domain, this.tag, this.FORMAT, args.join(` `));
        }
    }

    /**
     * print warn level log
     *
     * @param {string} log - Log needs to be printed
     */
    public static warn(...args) {
        if (debug) {
            hilog.warn(this.domain, this.tag, this.FORMAT, args.join(` `));
        }
    }

    /**
     * print fatal level log
     *
     * @param {string} log - Log needs to be printed
     */
    public static fatal(...args) {
        if (debug) {
            hilog.fatal(this.domain, this.tag, this.FORMAT, args.join(` `));
        }
    }
}
