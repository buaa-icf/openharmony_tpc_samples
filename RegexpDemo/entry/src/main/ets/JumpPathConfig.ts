class JumpBean {
    showText: string = '';
    jumpPath: string = '';

    constructor(text, path) {
        this.showText = text;
        this.jumpPath = path;
    }
}

export default class JumpPathConfig {
    public  static dataList: Array<JumpBean> ;

    private static initData() {
        if (!this.dataList) {
            this.dataList = new Array<JumpBean>();
        }
        if (this.dataList.length < 1) {
            let bean0 = new JumpBean('跳转PathToRegexpPage', 'pages/PathToRegexpPage');
            this.dataList.push(bean0)

            let bean1 = new JumpBean('跳转NamedParamtersPage', 'pages/NamedParamtersPage');
            this.dataList.push(bean1)

            let bean2 = new JumpBean('跳转CustomMatchingParamtersPage', 'pages/CustomMatchingParamtersPage');
            this.dataList.push(bean2)

            let bean3 = new JumpBean('跳转CustomPrefixSuffixPage', 'pages/CustomPrefixSuffixPage');
            this.dataList.push(bean3)

            let bean4 = new JumpBean('跳转UnnamedParametersPage', 'pages/UnnamedParametersPage');
            this.dataList.push(bean4)

            let bean5 = new JumpBean('跳转ModifiersPage', 'pages/ModifiersPage');
            this.dataList.push(bean5)

            let bean6 = new JumpBean('跳转OptionalPage', 'pages/OptionalPage');
            this.dataList.push(bean6)

            let bean7 = new JumpBean('跳转ZeroPage', 'pages/ZeroPage');
            this.dataList.push(bean7)

            let bean8 = new JumpBean('跳转OnePage', 'pages/OnePage');
            this.dataList.push(bean8)

            let bean9 = new JumpBean('跳转MatchPage', 'pages/MatchPage');
            this.dataList.push(bean9)

            let bean10 = new JumpBean('跳转ProcessPathnamePage', 'pages/ProcessPathnamePage');
            this.dataList.push(bean10)

            let bean11 = new JumpBean('跳转ParsePage', 'pages/ParsePage');
            this.dataList.push(bean11)

            let bean12 = new JumpBean('跳转CompilePage', 'pages/CompilePage');
            this.dataList.push(bean12)

            let bean13 = new JumpBean('跳转WorkingTokensPage', 'pages/WorkingTokensPage');
            this.dataList.push(bean13)
        }
    }

    public static getText(): string[] {
        this.initData();
        let tempArr: string[] = new Array<string>(this.dataList.length);
        for (let index = 0; index < this.dataList.length; index++) {
            tempArr[index] = this.dataList[index].showText;
        }
        return tempArr;
    }

    public static getIndex(): number[] {
        this.initData();
        let tempArr: number[] = new Array<number>(this.dataList.length);
        for (let index = 0; index < this.dataList.length; index++) {
            tempArr[index] = index;
        }
        return tempArr;
    }


    public static getJumpPath(position: number): string {
        if (position < 0) {
            return 'pages/Index';
        }
        this.initData();
        if (position >= this.dataList.length) {
            return 'pages/Index';
        }
        return this.dataList[position].jumpPath;
    }
}

