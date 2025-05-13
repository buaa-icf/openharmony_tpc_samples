// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
import { Action, CardElement, CardObjectRegistry } from "./adaptivecards";

export class GlobalRegistry {
  private static _elements?: CardObjectRegistry<CardElement>;
  private static _actions?: CardObjectRegistry<Action>;

  static populateWithDefaultElements(registry: CardObjectRegistry<CardElement>) {
    registry.clear();

    GlobalRegistry.defaultElements.copyTo(registry);
  }

  static populateWithDefaultActions(registry: CardObjectRegistry<Action>) {
    registry.clear();

    GlobalRegistry.defaultActions.copyTo(registry);
  }

  static readonly defaultElements = new CardObjectRegistry<CardElement>();
  static readonly defaultActions = new CardObjectRegistry<Action>();
  static get elements(): CardObjectRegistry<CardElement> {
    if (!GlobalRegistry._elements) {
      GlobalRegistry._elements = new CardObjectRegistry<CardElement>();
      GlobalRegistry.populateWithDefaultElements(GlobalRegistry._elements);
    }

    return GlobalRegistry._elements;
  }

  static get actions(): CardObjectRegistry<Action> {
    if (!GlobalRegistry._actions) {
      GlobalRegistry._actions = new CardObjectRegistry<Action>();
      GlobalRegistry.populateWithDefaultActions(GlobalRegistry._actions);
    }

    return GlobalRegistry._actions;
  }

  static reset() {
    GlobalRegistry._elements = undefined;
    GlobalRegistry._actions = undefined;
  }
}
