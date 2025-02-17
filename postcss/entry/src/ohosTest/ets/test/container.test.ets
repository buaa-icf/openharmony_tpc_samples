/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { describe, it, expect } from '@ohos/hypium'
import { postcss, Rule } from '@ohos/postcss'

export default function containerTest() {
  describe('containerTest', () => {
    let example =
      'a { a: 1; b: 2 }' +
        '/* a */' +
        '@keyframes anim {' +
        '/* b */' +
        'to { c: 3 }' +
        '}' +
        '@media all and (min-width: 100) {' +
        'em { d: 4 }' +
        '@page {' +
        'e: 5;' +
        '/* c */' +
        '}' +
        '}'
    it('test01', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.push(new postcss.Declaration({
        prop: 'c', value: '3'
      }))
      expect(rule.toString()).assertDeepEquals('a { a: 1; b: 2; c: 3 }')
      expect(rule.nodes.length).assertDeepEquals(3)
      expect(rule.last?.raws.before).assertUndefined()
    })
    it('test02', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let indexes: number[] = []

      let result = rule.each((decl, i) => {
        indexes.push(i)
        expect(decl).assertDeepEquals(rule.nodes[i]);
      })
      expect(result).assertUndefined()
      expect(indexes.toString()).assertEqual('0,1');
      expect(rule.toString()).assertEqual('a { a: 1; b: 2 }');
    })
    it('test03', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each(() => {
        rule.prepend({
          prop: 'color', value: 'aqua'
        })
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test04', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each(decl => {
        if (decl.type === 'decl' && decl.prop === 'a') {
          rule.insertBefore(decl, {
            prop: 'c', value: '3'
          })
        }
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test05', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each((decl, i) => {
        if (decl.type === 'decl' && decl.prop === 'a') {
          rule.insertBefore(i + 1, {
            prop: 'c', value: '3'
          })
        }
        size += 1
      })
      expect(size).assertDeepEquals(3)
    })
    it('test06', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each((decl, i) => {
        rule.insertAfter(i - 1, {
          prop: 'c', value: '3'
        })
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test07', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each((decl, i) => {
        if (decl.type === 'decl' && decl.prop === 'a') {
          rule.insertAfter(i, {
            prop: 'c', value: '3'
          })
        }
        size += 1
      })
      expect(size).assertDeepEquals(3)
    })
    it('test08', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let size = 0

      rule.each(() => {
        rule.removeChild(0)
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test09', 0, () => {
      let indexes: number[] = []
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let result = rule.each((decl, i) => {
        indexes.push(i)
        return false
      });
      expect(indexes).assertDeepEquals([0])
      expect(result).assertDeepEquals(false)
    })
    it('test10', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      let props: string[] = []
      rule.each(decl => {
        if (decl.type === 'decl') {
          props.push(decl.prop)
          rule.nodes = [rule.last as postcss.Rule, rule.first as postcss.Rule]
        }
      })

      expect(props.toString()).assertEqual('a,a')
    })
    it('test11', 0, () => {
      let types: string[] = []
      let indexes: number[] = []

      let result = postcss.parse(example).walk((node, i) => {
        types.push(node.type)
        indexes.push(i)
      })

      expect(result).assertUndefined()
      expect(types).assertDeepEquals([
        'rule',
        'decl',
        'decl',
        'comment',
        'atrule',
        'comment',
        'rule',
        'decl',
        'atrule',
        'rule',
        'decl',
        'atrule',
        'decl',
        'comment'
      ])
      expect(indexes).assertDeepEquals([0, 0, 1, 1, 2, 0, 1, 0, 3, 0, 0, 1, 0, 1])
    })
    it('test12', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walk((decl, i) => {
        indexes.push(i)
        return false
      })

      expect(result).assertDeepEquals(false)
      expect(indexes).assertDeepEquals([0])
    })
    it('test13', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walkDecls((decl, i) => {
        indexes.push(i)
        return false
      })

      expect(result).assertDeepEquals(false)
      expect(indexes).assertDeepEquals([0])
    })
    it('test14', 0, () => {
      let props: string[] = []
      let indexes: number[] = []

      let result = postcss.parse(example).walkDecls((decl, i) => {
        props.push(decl.prop)
        indexes.push(i)
      })

      expect(result).assertUndefined()
      expect(props).assertDeepEquals(['a', 'b', 'c', 'd', 'e'])
      expect(indexes).assertDeepEquals([0, 1, 0, 0, 0])
    })
    it('test15', 0, () => {
      let size = 0
      postcss.parse(example).walkDecls((decl, i) => {
        decl.parent?.removeChild(i)
        size += 1
      })
      expect(size).assertDeepEquals(5)
    })
    it('test16', 0, () => {
      let css = postcss.parse('@page{a{one:1}}b{one:1;two:2}')
      let size = 0

      css.walkDecls('one', decl => {
        expect(decl.prop).assertDeepEquals('one')
        size += 1
      })

      expect(size).assertDeepEquals(2)
    })
    it('test17', 0, () => {
      let css = postcss.parse('@page{a{one:1}}b{one:1;two:2}')
      let size = 0

      css.walkDecls('one', () => {
        size += 1
        return false
      })

      expect(size).assertDeepEquals(1)
    })
    it('test18', 0, () => {
      let css = postcss.parse('@page{a{one:1}}b{one-x:1;two:2}')
      let size = 0

      css.walkDecls(new RegExp('one(-x)?'), () => {
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test19', 0, () => {
      let css = postcss.parse('@page{a{one:1}}b{one-x:1;two:2}')
      let size = 0

      css.walkDecls(new RegExp('one(-x)?'), () => {
        size += 1
        return false
      })

      expect(size).assertDeepEquals(1)
    })
    it('test20', 0, () => {
      let texts: string[] = []
      let indexes: number[] = []

      let result = postcss.parse(example).walkComments((comment, i) => {
        texts.push(comment.text)
        indexes.push(i)
      })

      expect(result).assertUndefined()
      expect(texts).assertDeepEquals(['a', 'b', 'c'])
      expect(indexes).assertDeepEquals([1, 0, 1])
    })
    it('test21', 0, () => {
      let size = 0
      postcss.parse(example).walkComments((comment, i) => {
        comment.parent?.removeChild(i)
        size += 1
      })
      expect(size).assertDeepEquals(3)
    })
    it('test22', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walkComments((comment, i) => {
        indexes.push(i)
        return false
      })

      expect(result).assertDeepEquals(false)
      expect(indexes).assertDeepEquals([1])
    })
    it('test23', 0, () => {
      let selectors: string[] = []
      let indexes: number[] = []

      let result = postcss.parse(example).walkRules((rule, i) => {
        selectors.push(rule.selector)
        indexes.push(i)
      })

      expect(result).assertUndefined()
      expect(selectors).assertDeepEquals(['a', 'to', 'em'])
      expect(indexes).assertDeepEquals([0, 1, 0])
    })
    it('test24', 0, () => {
      let size = 0
      postcss.parse(example).walkRules((rule, i) => {
        rule.parent?.removeChild(i)
        size += 1
      })
      expect(size).assertDeepEquals(3)
    })
    it('test25', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walkRules((rule, i) => {
        indexes.push(i)
        return false
      })

      expect(result).assertDeepEquals(false)
      expect(indexes).assertDeepEquals([0])
    })
    it('test26', 0, () => {
      let size = 0
      postcss.parse('a{}b{}a{}').walkRules('a', rule => {
        expect(rule.selector).assertDeepEquals('a')
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test27', 0, () => {
      let size = 0
      postcss.parse('a{}b{}a{}').walkRules('a', () => {
        size += 1
        return false
      })
      expect(size).assertDeepEquals(1)
    })
    it('test28', 0, () => {
      let size = 0
      postcss.parse('a{}a b{}b a{}').walkRules(new RegExp('^a'), rule => {
        size += 1
      })
      expect(size).assertDeepEquals(2)
    })
    it('test29', 0, () => {
      let size = 0
      postcss.parse('a{}b a{}b a{}').walkRules(new RegExp('^a'), () => {
        size += 1
        return false
      })
      expect(size).assertDeepEquals(1)
    })
    it('test30', 0, () => {
      let names: string[] = []
      let indexes: number[] = []

      let result = postcss.parse(example).walkAtRules((atrule, i) => {
        names.push(atrule.name)
        indexes.push(i)
      })

      expect(result).assertUndefined()
      expect(names).assertDeepEquals(['keyframes', 'media', 'page'])
      expect(indexes).assertDeepEquals([2, 3, 1])
    })
    it('test31', 0, () => {
      let size = 0
      postcss.parse(example).walkAtRules((atrule, i) => {
        atrule.parent?.removeChild(i)
        size += 1
      })
      expect(size).assertDeepEquals(3)
    })
    it('test32', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walkAtRules((atrule, i) => {
        indexes.push(i)
        return false
      })

      expect(result).assertDeepEquals(false)
      expect(indexes).assertDeepEquals([2])
    })
    it('test33', 0, () => {
      let css = postcss.parse('@page{@page 2{}}@media print{@page{}}')
      let size = 0

      css.walkAtRules('page', atrule => {
        expect(atrule.name).assertDeepEquals('page')
        size += 1
      })

      expect(size).assertDeepEquals(3)
    })
    it('test34', 0, () => {
      let size = 0
      postcss.parse('@page{@page{@page{}}}').walkAtRules('page', () => {
        size += 1
        return false
      })
      expect(size).assertDeepEquals(1)
    })
    it('test35', 0, () => {
      let css = postcss.parse('@page{@page 2{}}@media print{@pages{}}')
      let size = 0

      css.walkAtRules(new RegExp('page'), () => {
        size += 1
      })

      expect(size).assertDeepEquals(3)
    })
    it('test36', 0, () => {
      let size = 0
      postcss.parse('@page{@pages{@page{}}}').walkAtRules(new RegExp('page'), () => {
        size += 1
        return false
      })
      expect(size).assertDeepEquals(1)
    })
    it('test37', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.append({
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; b: 2; c: 3 }')
      expect(rule.last?.raws.before).assertDeepEquals(' ')
    })
    it('test38', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.append({
        prop: 'c', value: '3'
      }, {
        prop: 'd', value: '4'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; b: 2; c: 3; d: 4 }')
      expect(rule.last?.raws.before).assertDeepEquals(' ')
    })
    it('test39', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.append({
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; b: 2; c: 3 }')
    })
    it('test42', 0, () => {
      let root = new postcss.Root()
      root.append({
        text: 'ok'
      })
      expect(root.first?.toString()).assertDeepEquals('/* ok */')
    })
    it('test43', 0, () => {
      let css = postcss.parse('a {}')
      css.append(postcss.parse('b {}'))
      expect(css.toString()).assertDeepEquals('a {}b {}')
    })
    it('test45', 0, () => {
      let a = postcss.parse('a{ z-index: 1 }')
      let b = postcss.parse('b{ width: 1px; height: 2px }')
      let aRule = a.first as postcss.Rule
      let bRule = b.first as postcss.Rule

      aRule.append(bRule.nodes)
      expect(a.toString()).assertDeepEquals('a{ z-index: 1; width: 1px; height: 2px }')
      expect(b.toString()).assertDeepEquals('b{ }')
    })
    it('test46', 0, () => {
      let a = postcss.parse('a{}')
      let b = postcss.parse('b{}')

      b.append(a.first as postcss.Rule)
      let bLast = b.last as postcss.Rule
      bLast.selector = 'b a'

      expect(a.toString()).assertDeepEquals('')
      expect(b.toString()).assertDeepEquals('b{}b a{}')
    })
    it('test47', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.prepend({
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { c: 3; a: 1; b: 2 }')
      expect(rule.first?.raws.before).assertDeepEquals(' ')
    })
    it('test48', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.prepend({
        prop: 'c', value: '3'
      }, {
        prop: 'd', value: '4'
      })
      expect(rule.toString()).assertDeepEquals('a { c: 3; d: 4; a: 1; b: 2 }')
      expect(rule.first?.raws.before).assertDeepEquals(' ')
    })
    it('test49', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.prepend({
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { c: 3; a: 1; b: 2 }')
    })
    it('test50', 0, () => {
      let css = postcss.parse('a {}')
      css.prepend(postcss.parse('b {}'))
      expect(css.toString()).assertDeepEquals('b {}\na {}')
    })
    it('test53', 0, () => {
      let root = postcss.parse('')
      root.prepend(new Rule({
        selector: 'a'
      }))
      expect(root.toString()).assertDeepEquals('a {}')
    })
    it('test54', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.insertBefore(1, {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
      expect(rule.nodes[1].raws.before).assertDeepEquals(' ')
    })
    it('test55', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.insertBefore(rule.nodes[1], {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
    })
    it('test56', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.insertBefore(1, {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
    })
    it('test57', 0, () => {
      let a = postcss.parse('a{ color: red; z-index: 1 }')
      let b = postcss.parse('b{ width: 1; height: 2 }')
      let aRule = a.first as postcss.Rule
      let bRule = b.first as postcss.Rule

      aRule.insertBefore(1, bRule.nodes)
      expect(a.toString()).assertDeepEquals('a{ color: red; width: 1; height: 2; z-index: 1 }')
    })
    it('test58', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as postcss.Rule
      rule.insertAfter(0, {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
      expect(rule.nodes[1].raws.before).assertDeepEquals(' ')
    })
    it('walkDecls()_breaks_iteration', 0, () => {
      let indexes: number[] = []

      let result = postcss.parse(example).walkDecls((decl, i) => {
        indexes.push(i)
        return false
      })
      expect(result).assertDeepEquals(false)
      expect(indexes[0]).assertEqual(0)
    })
    it('append()_has_rule_shortcut', 0, () => {
      let root = new postcss.Root()
      root.append({
        selector: 'a'
      })
      expect(root.first?.toString()).assertDeepEquals('a {}')
    })
    it('append()_has_at-rule_shortcut', 0, () => {
      let root = new postcss.Root()
      root.append({
        name: 'encoding', params: '"utf-8"'
      })
      expect(root.first?.toString()).assertDeepEquals('@encoding "utf-8"')
    })
    it('append()_reveives_string', 0, () => {
      let root = new postcss.Root()
      root.append('a{}b{}')
      let a = root.first as Rule
      a.append('color:black')
      expect(root.toString()).assertDeepEquals('a{color:black}b{}')
      expect(a.first?.source).assertUndefined()
    })
    it('prepend()_receives_string', 0, () => {
      let css = postcss.parse('a {}')
      css.prepend('b {}')
      expect(css.toString()).assertDeepEquals('b {}\na {}')
    })

    it('prepend()_receives_array', 0, () => {
      let a = postcss.parse('a{ z-index: 1 }')
      let b = postcss.parse('b{ width: 1px; height: 2px }')
      let aRule = a.first as Rule
      let bRule = b.first as Rule

      aRule.prepend(bRule.nodes)
      expect(a.toString()).assertDeepEquals('a{ width: 1px; height: 2px; z-index: 1 }')
    })
    it('insertBefore()_receives_pre-existing_child_node_-_a', 0, () => {
      let a = postcss.parse('a{ align-items: start; color: red; z-index: 1 }')
      let declA = (a.first as Rule).nodes[0]
      let declC = (a.first as Rule).nodes[2]
      declC.before(declA)
      expect(a.toString()).assertDeepEquals('a{ color: red; align-items: start; z-index: 1 }')
    })
    it('insertBefore()_receives_pre-existing_child_node_-_b', 0, () => {
      let a = postcss.parse('a{ align-items: start; color: red; z-index: 1 }')
      let declA = (a.first as Rule).nodes[0]
      let declC = (a.first as Rule).nodes[2]
      declA.before(declC)
      expect(a.toString()).assertDeepEquals('a{ z-index: 1; align-items: start; color: red }')
    })

    it('insertBefore()_has_defined_way_of_adding_newlines', 0, () => {
      let root = postcss.parse('a {}')
      root.insertBefore(root.first as Rule, 'b {}')
      root.insertBefore(root.first as Rule, 'c {}')
      expect(root.toString()).assertDeepEquals('c {}\nb {}\na {}')

      root = postcss.parse('other {}a {}')
      root.insertBefore(root.first as Rule, 'b {}')
      root.insertBefore(root.first as Rule, 'c {}')
      expect(root.toString()).assertDeepEquals('c {}b {}other {}a {}')

      root = postcss.parse('other {}\na {}')
      root.insertBefore(root.nodes[1] as Rule, 'b {}')
      root.insertBefore(root.nodes[1] as Rule, 'c {}')
      expect(root.toString()).assertDeepEquals('other {}\nc {}\nb {}\na {}')

      root = postcss.parse('other {}a {}')
      root.insertBefore(root.nodes[1] as Rule, 'b {}')
      root.insertBefore(root.nodes[1] as Rule, 'c {}')
      expect(root.toString()).assertDeepEquals('other {}c {}b {}a {}')
    })
    it('insertAfter()_works_with_nodes_too', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let aDecl = rule.first as postcss.Declaration
      rule.insertAfter(aDecl, {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
    })
    it('insertAfter()_receive_hash_instead_of_declaration', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      rule.insertAfter(0, {
        prop: 'c', value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; c: 3; b: 2 }')
    })

    it('insertAfter()_receives_array', 0, () => {
      let a = postcss.parse('a{ color: red; z-index: 1 }')
      let b = postcss.parse('b{ width: 1; height: 2 }')
      let aRule = a.first as Rule
      let bRule = b.first as Rule

      aRule.insertAfter(0, bRule.nodes)
      expect(a.toString()).assertDeepEquals('a{ color: red; width: 1; height: 2; z-index: 1 }')
    })

    it('insertAfter()_receives_pre-existing_child_node_-_a', 0, () => {
      let a = postcss.parse('a{ align-items: start; color: red; z-index: 1 }')
      let declA = (a.first as Rule).nodes[0]
      let declC = (a.first as Rule).nodes[2]
      declC.after(declA)

      expect(a.toString()).assertDeepEquals('a{ color: red; z-index: 1; align-items: start }')
    })

    it('insertAfter()_receives_pre-existing_child_node_-_b', 0, () => {
      let a = postcss.parse('a{ align-items: start; color: red; z-index: 1 }')
      let declA = (a.first as Rule).nodes[0]
      let declC = (a.first as Rule).nodes[2]
      declA.after(declC)

      expect(a.toString()).assertDeepEquals('a{ align-items: start; z-index: 1; color: red }')
    })

    it('removeChild()_removes_by_index', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      rule.removeChild(1)
      expect(rule.toString()).assertDeepEquals('a { a: 1 }')
    })

    it('removeChild()_removes_by_node', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let bDecl = rule.last as postcss.Declaration
      rule.removeChild(bDecl)
      expect(rule.toString()).assertDeepEquals('a { a: 1 }')
    })

    it('removeChild()_cleans_parent_in_removed_node', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let aDecl = rule.first as postcss.Declaration
      rule.removeChild(aDecl)
      expect(aDecl.parent).assertUndefined()
    })

    it('removeAll()_removes_all_children', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let decl = rule.first as postcss.Declaration
      rule.removeAll()
      expect(decl.parent).assertUndefined()
      expect(rule.toString()).assertDeepEquals('a { }')
    })
    it('replaceValues()_replaces_strings', 0, () => {
      let css = postcss.parse('a{one:1}b{two:1 2}')
      let result = css.replaceValues('1', 'A')
      expect(result).assertEqual(css)
      expect(css.toString()).assertDeepEquals('a{one:A}b{two:A 2}')
    })
    it('replaceValues()_replaces_regpexp', 0, () => {
      let css = postcss.parse('a{one:1}b{two:1 2}')
      css.replaceValues(/\d/g, i => i + 'A')
      expect(css.toString()).assertDeepEquals('a{one:1A}b{two:1A 2A}')
    })
    it('replaceValues()_filters_properties', 0, () => {
      let css = postcss.parse('a{one:1}b{two:1 2}')
      css.replaceValues('1', {
        props: ['one']
      }, 'A')
      expect(css.toString()).assertDeepEquals('a{one:A}b{two:1 2}')
    })
    it('replaceValues()_uses_fast_check', 0, () => {
      let css = postcss.parse('a{one:1}b{two:1 2}')
      css.replaceValues('1', {
        fast: '2'
      }, 'A')
      expect(css.toString()).assertDeepEquals('a{one:1}b{two:A 2}')
    })
    it('any()_return_true_if_all_children_return_true', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      expect(rule.every(i => i.type === 'decl' && /a|b/.test(i.prop))).assertDeepEquals(true)
      expect(rule.every(i => i.type === 'decl' && /b/.test(i.prop))).assertDeepEquals(false)
    })
    it('some()_return_true_if_all_children_return_true', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      expect(rule.some(i => i.type === 'decl' && i.prop === 'b')).assertDeepEquals(true)
      expect(rule.some(i => i.type === 'decl' && i.prop === 'c')).assertDeepEquals(false)
    })
    it('index()_returns_child_index', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      expect(rule.index(rule.nodes[1])).assertDeepEquals(1)
    })
    it('index()_returns_argument_if_it_is_number', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      expect(rule.index(2)).assertDeepEquals(2)
    })
    it('first()_works_for_children-less_nodes', 0, () => {
      let atRule = postcss.parse('@charset "UTF-*"').first as postcss.AtRule
      expect(atRule.first).assertUndefined()
    })
    it('last()_works_for_children-less_nodes', 0, () => {
      let atRule = postcss.parse('@charset "UTF-*"').first as postcss.AtRule
      expect(atRule.last).assertUndefined()
    })
    it('returns_first_child', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let aDecl = rule.first as postcss.Declaration
      expect(aDecl.prop).assertDeepEquals('a')
    })
    it('returns_last_child', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      let bDecl = rule.last as postcss.Declaration
      expect(bDecl.prop).assertDeepEquals('b')
    })
    it('normalize()_does_not_normalize_new_children_with_exists_before', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      rule.append({
        prop: 'c', raws: {
          before: '\n '
        }, value: '3'
      })
      expect(rule.toString()).assertDeepEquals('a { a: 1; b: 2;\n c: 3 }')
    })
    it('forces_Declaration#value_to_be_string', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      rule.append({
        prop: 'c', value: 3
      })
      let aDecl = rule.first as postcss.Declaration
      let cDecl = rule.last as postcss.Declaration
      expect(typeof aDecl.value).assertEqual('string')
      expect(typeof cDecl.value).assertEqual('string')
    })
    it('updates_parent_in_overrides.nodes_in_constructor', 0, () => {
      let root = new postcss.Root({
        nodes: [{
          selector: 'a'
        }]
      })
      let a = root.first as Rule
      expect(a.parent).assertEqual(root)

      root.append({
        nodes: [{
          prop: 'color', value: 'black'
        }],
        selector: 'b'
      })
      let b = root.last as Rule
      let color = b.first as postcss.Declaration
      expect(color.parent).assertEqual(root.last)
    })
    it('allows_to_clone_nodes', 0, () => {
      let root1 = postcss.parse('a { color: black; z-index: 1 } b {}')
      let root2 = new postcss.Root({
        nodes: root1.nodes
      })
      expect(root1.toString()).assertDeepEquals('a { color: black; z-index: 1 } b {}')
      expect(root2.toString()).assertDeepEquals('a { color: black; z-index: 1 } b {}')
    })
    it('container.nodes_can_be_sorted', 0, () => {
      let root = postcss.parse('@b; @c; @a;')
      let b = root.nodes[0]
      root.nodes.sort((x, y) => {
        return (x as postcss.AtRule).name.localeCompare((y as postcss.AtRule).name)
      })

      // Sorted nodes are reflected in "toString".
      expect(root.toString()).assertDeepEquals(' @a;@b; @c;')

      // Sorted nodes are reflected in "walk".
      let result: string[] = []
      root.walkAtRules(atRule => {
        result.push(atRule.name.trim())
      })
      expect(result.join(' ')).assertDeepEquals('a b c')

      // Sorted nodes have the corect "index".
      expect(root.index(b)).assertDeepEquals(1)

      // Inserting after a sorted node results in the correct order.
      b.after('@d;')
      expect(root.toString()).assertDeepEquals(' @a;@b;@d; @c;')
    })
    it('ignores_undefined_on_adding', 0, () => {
      let rule = postcss.parse('a { a: 1; b: 2 }').first as Rule
      rule.append({
        prop: 'c', value: '3'
      }, undefined)
      rule.prepend(undefined)
      rule.insertAfter(0, undefined)
      rule.insertBefore(0, undefined)
      rule.after(undefined)
      rule.before(undefined)
      expect(rule.parent!.toString()).assertDeepEquals('a { a: 1; b: 2; c: 3 }')
    })
  })
}