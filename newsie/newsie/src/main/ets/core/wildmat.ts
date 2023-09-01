// @flow

export class Wildmat {}

export class Choice extends Wildmat {
  public left: Wildmat
  public right: Wildmat
  constructor(left: Wildmat, right: Wildmat) {
    super()
    this.left = left
    this.right = right
  }
}

export class WildmatParser {
  private _input: string

  constructor(input: string) {
    this._input = input
  }

  public parse(): Wildmat {
    throw new Error('not implemented')
  }

  private _peek = (): string => this._input.charAt(0)

  /* Recursive descent parsing internals. */

  private _eat = (c: string): void => {
    if (this._peek() === c) {
      this._input = this._input.substring(1)
    } else {
      throw new Error(`Expected ${c} got ${this._peek()}`)
    }
  }

  private _next = (): string => {
    const c = this._peek()
    this._eat(c)
    return c
  }

  private _more = (): boolean => this._input.length > 0

  /* Regular expression term types. */

  private _wildmat = (): Wildmat => {
    const term = this._term()
    if (this._more() && this._peek() === '|') {
      this._eat('|')
      const wildmat = this._wildmat()
      return new Choice(term, wildmat)
    } else {
      return term
    }
  }

  /** @private */
  private _term(): Wildmat {
    throw new Error('not implemented')
  }

  /** @private */
  private _factor(): Wildmat {
    throw new Error('not implemented')
  }

  /** @private */
  private _base(): Wildmat {
    throw new Error('not implemented')
  }
}
