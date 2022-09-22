/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import _ from 'lodash'
@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('Hello World')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('no args btn').fontSize(30).fontWeight(FontWeight.Bold)
      }
      .onClick((event: ClickEvent) => {
        this.onInit()
      })
    }
    .width('100%')
    .height('100%')
  }

  onInit() {
    //数组[Array]拓展模块
    //创建一个元素数组，该数组被分成大小长度的组。如果数组不能被平均分割，最后的块将是剩余的元素。
    // => [['a', 'b', 'c'], ['d']]
    console.info("chunk:" + _.chunk(['a', 'b', 'c', 'd'], 3));
    //创建一个删除所有错误值的数组。值 false、null、0、""、undefined 和 NaN 是错误的。ne't
    // => [1, 2, 3]
    console.info("compact:" + _.compact([0, 1, false, 2, '', 3]));
    //使用 SameValueZero 创建不包含在其他给定数组中的数组值数组以进行相等比较。结果值的顺序和引用由第一个数组确定。
    // => [1]
    console.info("difference:" + _.difference([2, 1], [2, 3]));
    //创建一个数组切片，其中从开头删除了 n 个元素
    // => [3]
    console.info("drop:" + _.drop([1, 2, 3], 2));
    //用从开始到结束的值填充数组的元素，但不包括结束。
    // => [4, '*', '*', 10]
    console.info("fill:" + _.fill([4, 6, 8, 10], '*', 1, 3));
    //此方法与 _.find 类似，只是它返回第一个元素的索引，谓词返回truthy for 而不是元素本身
    // => 0
    var users = [
      { 'user': 'barney',  'active': false },
      { 'user': 'fred',    'active': false },
      { 'user': 'pebbles', 'active': true }
    ];
    console.info("findIndex:" + _.findIndex(users, function(o) { return o.user == 'barney'; }));
    //将阵列展平单层深度。
    // => [1, 2, [3, [4]], 5]
    console.info("flatten:" + _.flatten([1, [2, [3, [4]], 5]]));
    //_.toPairs 的倒数；此方法返回一个由键值对组成的对象。
    // => { 'a': 1, 'b': 2 }
    //由于循环打印对象键值对不在本功能测试范畴，以下出现打印有object的可以自己编写循环打印代码验证，本人就不再赘述了
    var obj = _.fromPairs([['a', 1], ['b', 2]]);
    for(let key in obj) {
      console.info("fromPairs:" + key + ":" + obj[key]);
    }
    //获取数组的第一个元素
    // => 1
    console.info("head:" + _.head([1, 2, 3]));
    //获取使用 SameValueZero 进行相等比较的数组中第一次出现值的索引。如果 fromIndex 为负数，则用作距数组末尾的偏移量。
    // => 1
    console.info("indexOf:" + _.indexOf([1, 2, 1, 2], 2));
    //获取除数组的最后一个元素之外的所有元素。
    // => [1, 2]
    console.info("initial:" + _.initial([1, 2, 3]));
    //创建一个包含在所有给定数组中的唯一值数组，使用 SameValueZero 进行相等比较。结果值的顺序和引用由第一个数组确定。
    // => [2]
    console.info("intersection:" + _.intersection([2, 1], [2, 3]));
    //将数组中的所有元素转换为由分隔符分隔的字符串。
    // => 'a~b~c'
    console.info("join:" + _.join(['a', 'b', 'c'], '~'));
    //获取数组的最后一个元素。
    // => 3
    console.info("last:" + _.last([1, 2, 3]));
    //获取数组索引 n 处的元素。如果 n 为负数，则返回倒数第 n 个元素
    // => 'c';
    console.info("nth:" + _.nth(['a', 'b', 'c', 'd'], -2));
    //使用 SameValueZero 从数组中删除所有给定值以进行相等比较。
    // => ['b', 'b']
    console.info("pull:" + _.pull(['a', 'b', 'c', 'a', 'b', 'c'], 'a', 'c'));
    //从数组中删除所有谓词返回真值的元素，并返回已删除元素的数组。
    // => [2, 4]
    console.info("remove:" + _.remove([1, 2, 3, 4], function(n) {
      return n % 2 == 0;
    }));
    //反转数组，使第一个元素成为最后一个元素，第二个元素成为倒数第二个元素，依此类推。
    // => [3, 2, 1]
    console.info("reverse:" + _.reverse([1, 2, 3]));
    //使用二分搜索来确定应将值插入数组以保持其排序顺序的最低索引。
    // => 1
    console.info("sortedIndex:" + _.sortedIndex([30, 50], 40));
    //获取除数组的第一个元素之外的所有元素。
    // => [2, 3]
    console.info("tail:" + _.tail([1, 2, 3]));
    //创建一个数组切片，其中 n 个元素从头开始。
    // => [1, 2]
    console.info("take:" + _.take([1, 2, 3], 2));
    //使用 SameValueZero 从所有给定数组中按顺序创建唯一值数组以进行相等比较。
    // => [2, 1]
    console.info("union:" + _.union([2], [1, 2]));
    //创建数组的无重复版本，使用 SameValueZero 进行相等比较，其中仅保留每个元素的第一次出现。结果值的顺序由它们在数组中出现的顺序决定。
    // => [2, 1]
    console.info("uniq:" + _.uniq([2, 1, 2]));
    //此方法与 _.zip 类似，不同之处在于它接受一个分组元素数组并创建一个数组，将元素重新组合到它们的压缩前配置。
    // => [['a', 'b'], [1, 2], [true, false]]
    console.info("unzip:" + _.unzip([['a', 1, true], ['b', 2, false]]));
    //使用 SameValueZero 创建一个排除所有给定值的数组以进行相等比较。
    // => [3]
    console.info("without:" + _.without([2, 1, 2, 3], 1, 2));
    //创建一个唯一值数组，该数组是给定数组的对称差值。结果值的顺序由它们在数组中出现的顺序决定。
    // => [1, 3]
    console.info("xor:" + _.xor([2, 1], [2, 3]));
    //创建一个分组元素数组，其中第一个包含给定数组的第一个元素，第二个包含给定数组的第二个元素，依此类推。
    // => [['a', 1, true], ['b', 2, false]]
    console.info("zip:" + _.zip(['a', 'b'], [1, 2], [true, false]));

    //集合[Collection]拓展模块
    //创建一个由通过 iteratee 运行集合的每个元素的结果生成的键组成的对象。每个key对应的值就是iteratee返回key的次数。使用一个参数调用迭代对象：（值）。
    // => { '4': 1, '6': 2 }
    console.info("countBy:" + _.countBy([6.1, 4.2, 6.3], Math.floor));
    //检查谓词是否为集合的所有元素返回真值。一旦谓词返回错误，迭代就会停止。谓词使用三个参数调用：（值、索引|键、集合）。
    // => false
    console.info("every:" + _.every([true, 1, null, 'yes'], Boolean));
    //遍历集合的元素，返回一个包含所有元素的数组，谓词返回真值。谓词使用三个参数调用：（值、索引|键、集合）。
    // => objects for ['fred']
    var users1 = [
      { 'user': 'barney', 'age': 36, 'active': true },
      { 'user': 'fred',   'age': 40, 'active': false }
    ];
    console.info("filter:" + _.filter(users1, function(o) { return !o.active; }));
    //迭代集合的元素，返回第一个元素谓词返回truthy for。谓词使用三个参数调用：（值、索引|键、集合）。
    // => object for 'barney'
    var users2 = [
      { 'user': 'barney',  'age': 36, 'active': true },
      { 'user': 'fred',    'age': 40, 'active': false },
      { 'user': 'pebbles', 'age': 1,  'active': true }
    ];
    console.info("find:" + _.find(users2, function(o) { return o.age < 40; }));
    //通过通过 iteratee 运行集合中的每个元素并展平映射的结果来创建展平的值数组。使用三个参数调用迭代对象：（值、索引|键、集合）。
    // => [1, 1, 2, 2]
    function duplicate(n) {
      return [n, n];
    }
    console.info("flatMap:" + _.flatMap([1, 2], duplicate));
    //迭代集合的元素并为每个元素调用 iteratee。使用三个参数调用迭代对象：（值、索引|键、集合）。 Iteratee 函数可以通过显式返回 false 提前退出迭代。
    // => Logs `1` then `2`.
    _.forEach([1, 2], function(value) {
      console.info("forEach:" + value);
    });
    //创建一个由通过 iteratee 运行集合的每个元素的结果生成的键组成的对象。分组值的顺序由它们在集合中出现的顺序决定。每个键对应的值是负责生成键的元素数组。使用一个参数调用迭代对象：（值）。
    // => { '4': [4.2], '6': [6.1, 6.3] }
    console.info("groupBy:" + _.groupBy([6.1, 4.2, 6.3], Math.floor));
    //检查值是否在集合中。如果 collection 是一个字符串，则检查它的值的子字符串，否则 SameValueZero 用于相等比较。如果 fromIndex 为负数，则将其用作与集合末尾的偏移量。
    // => true
    console.info("includes:" + _.includes([1, 2, 3], 1));
    //在集合中每个元素的路径调用方法，返回每个调用方法的结果数组。为每个调用的方法提供任何附加参数。如果 path 是一个函数，它会被调用，并且 this 绑定到集合中的每个元素。
    // => [[1, 5, 7], [1, 2, 3]]
    console.info("invokeMap:" + _.invokeMap([[5, 1, 7], [3, 2, 1]], 'sort'));
    //创建一个由通过 iteratee 运行集合的每个元素的结果生成的键组成的对象。每个键对应的值是负责生成键的最后一个元素。使用一个参数调用迭代对象：（值）。
    // => { 'a': { 'dir': 'left', 'code': 97 }, 'd': { 'dir': 'right', 'code': 100 } }
    var array1 = [
      { 'dir': 'left', 'code': 97 },
      { 'dir': 'right', 'code': 100 }
    ];
    console.info("keyBy:" + _.keyBy(array1, function(o) {
      return String.fromCharCode(o.code);
    }));
    //通过 iteratee 运行集合中的每个元素来创建一个值数组。使用三个参数调用 iteratee：（值，索引|键，集合）。
    // => [16, 64]
    function square(n) {
      return n * n;
    }
    console.info("map:" + _.map([4, 8], square));
    //此方法类似于 _.sortBy ，不同之处在于它允许指定要排序的迭代对象的排序顺序。如果未指定 orders，则所有值都按升序排序。否则，为相应值的降序指定“desc”或“asc”为升序排序。
    // => objects for [['barney', 36], ['barney', 34], ['fred', 48], ['fred', 40]]
    var users3 = [
      { 'user': 'fred',   'age': 48 },
      { 'user': 'barney', 'age': 34 },
      { 'user': 'fred',   'age': 40 },
      { 'user': 'barney', 'age': 36 }
    ];
    console.info("orderBy:" + _.orderBy(users3, ['user', 'age'], ['asc', 'desc']));
    //创建一个元素数组，分成两组，第一组包含元素谓词返回真值，第二组包含元素谓词返回假值。谓词使用一个参数调用：（值）。
    // => objects for [['fred'], ['barney', 'pebbles']]
    var users4 = [
      { 'user': 'barney',  'age': 36, 'active': false },
      { 'user': 'fred',    'age': 40, 'active': true },
      { 'user': 'pebbles', 'age': 1,  'active': false }
    ];
    console.info("partition:" + _.partition(users4, function(o) { return o.active; }));
    //将集合减少到一个值，该值是通过 iteratee 运行集合中每个元素的累积结果，其中每个连续调用都提供前一个的返回值。如果没有给出累加器，则将集合的第一个元素用作初始值。使用四个参数调用 iteratee：（累加器、值、索引|键、集合）。
    // => 3
    console.info("reduce:" + _.reduce([1, 2], function(sum, n) {
      return sum + n;
    }, 0));
    //_.filter 的反义词；此方法返回谓词不返回真值的集合元素。
    // => objects for ['fred']
    var users5 = [
      { 'user': 'barney', 'age': 36, 'active': false },
      { 'user': 'fred',   'age': 40, 'active': true }
    ];
    console.info("reject:" + _.reject(users5, function(o) { return !o.active; }));
    //从集合中获取随机元素。
    // => 2
    console.info("sample:" + _.sample([1, 2, 3, 4]));
    //使用 Fisher-Yates shuffle 的一个版本创建一个混洗值数组。
    // => [4, 1, 3, 2]
    console.info("shuffle:" + _.shuffle([1, 2, 3, 4]));
    //通过返回类数组值的长度或对象自己的可枚举字符串键控属性的数量来获取集合的大小。
    // => 3
    console.info("size:" + _.size([1, 2, 3]));
    //检查谓词是否为集合的任何元素返回真值。一旦谓词返回真值，迭代就会停止。谓词使用三个参数调用：（值、索引|键、集合）。
    // => true
    console.info("some:" + _.some([null, 0, 'yes', false], Boolean));
    //创建一个元素数组，按通过每个迭代器运行集合中的每个元素的结果按升序排序。此方法执行稳定排序，即保留相等元素的原始排序顺序。使用一个参数调用迭代器：（值）。
    // => objects for [['barney', 36], ['barney', 34], ['fred', 48], ['fred', 40]]
    var users6 = [
      { 'user': 'fred',   'age': 48 },
      { 'user': 'barney', 'age': 36 },
      { 'user': 'fred',   'age': 40 },
      { 'user': 'barney', 'age': 34 }
    ];
    console.info("sortBy:" + _.sortBy(users6, [function(o) { return o.user; }]));

    //数学[Math]拓展模块
    //两个数字相加
    // => 10
    console.info("add:" + _.add(6, 4));
    //计算不小于当前数字的最小数字。
    // => 5
    console.info("ceil:" + _.ceil(4.006));
    //将两个数字相除。
    // => 1.5
    console.info("divide:" + _.divide(6, 4));
    //计算不大于当前数字的最大数字。
    // => 4
    console.info("floor:" + _.floor(4.006));
    //计算数组的最大值。如果数组为空或为假，则返回 undefined。
    // => 8
    console.info("max:" + _.max([4, 2, 8, 6]));
    //计算数组中值的平均值。
    // => 5
    console.info("mean:" + _.mean([4, 2, 8, 6]));
    //计算数组的最小值。如果数组为空或为假，则返回 undefined。
    // => 2
    console.info("min:" + _.min([4, 2, 8, 6]));
    //将两个数字相乘。
    // => 24
    console.info("multiply:" + _.multiply(6, 4));
    //计算四舍五入到精度的数字
    // => 4
    console.info("round:" + _.round(4.006));
    //两个数字相减。
    // => 2
    console.info("subtract:" + _.subtract(6, 4));
    //计算数组中值的总和。
    // => 20
    console.info("sum:" + _.sum([4, 2, 8, 6]));

    //字符串[String]拓展模块
    //将字符串转换为驼峰式大小写。
    // => 'fooBar'
    console.info("camelCase:" + _.camelCase('Foo Bar'));
    //将字符串的第一个字符转换为大写，将其余字符转换为小写。
    // => 'Fred'
    console.info("capitalize:" + _.capitalize('FRED'));
    //通过将 Latin-1 Supplement 和 Latin Extended-A 字母转换为基本拉丁字母并删除组合变音符号来去除字符串毛刺。
    // => 'deja vu'
    console.info("deburr:" + _.deburr('déjà vu'));
    //检查字符串是否以给定的目标字符串结尾。
    // => true
    console.info("endsWith:" + _.endsWith('abc', 'c'));
    //将字符串中的字符 "&"、"<"、">"、'"' 和 "'" 转换为其对应的 HTML 实体。
    // => 'fred, barney, &amp; pebbles'
    console.info("escape:" + _.escape('fred, barney, & pebbles'));
    //将字符串转换为 kebab 大小写。
    // => 'foo-bar'
    console.info("kebabCase:" + _.kebabCase('Foo Bar'));
    //将字符串（作为空格分隔的单词）转换为小写。
    // => 'foo bar'
    console.info("lowerCase:" + _.lowerCase('--Foo-Bar--'));
    //如果长度短于长度，则在左侧和右侧填充字符串。如果填充字符不能按长度均匀划分，则填充字符将被截断。
    // => '  abc   '
    console.info("pad:" + _.pad('abc', 8));
    //将字符串转换为指定基数的整数。如果 radix 未定义或为 0，则使用 10 的基数，除非 value 是十六进制，在这种情况下使用 16 的基数。
    // => 8
    console.info("parseInt:" + _.parseInt('08'));
    //重复给定的字符串 n 次。
    // => '***'
    console.info("repeat:" + _.repeat('*', 3));
    //用替换替换字符串中模式的匹配项。
    // => 'Hi Barney'
    console.info("replace:" + _.replace('Hi Fred', 'Fred', 'Barney'));
    //将字符串转换为蛇形大小写。
    // => 'foo_bar'
    console.info("snakeCase:" + _.snakeCase('Foo Bar'));
    //按分隔符拆分字符串。
    // => ['a', 'b']
    console.info("split:" + _.split('a-b-c', '-', 2));
    //将字符串转换为起始大小写。
    // => 'Foo Bar'
    console.info("startCase:" + _.startCase('--foo-bar--'));
    //将字符串作为一个整体转换为小写，就像 String#toLowerCase 一样。
    // => '--foo-bar--'
    console.info("toLower:" + _.toLower('--Foo-Bar--'));
    //将字符串作为一个整体转换为大写，就像 String#toUpperCase 一样。
    // => '--FOO-BAR--'
    console.info("toUpper:" + _.toUpper('--foo-bar--'));
    //从字符串中删除前导和尾随空格或指定字符。
    // => 'abc'
    console.info("trim:" + _.trim('  abc  '));
    //如果字符串长于给定的最大字符串长度，则截断字符串。被截断的字符串的最后一个字符被替换为默认为“...”的省略字符串。
    // => 'hi-diddly-ho there, neighbo...'
    console.info("truncate:" + _.truncate('hi-diddly-ho there, neighborino'));
    //_.escape 的逆；此方法转换 HTML 实体 &amp;、&lt;、&gt;、&quot; 和 &#39;在字符串中为其对应的字符。
    // => 'fred, barney, & pebbles'
    console.info("unescape:" + _.unescape('fred, barney, &amp; pebbles'));
    //将字符串（作为空格分隔的单词）转换为大写。
    // => 'FOO BAR'
    console.info("upperCase:" + _.upperCase('--foo-bar'));
    //将字符串拆分为其单词的数组。
    // => ['fred', 'barney', 'pebbles']
    console.info("words:" + _.words('fred, barney, & pebbles'));

    //工具类[Util]拓展模块
    //检查 value 以确定是否应在其位置返回默认值。如果 value 为 NaN、null 或 undefined，则返回 defaultValue。
    // => 1
    console.info("defaultTo:" + _.defaultTo(1, 10));
    //创建一个函数，该函数使用它接收的参数调用迭代器并返回它们的结果。
    // => [4, 1]
    var func = _.over([Math.max, Math.min]);
    console.info("over:" + func(1, 2, 3, 4));
    //创建一个数字数组（正数和/或负数），从开始到结束，但不包括结束。如果指定负开始而没有结束或步骤，则使用 -1 的步骤。如果未指定 end，则设置为从 start 开始，然后设置为 0。
    // => [0, 1, 2, 3]
    console.info("range:" + _.range(4));
    //调用迭代 n 次，返回每个调用结果的数组。 iteratee 用一个参数调用； （指数）。
    // => ['0', '1', '2']
    console.info("times:" + _.times(3, String));
    //将值转换为属性路径数组。
    // => ['a', 'b', 'c']
    console.info("toPath:" + _.toPath('a.b.c'));
    //生成唯一 ID。如果给出了前缀，则将 ID 附加到它上面。
    // => 'contact_1'
    console.info("uniqueId:" + _.uniqueId('contact_'));
    // => '2'
    console.info("uniqueId:" + _.uniqueId());
  }
}