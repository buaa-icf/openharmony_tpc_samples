// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
import * as Enums from "./enums";
import {
    PaddingDefinition,
    GlobalSettings,
    SizeAndUnit,
    SpacingDefinition,
    ISeparationDefinition,
    Dictionary,
    StringWithSubstitutions,
    ContentTypes,
    IInput,
    IResourceInformation
} from "./shared";
import * as Utils from "./utils";
import {
    HostConfig,
    defaultHostConfig,
    BaseTextDefinition,
    FontTypeDefinition,
    ColorSetDefinition,
    TextColorDefinition,
    ContainerStyleDefinition,
    TextStyleDefinition
} from "./host-config";
import * as TextFormatters from "./text-formatters";
import { CardObject, ValidationResults } from "./card-object";
import {
    Versions,
    Version,
    property,
    BaseSerializationContext,
    SerializableObject,
    SerializableObjectSchema,
    StringProperty,
    BoolProperty,
    ValueSetProperty,
    EnumProperty,
    SerializableObjectCollectionProperty,
    SerializableObjectProperty,
    PixelSizeProperty,
    NumProperty,
    PropertyBag,
    CustomProperty,
    PropertyDefinition,
    StringArrayProperty
} from "./serialization";
import { CardObjectRegistry } from "./registry";
import { Strings } from "./strings";
import { BuilderNode, FrameNode, typeNode } from "@ohos.arkui.node";
import { Context, UIContext } from "@ohos.arkui.UIContext";
import { GlobalRegistry } from "./GlobalRegistry";
import { LogUtils } from "./LogUtils";
import { CarouselEvent } from "./carousel";


function clearElement(element: FrameNode | null) : void {
    element?.clearChildren();
}

export function renderSeparation(context:UIContext,
    hostConfig: HostConfig,
    separationDefinition: ISeparationDefinition,
    orientation: Enums.Orientation
): FrameNode | undefined {
    if (
        separationDefinition.spacing > 0 ||
        (separationDefinition.lineThickness && separationDefinition.lineThickness > 0)
    ) {
        const separator = typeNode.createNode(context, "Flex");
        separator.attribute.width('auto');
        separator.attribute.height('auto');
        const color = separationDefinition.lineColor
            ? Utils.stringToCssColor(separationDefinition.lineColor)
            : "";
        if (orientation === Enums.Orientation.Horizontal) {
            //分割线 横向
            if (separationDefinition.lineThickness) {
                LogUtils.getInstance().info("separator Horizontal lineThickness:"+separationDefinition.lineThickness+" spacing "+separationDefinition.spacing+" color "+color);
                separator.initialize({ alignItems: ItemAlign.Auto , direction:FlexDirection.Column,justifyContent:FlexAlign.Center});
                const separatorNodeTop = typeNode.createNode(context, "Flex");
                separatorNodeTop.attribute.height(px2vp(separationDefinition.spacing / 2));
                const separatorNodeBottom = typeNode.createNode(context, "Flex");
                separatorNodeBottom.attribute.height(px2vp(separationDefinition.spacing / 2));
                const separatorNodeMiddle = typeNode.createNode(context, "Flex");
                separatorNodeMiddle.attribute.height(separationDefinition.lineThickness);
                separatorNodeMiddle.attribute.backgroundColor(color);
                separatorNodeMiddle.attribute.width('100%');
                separator.appendChild(separatorNodeTop);
                separator.appendChild(separatorNodeMiddle);
                separator.appendChild(separatorNodeBottom);
            } else {
                separator.attribute.height(px2vp(separationDefinition.spacing));
            }
        } else {
            //分割线 纵向
            if (separationDefinition.lineThickness) {
                LogUtils.getInstance().info("separator Vertical lineThickness:"+separationDefinition.lineThickness+" spacing "+separationDefinition.spacing+" color "+color);
                const separatorNodeLeft = typeNode.createNode(context, "Flex");
                separatorNodeLeft.attribute.width(px2vp(separationDefinition.spacing / 2));
                const separatorNodeRight = typeNode.createNode(context, "Flex");
                separatorNodeRight.attribute.width(px2vp(separationDefinition.spacing / 2));
                const separatorNodeMiddle = typeNode.createNode(context, "Flex");
                separatorNodeMiddle.attribute.height(separationDefinition.lineThickness);
                separatorNodeMiddle.attribute.backgroundColor(color);
                separator.appendChild(separatorNodeLeft);
                separator.appendChild(separatorNodeMiddle);
                separator.appendChild(separatorNodeRight);
            } else {
                separator.attribute.width(px2vp(separationDefinition.spacing));
            }
        }
        separator.attribute.clip(true);
        separator.attribute.flexGrow(0);
        separator.attribute.flexShrink(0);
        separator.attribute.flexBasis('auto');
        return separator;
    } else {
        return undefined;
    }
}

export type CardElementHeight = "auto" | "stretch";

export abstract class CardElement extends CardObject {
    //#region Schema

    static readonly langProperty = new StringProperty(
        Versions.v1_1,
        "lang",
        true,
        /^[a-z]{2,3}$/gi
    );
    static readonly isVisibleProperty = new BoolProperty(Versions.v1_2, "isVisible", true);
    static readonly separatorProperty = new BoolProperty(Versions.v1_0, "separator", false);
    static readonly heightProperty = new ValueSetProperty(
        Versions.v1_1,
        "height",
        [{ value: "auto" }, { value: "stretch" }],
        "auto"
    );
    static readonly horizontalAlignmentProperty = new EnumProperty(
        Versions.v1_0,
        "horizontalAlignment",
        Enums.HorizontalAlignment
    );
    static readonly spacingProperty = new EnumProperty(
        Versions.v1_0,
        "spacing",
        Enums.Spacing,
        Enums.Spacing.Default
    );

    static readonly minWidthProperty = new PixelSizeProperty(Versions.v1_2, "minWidth");

    @property(CardElement.horizontalAlignmentProperty)
    horizontalAlignment?: Enums.HorizontalAlignment;

    @property(CardElement.spacingProperty)
    spacing?: Enums.Spacing;

    @property(CardElement.separatorProperty)
    separator?: boolean;

    @property(CardElement.heightProperty)
    height?: CardElementHeight;

    @property(CardElement.langProperty)
    get lang(): string | undefined {
        const lang = this.getValue(CardElement.langProperty) as string;

        if (lang) {
            return lang;
        } else {
            if (this.parent) {
                return this.parent.lang;
            } else {
                return undefined;
            }
        }
    }

    set lang(value: string | undefined) {
        this.setValue(CardElement.langProperty, value);
    }

    @property(CardElement.minWidthProperty)
    minPixelWidth?: number;

    @property(CardElement.isVisibleProperty)
    get isVisible(): boolean {
        return this.getValue(CardElement.isVisibleProperty);
    }

    set isVisible(value: boolean) {
        // If the element is going to be hidden, reset any changes that were due
        // to overflow truncation (this ensures that if the element is later
        // un-hidden it has the right content)
        if (GlobalSettings.useAdvancedCardBottomTruncation && !value) {
            this.undoOverflowTruncation();
        }

        if (this.isVisible !== value) {
            this.setValue(CardElement.isVisibleProperty, value);

            this.updateRenderedElementVisibility();

            if (this._renderedElement) {
                raiseElementVisibilityChangedEvent(this);
            }
        }

    }



    //#endregion

    private _hostConfig?: HostConfig;
    private _separatorElement?: FrameNode;
    private _truncatedDueToOverflow: boolean = false;
    private _defaultRenderedElementDisplayMode?: string;
    private _padding?: PaddingDefinition;

    private internalRenderSeparator(context:UIContext): FrameNode | undefined {
        const renderedSeparator = renderSeparation(context,
            this.hostConfig,
            {
                spacing: this.hostConfig.getEffectiveSpacing(this.spacing),
                lineThickness: this.separator ? this.hostConfig.separator.lineThickness : undefined,
                lineColor: this.separator ? this.hostConfig.separator.lineColor : undefined
            },
            this.separatorOrientation
        );

        if (
            GlobalSettings.alwaysBleedSeparators &&
            renderedSeparator &&
            this.separatorOrientation === Enums.Orientation.Horizontal
        ) {
            // Adjust separator's margins if the option to always bleed separators is turned on
            const parentContainer = this.getParentContainer();

            if (parentContainer && parentContainer.getEffectivePadding()) {
                const parentPhysicalPadding = this.hostConfig.paddingDefinitionToSpacingDefinition(
                    parentContainer.getEffectivePadding()
                );
                renderedSeparator.commonAttribute.margin({left:-parentPhysicalPadding.left,
                    right:-parentPhysicalPadding.right});
            }
        }

        return renderedSeparator;
    }

    private updateRenderedElementVisibility() {
        const displayMode =
            this.isDesignMode() || this.isVisible
                ? this._defaultRenderedElementDisplayMode
                : "none";

        if (this._renderedElement) {
            if (displayMode) {
                this._renderedElement.commonAttribute.visibility(displayMode === 'none' ? Visibility.None :
                Visibility.Visible);
            } else {
                this._renderedElement.commonAttribute.visibility(Visibility.Visible);
            }
        }

        if (this._separatorElement) {
            if (this.parent && this.parent.isFirstElement(this)) {
                this._separatorElement.commonAttribute.visibility(Visibility.None);
            } else {
                if (displayMode) {
                    this._separatorElement.commonAttribute.visibility(displayMode === 'none' ? Visibility.None :
                    Visibility.Visible);
                } else {
                    this._separatorElement.commonAttribute.visibility(Visibility.Visible);
                }
            }
        }
    }

    private hideElementDueToOverflow() {
        if (this._renderedElement && this.isVisible) {
            this._renderedElement.commonAttribute.visibility(Visibility.Hidden);
            this.isVisible = false;
            raiseElementVisibilityChangedEvent(this, false);
        }
    }

    private showElementHiddenDueToOverflow() {
        if (this._renderedElement && !this.isVisible) {
            this.isVisible = true;
            raiseElementVisibilityChangedEvent(this, false);
        }
    }

    // Marked private to emulate internal access
    private handleOverflow(maxHeight: number) {
        if (this.isVisible || this.isHiddenDueToOverflow()) {
            const handled = this.truncateOverflow(maxHeight);

            // Even if we were unable to truncate the element to fit this time,
            // it still could have been previously truncated
            this._truncatedDueToOverflow = handled || this._truncatedDueToOverflow;

            if (!handled) {
                this.hideElementDueToOverflow();
            } else if (handled && !this.isVisible) {
                this.showElementHiddenDueToOverflow();
            }
        }
    }

    // Marked private to emulate internal access
    private resetOverflow(): boolean {
        let sizeChanged = false;

        if (this._truncatedDueToOverflow) {
            this.undoOverflowTruncation();
            this._truncatedDueToOverflow = false;
            sizeChanged = true;
        }

        if (this.isHiddenDueToOverflow()) {
            this.showElementHiddenDueToOverflow();
        }

        return sizeChanged;
    }

    protected getDefaultSerializationContext(): BaseSerializationContext {
        return new SerializationContext();
    }

    protected createPlaceholderElement(context:UIContext): FrameNode {
        const styleDefinition = this.getEffectiveStyleDefinition();
        const foregroundCssColor = Utils.stringToCssColor(
            styleDefinition.foregroundColors.default.subtle
        );
        let element = typeNode.createNode(context, "Text");
        element.commonAttribute.constraintSize({minHeight:32});
        element.attribute.border({ width: 1, color: foregroundCssColor, style: BorderStyle.Dashed})
        element.attribute.padding(4);
        element.attribute.fontSize(10);
        if (foregroundCssColor) {
            element.attribute.fontColor(foregroundCssColor);
        }
        element.initialize(Strings.defaults.emptyElementText(this.getJsonTypeName()));
        return element;
    }

    protected adjustRenderedElementSize(renderedElement: FrameNode) {
        if (this.height === "auto") {
            renderedElement.commonAttribute.flexGrow(0);
            renderedElement.commonAttribute.flexShrink(0);
            renderedElement.commonAttribute.flexBasis('auto');
        } else {
            renderedElement.commonAttribute.flexGrow(1);
            renderedElement.commonAttribute.flexShrink(1);
            renderedElement.commonAttribute.flexBasis('auto');
        }
    }

    /*
     * Called when mouse enters or leaves the card.
     * Inputs elements need to update their visual state in such events like showing or hiding borders etc.
     * It calls Input.updateVisualState(eventType) for all inputs.
     * This method on input (updateVisualState) is supposed to be called from card level on mouse events.
     */
    protected updateInputsVisualState(hover: boolean) {
        const allInputs: Input[] = this.getAllInputs();
        const inputEventType = !!hover ? InputEventType.MouseEnterOnCard : InputEventType.MouseLeaveOnCard;
        allInputs.forEach((input) => input.updateVisualState(inputEventType));
    }

    protected isDisplayed(): boolean {
        return (
            this._renderedElement !== undefined &&
            this.isVisible
        );
    }

    protected abstract internalRender(context:UIContext): FrameNode | undefined;

    protected overrideInternalRender(context:UIContext): FrameNode | undefined {
        return this.internalRender(context);
    }

    protected applyPadding() {
        if (this.separatorElement && this.separatorOrientation === Enums.Orientation.Horizontal) {
            if (GlobalSettings.alwaysBleedSeparators && !this.isBleeding()) {
                const padding = new PaddingDefinition();

                this.getImmediateSurroundingPadding(padding);

                const physicalPadding =
                    this.hostConfig.paddingDefinitionToSpacingDefinition(padding);

                this.separatorElement.commonAttribute.margin({left:-physicalPadding.left, right:-physicalPadding.right});
            } else {
                this.separatorElement.commonAttribute.margin({left:0, right:0});
            }
        }
    }

    /*
     * Called when this element overflows the bottom of the card.
     * maxHeight will be the amount of space still available on the card (0 if
     * the element is fully off the card).
     */
    protected truncateOverflow(_maxHeight: number): boolean {
        // Child implementations should return true if the element handled
        // the truncation request such that its content fits within maxHeight,
        // false if the element should fall back to being hidden
        return false;
    }

    /*
     * This should reverse any changes performed in truncateOverflow().
     */
    protected undoOverflowTruncation() {
        return;
    }

    protected getDefaultPadding(): PaddingDefinition {
        return new PaddingDefinition();
    }

    protected getHasBackground(ignoreBackgroundImages: boolean = false): boolean {
        return false;
    }

    protected getHasBorder(): boolean {
        return false;
    }

    protected getPadding(): PaddingDefinition | undefined {
        return this._padding;
    }

    protected setPadding(value: PaddingDefinition | undefined) {
        this._padding = value;
    }

    protected shouldSerialize(context: SerializationContext): boolean {
        return context.elementRegistry.findByName(this.getJsonTypeName()) !== undefined;
    }

    protected get useDefaultSizing(): boolean {
        return true;
    }

    protected get separatorOrientation(): Enums.Orientation {
        return Enums.Orientation.Horizontal;
    }

    protected get defaultStyle(): string {
        return Enums.ContainerStyle.Default;
    }

    customCssSelector?: string;

    parse(source: PropertyBag, context?: SerializationContext) {
        super.parse(source, context ? context : new SerializationContext());
    }

    asString(): string | undefined {
        return "";
    }

    isBleeding(): boolean {
        return false;
    }

    getEffectiveStyle(): string {
        if (this.parent) {
            return this.parent.getEffectiveStyle();
        }

        return this.defaultStyle;
    }

    getEffectiveStyleDefinition(): ContainerStyleDefinition {
        return this.hostConfig.containerStyles.getStyleByName(this.getEffectiveStyle());
    }

    getEffectiveTextStyleDefinition(): TextStyleDefinition {
        if (this.parent) {
            return this.parent.getEffectiveTextStyleDefinition();
        }

        return this.hostConfig.textStyles.default;
    }

    getForbiddenActionTypes(): ActionType[] {
        return [];
    }

    getImmediateSurroundingPadding(
        result: PaddingDefinition,
        processTop: boolean = true,
        processRight: boolean = true,
        processBottom: boolean = true,
        processLeft: boolean = true
    ) {
        if (this.parent) {
            let doProcessTop = processTop && this.parent.isTopElement(this);
            let doProcessRight = processRight && this.parent.isRightMostElement(this);
            let doProcessBottom = processBottom && this.parent.isBottomElement(this);
            let doProcessLeft = processLeft && this.parent.isLeftMostElement(this);

            const effectivePadding = this.parent.getEffectivePadding();

            if (effectivePadding) {
                if (doProcessTop && effectivePadding.top !== Enums.Spacing.None) {
                    result.top = effectivePadding.top;

                    doProcessTop = false;
                }

                if (doProcessRight && effectivePadding.right !== Enums.Spacing.None) {
                    result.right = effectivePadding.right;

                    doProcessRight = false;
                }

                if (doProcessBottom && effectivePadding.bottom !== Enums.Spacing.None) {
                    result.bottom = effectivePadding.bottom;

                    doProcessBottom = false;
                }

                if (doProcessLeft && effectivePadding.left !== Enums.Spacing.None) {
                    result.left = effectivePadding.left;

                    doProcessLeft = false;
                }
            }

            if (doProcessTop || doProcessRight || doProcessBottom || doProcessLeft) {
                this.parent.getImmediateSurroundingPadding(
                    result,
                    doProcessTop,
                    doProcessRight,
                    doProcessBottom,
                    doProcessLeft
                );
            }
        }
    }

    getActionCount(): number {
        return 0;
    }

    getActionAt(index: number): Action | undefined {
        throw new Error(Strings.errors.indexOutOfRange(index));
    }

    indexOfAction(action: Action): number {
        for (let i = 0; i < this.getActionCount(); i++) {
            if (this.getActionAt(i) === action) {
                return i;
            }
        }

        return -1;
    }

    remove(): boolean {
        if (this.parent && this.parent instanceof CardElementContainer) {
            return this.parent.removeItem(this);
        }
        return false;
    }

    render(context: UIContext): FrameNode | undefined {
        this._renderedElement = this.overrideInternalRender(context);
        this._separatorElement = this.internalRenderSeparator(context);

        if (this._renderedElement) {
            if (this.id) {
                // this._renderedElement.id = this.id;
                this._renderedElement.commonAttribute.id(this.id);
            }
            this._defaultRenderedElementDisplayMode = this._renderedElement.isVisible()
                ? "visible"
                : "none";
            //修复图片和文字排版间距特别大的问题
            // this.adjustRenderedElementSize(this._renderedElement);
            this.updateLayout(false);
        } else if (this.isDesignMode()) {
            this._renderedElement = this.createPlaceholderElement(context);
        }

        return this._renderedElement;
    }

    updateLayout(_processChildren: boolean = true) {
        this.updateRenderedElementVisibility();
        this.applyPadding();
    }

    updateActionsEnabledState() {
        const allActions = this.getRootElement().getAllActions();

        for (let action of allActions) {
            action.updateEnabledState();
        }
    }

    indexOf(_cardElement: CardElement): number {
        return -1;
    }

    isDesignMode(): boolean {
        const rootElement = this.getRootElement();

        return rootElement instanceof AdaptiveCard && rootElement.designMode;
    }

    isFirstElement(_element: CardElement): boolean {
        return true;
    }

    isLastElement(_element: CardElement): boolean {
        return true;
    }

    isAtTheVeryLeft(): boolean {
        return this.parent
            ? this.parent.isLeftMostElement(this) && this.parent.isAtTheVeryLeft()
            : true;
    }

    isAtTheVeryRight(): boolean {
        return this.parent
            ? this.parent.isRightMostElement(this) && this.parent.isAtTheVeryRight()
            : true;
    }

    isAtTheVeryTop(): boolean {
        return this.parent
            ? this.parent.isFirstElement(this) && this.parent.isAtTheVeryTop()
            : true;
    }

    isAtTheVeryBottom(): boolean {
        return this.parent
            ? this.parent.isLastElement(this) && this.parent.isAtTheVeryBottom()
            : true;
    }

    isBleedingAtTop(): boolean {
        return false;
    }

    isBleedingAtBottom(): boolean {
        return false;
    }

    isLeftMostElement(_element: CardElement): boolean {
        return true;
    }

    isRightMostElement(_element: CardElement): boolean {
        return true;
    }

    isTopElement(element: CardElement): boolean {
        return this.isFirstElement(element);
    }

    isBottomElement(element: CardElement): boolean {
        return this.isLastElement(element);
    }

    isHiddenDueToOverflow(): boolean {
        return (
            this._renderedElement !== undefined &&
            this._renderedElement.getOpacity() == 0
        );
    }

    getRootElement(): CardElement {
        return this.getRootObject() as CardElement;
    }

    getParentContainer(): Container | undefined {
        let currentElement = this.parent;

        while (currentElement) {
            if (currentElement instanceof Container) {
                return currentElement;
            }

            currentElement = currentElement.parent;
        }

        return undefined;
    }

    getAllInputs(processActions: boolean = true): Input[] {
        return [];
    }

    getAllActions(): Action[] {
        const result: Action[] = [];

        for (let i = 0; i < this.getActionCount(); i++) {
            let action = this.getActionAt(i);

            if (action) {
                result.push(action);
            }
        }

        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        return [];
    }

    getElementById(id: string): CardElement | undefined {
        return this.id === id ? this : undefined;
    }

    getActionById(_id: string): Action | undefined {
        return undefined;
    }
    
    getElementByIdFromAction(id: string): CardElement | undefined {
        let result : CardElement | undefined  = undefined;
        for (let i = 0; i < this.getActionCount(); i++) {
            const action = this.getActionAt(i);
            if (action instanceof ShowCardAction) {
                result = action.card.getElementById(id);
                if (result) {
                    break;
                }
            }
        }
        return result;
    }

    getEffectivePadding(): PaddingDefinition {
        const padding = this.getPadding();

        return padding ? padding : this.getDefaultPadding();
    }

    getEffectiveHorizontalAlignment(): Enums.HorizontalAlignment {
        if (this.horizontalAlignment !== undefined) {
            return this.horizontalAlignment;
        }

        if (this.parent) {
            return this.parent.getEffectiveHorizontalAlignment();
        }

        return Enums.HorizontalAlignment.Left;
    }

    get hostConfig(): HostConfig {
        if (this._hostConfig) {
            return this._hostConfig;
        } else {
            if (this.parent) {
                return this.parent.hostConfig;
            } else {
                return defaultHostConfig;
            }
        }
    }

    set hostConfig(value: HostConfig) {
        this._hostConfig = value;
    }

    get index(): number {
        if (this.parent) {
            return this.parent.indexOf(this);
        } else {
            return 0;
        }
    }

    get isInteractive(): boolean {
        return false;
    }

    get isStandalone(): boolean {
        return true;
    }

    get isInline(): boolean {
        return false;
    }

    get hasVisibleSeparator(): boolean {
        if (this.parent && this.separatorElement) {
            return !this.parent.isFirstElement(this) && (this.isVisible || this.isDesignMode());
        } else {
            return false;
        }
    }

    get separatorElement(): FrameNode | undefined {
        return this._separatorElement;
    }

    get parent(): CardElement | undefined {
        return this._parent as CardElement;
    }
}

export class ActionProperty extends PropertyDefinition {
    forbiddenActionTypes: string[] = [];
    parse(
        sender: SerializableObject,
        source: PropertyBag,
        context: SerializationContext
    ): Action | undefined {
        const parent = sender as CardElement;

        return context.parseAction(
            parent,
            source[this.name],
            this.forbiddenActionTypes,
            parent.isDesignMode()
        );
    }

    toJSON(
        sender: SerializableObject,
        target: PropertyBag,
        value: Action | undefined,
        context: SerializationContext
    ) {
        context.serializeValue(
            target,
            this.name,
            value ? value.toJSON(context) : undefined,
            undefined,
            true
        );
    }

    constructor(
        targetVersion: Version,
        name: string,
        forbiddenActionTypes: string[] = []
    ) {
        super(targetVersion, name, undefined);
        this.forbiddenActionTypes = forbiddenActionTypes
    }
}

export abstract class BaseTextBlock extends CardElement {
    //#region Schema

    static readonly textProperty = new StringProperty(Versions.v1_0, "text", true);
    static readonly sizeProperty = new EnumProperty(Versions.v1_0, "size", Enums.TextSize);
    static readonly weightProperty = new EnumProperty(Versions.v1_0, "weight", Enums.TextWeight);
    static readonly colorProperty = new EnumProperty(Versions.v1_0, "color", Enums.TextColor);
    static readonly isSubtleProperty = new BoolProperty(Versions.v1_0, "isSubtle");
    static readonly fontTypeProperty = new EnumProperty(Versions.v1_2, "fontType", Enums.FontType);
    static readonly selectActionProperty = new ActionProperty(Versions.v1_1, "selectAction", [
        "Action.ShowCard"
    ]);

    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        // selectAction is declared on BaseTextBlock but is only exposed on TextRun,
        // so the property is removed from the BaseTextBlock schema.
        schema.remove(BaseTextBlock.selectActionProperty);
    }

    @property(BaseTextBlock.sizeProperty)
    size?: Enums.TextSize;

    @property(BaseTextBlock.weightProperty)
    weight?: Enums.TextWeight;

    @property(BaseTextBlock.colorProperty)
    color?: Enums.TextColor;

    @property(BaseTextBlock.fontTypeProperty)
    fontType?: Enums.FontType;

    @property(BaseTextBlock.isSubtleProperty)
    isSubtle?: boolean;

    @property(BaseTextBlock.textProperty)
    get text(): string | undefined {
        return this.getValue(BaseTextBlock.textProperty);
    }

    set text(value: string | undefined) {
        this.setText(value);
    }

    @property(BaseTextBlock.selectActionProperty)
    selectAction?: Action;

    //#endregion

    protected getFontSize(fontType: FontTypeDefinition): number {
        switch (this.effectiveSize) {
            case Enums.TextSize.Small:
                return fontType.fontSizes.small;
            case Enums.TextSize.Medium:
                return fontType.fontSizes.medium;
            case Enums.TextSize.Large:
                return fontType.fontSizes.large;
            case Enums.TextSize.ExtraLarge:
                return fontType.fontSizes.extraLarge;
            default:
                return fontType.fontSizes.default;
        }
    }

    protected getColorDefinition(
        colorSet: ColorSetDefinition,
        color: Enums.TextColor
    ): TextColorDefinition {
        switch (color) {
            case Enums.TextColor.Accent:
                return colorSet.accent;
            case Enums.TextColor.Dark:
                return colorSet.dark;
            case Enums.TextColor.Light:
                return colorSet.light;
            case Enums.TextColor.Good:
                return colorSet.good;
            case Enums.TextColor.Warning:
                return colorSet.warning;
            case Enums.TextColor.Attention:
                return colorSet.attention;
            default:
                return colorSet.default;
        }
    }

    protected setText(value: string | undefined) {
        this.setValue(BaseTextBlock.textProperty, value);
    }

    ariaHidden: boolean = false;

    constructor(text?: string) {
        super();

        if (text) {
            this.text = text;
        }
    }

    init(textDefinition: BaseTextDefinition) {
        this.size = textDefinition.size;
        this.weight = textDefinition.weight;
        this.color = textDefinition.color;
        this.isSubtle = textDefinition.isSubtle;
    }

    asString(): string | undefined {
        return this.text;
    }

    applyStylesTo(targetElement: ESObject) {
        const fontType = this.hostConfig.getFontTypeDefinition(this.effectiveFontType);

        if (fontType.fontFamily) {
            targetElement.attribute.fontFamily(fontType.fontFamily)
        }

        let fontSize: number;

        switch (this.effectiveSize) {
            case Enums.TextSize.Small:
                fontSize = fontType.fontSizes.small;
                break;
            case Enums.TextSize.Medium:
                fontSize = fontType.fontSizes.medium;
                break;
            case Enums.TextSize.Large:
                fontSize = fontType.fontSizes.large;
                break;
            case Enums.TextSize.ExtraLarge:
                fontSize = fontType.fontSizes.extraLarge;
                break;
            default:
                fontSize = fontType.fontSizes.default;
                break;
        }
        targetElement.attribute.fontSize(fontSize);

        const colorDefinition = this.getColorDefinition(
            this.getEffectiveStyleDefinition().foregroundColors,
            this.effectiveColor
        );

        const targetColor = Utils.stringToCssColor(
            this.effectiveIsSubtle ? colorDefinition.subtle : colorDefinition.default
        );
        if (targetColor) {
            targetElement.attribute.fontColor(targetColor)
        }

        let fontWeight: number;

        switch (this.effectiveWeight) {
            case Enums.TextWeight.Lighter:
                fontWeight = fontType.fontWeights.lighter;
                break;
            case Enums.TextWeight.Bolder:
                fontWeight = fontType.fontWeights.bolder;
                break;
            default:
                fontWeight = fontType.fontWeights.default;
                break;
        }

        targetElement.attribute.fontWeight(fontWeight);
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        if (this.selectAction) {
            result.push(this.selectAction);
        }

        return result;
    }

    get effectiveColor(): Enums.TextColor {
        return this.color !== undefined ? this.color : this.getEffectiveTextStyleDefinition().color;
    }

    get effectiveFontType(): Enums.FontType {
        return this.fontType !== undefined
            ? this.fontType
            : this.getEffectiveTextStyleDefinition().fontType;
    }

    get effectiveIsSubtle(): boolean {
        return this.isSubtle !== undefined
            ? this.isSubtle
            : this.getEffectiveTextStyleDefinition().isSubtle;
    }

    get effectiveSize(): Enums.TextSize {
        return this.size !== undefined ? this.size : this.getEffectiveTextStyleDefinition().size;
    }

    get effectiveWeight(): Enums.TextWeight {
        return this.weight !== undefined
            ? this.weight
            : this.getEffectiveTextStyleDefinition().weight;
    }
}

export type TextBlockStyle = "default" | "heading" | "columnHeader";

export class TextBlock extends BaseTextBlock {
//#region Schema

    static readonly wrapProperty = new BoolProperty(Versions.v1_0, "wrap", false);
    static readonly maxLinesProperty = new NumProperty(Versions.v1_0, "maxLines");
    static readonly styleProperty = new ValueSetProperty(Versions.v1_5, "style", [
        { value: "default" },
        { value: "columnHeader" },
        { value: "heading" }
    ]);

    @property(TextBlock.wrapProperty)
    wrap: boolean = false;

    @property(TextBlock.maxLinesProperty)
    maxLines?: number;

    @property(TextBlock.styleProperty)
    style?: TextBlockStyle;

    //#endregion

    private _computedLineHeight: number = 0;
    private _originalInnerHtml: string = "";
    private _processedText?: string;
    private _treatAsPlainText: boolean = true;

    private restoreOriginalContent() {
        if (this.renderedElement !== undefined) {
            if (this.maxLines && this.maxLines > 0) {
                this.renderedElement.commonAttribute.constraintSize({
                    maxHeight: this._computedLineHeight * this.maxLines
                })
            }

            const originalHtml: string = this._originalInnerHtml;
            (this.renderedElement as typeNode.Text).initialize(originalHtml);
        }
    }

    private truncateIfSupported(maxHeight: number): boolean {
        if (this.renderedElement !== undefined) {
            // For now, only truncate TextBlocks that contain just a single
            // paragraph -- since the maxLines calculation doesn't take into
            // account Markdown lists
            const firstChild: FrameNode | null = this.renderedElement.getFirstChild();
            const childrenCount: number = this.renderedElement.getChildrenCount();
            const isTextOnly = childrenCount === 0 ? true : false;
            const truncationSupported = isTextOnly || (childrenCount === 1 && firstChild?.getNodeType().toLowerCase() === "Text" && !firstChild.getChildrenCount());

            if (truncationSupported) {
                const element: FrameNode | null = isTextOnly ? this.renderedElement : firstChild;

                Utils.truncateText(element, maxHeight, this._computedLineHeight);

                return true;
            }
        }

        return false;
    }

    protected setText(value: string) {
        super.setText(value);

        this._processedText = undefined;
    }

    protected internalRender(context: UIContext): FrameNode | undefined {
        this._processedText = undefined;

        if (this.text) {
            const preProcessedText: ESObject = this.preProcessPropertyValue(BaseTextBlock.textProperty);
            const hostConfig = this.hostConfig;

            let element: typeNode.Text = typeNode.createNode(context, "Text");

            // 源库中，如果element是label，则创建label标签，文字样式作用于label
            // 如果是textBlock等，则创建div，下面的markdown处理后自动加上p标签，样式作用于div
            // 鸿蒙中不允许将font等Text组件的样式直接作用于Column，为了保持层级一致，做了一些改动


            element.attribute.textOverflow({ overflow: TextOverflow.Ellipsis });

            this.applyStylesTo(element);

            if (this.style === "heading") {

                const headingLevel = this.hostConfig.textBlock.headingLevel;

                if (headingLevel !== undefined && headingLevel > 0) {

                }
            }

            if (this.selectAction && hostConfig.supportsInteractivity) {
                element.commonEvent.setOnClick((e: ClickEvent)=>{
                    if (this.selectAction && this.selectAction.isEffectivelyEnabled()) {
                        this.selectAction.execute(context);
                    }
                })

                this.selectAction.setupElementForAccessibility(element);

                if (this.selectAction.isEffectivelyEnabled()) {
                    element.attribute.padding(0);
                    element.commonEvent.setOnHover(()=>{
                        element.attribute.backgroundColor("rgba(0, 0, 0, 0.1)");
                    })
                }
            }

            if (!this._processedText) {
                this._treatAsPlainText = true;

                let formattedText = TextFormatters.formatText(this.lang, preProcessedText);

                if (this.useMarkdown && formattedText) {
                    if (GlobalSettings.allowMarkForTextHighlighting) {
                        formattedText = formattedText
                            .replace(/<mark>/g, "===")
                            .replace(/<\/mark>/g, "/==/");
                    }

                    const markdownProcessingResult: ESObject = AdaptiveCard.applyMarkdown(formattedText);

                    if (
                        markdownProcessingResult.didProcess &&
                        markdownProcessingResult.outputHtml
                    ) {
                        this._processedText = markdownProcessingResult.outputHtml;
                        this._treatAsPlainText = false;

                        // Only process <mark> tag if markdown processing was applied because
                        // markdown processing is also responsible for sanitizing the input string
                        if (GlobalSettings.allowMarkForTextHighlighting && this._processedText) {
                            let markStyle: string = "";
                            const effectiveStyle = this.getEffectiveStyleDefinition();

                            if (effectiveStyle.highlightBackgroundColor) {
                                markStyle +=
                                    "background-color: " +
                                    effectiveStyle.highlightBackgroundColor +
                                    ";";
                            }

                            if (effectiveStyle.highlightForegroundColor) {
                                markStyle +=
                                    "color: " + effectiveStyle.highlightForegroundColor + ";";
                            }

                            if (markStyle) {
                                markStyle = 'style="' + markStyle + '"';
                            }

                            this._processedText = this._processedText
                                .replace(/===/g, "<mark " + markStyle + ">")
                                .replace(/\/==\//g, "</mark>");
                        }
                    } else {
                        this._processedText = formattedText;
                        this._treatAsPlainText = true;
                    }
                } else {
                    this._processedText = formattedText;
                    this._treatAsPlainText = true;
                }
            }

            if (!this._processedText) {
                this._processedText = "";
            }

            if (this._treatAsPlainText) {
                element.initialize(this._processedText);
            } else {
                const processedHtml: string =  this._processedText;

                element.initialize(processedHtml);
            }

            if (element.getNodeType() === "Text") {
                element?.commonAttribute.margin({ top: 0});
                //修复文本不左对齐问题
                // element?.commonAttribute.width("100%");

                if (!this.wrap) {
                    if(element.getNodeType() === "Text"){
                        (element as typeNode.Text).attribute.maxLines(1);
                    }
                    element?.attribute.textOverflow({ overflow: TextOverflow.Ellipsis});
                }
            }

            if (element.getFirstChild() instanceof FrameNode) {
                element.getFirstChild()?.commonAttribute.margin({ bottom: 0})
            }

            if (this.wrap) {
                element.attribute.wordBreak(WordBreak.BREAK_WORD)

                if (this.maxLines && this.maxLines > 0) {
                    element.attribute.constraintSize({ maxHeight: this._computedLineHeight * this.maxLines });
                    element.attribute.maxLines(this.maxLines);
                    element.attribute.textOverflow({ overflow: TextOverflow.Ellipsis });
                }
            } else {
                element.attribute.maxLines(1);
                element.attribute.textOverflow({ overflow: TextOverflow.Ellipsis });
            }

            if (
                GlobalSettings.useAdvancedTextBlockTruncation ||
                GlobalSettings.useAdvancedCardBottomTruncation
            ) {
                this._originalInnerHtml = this.text;
            }

            if (!this.forElementId) {
                const column = typeNode.createNode(context, "Column");
                switch (this.getEffectiveHorizontalAlignment()) {
                    case Enums.HorizontalAlignment.Center:
                        column.attribute.alignItems(HorizontalAlign.Center);
                        break;
                    case Enums.HorizontalAlignment.Right:
                        column.attribute.alignItems(HorizontalAlign.End);
                        break;
                    default:
                        column.attribute.alignItems(HorizontalAlign.Start);
                        break;
                }
                column.appendChild(element);
                return column
            }
            return element;
        } else {
            return undefined;
        }
    }

    protected truncateOverflow(maxHeight: number): boolean {
        if (maxHeight >= this._computedLineHeight) {
            return this.truncateIfSupported(maxHeight);
        }

        return false;
    }

    protected undoOverflowTruncation() {
        this.restoreOriginalContent();

        if (GlobalSettings.useAdvancedTextBlockTruncation && this.maxLines) {
            const maxHeight = this._computedLineHeight * this.maxLines;

            this.truncateIfSupported(maxHeight);
        }
    }

    useMarkdown: boolean = true;
    forElementId?: string;

    applyStylesTo(targetElement: typeNode.Text) {
        super.applyStylesTo(targetElement);

        switch (this.getEffectiveHorizontalAlignment()) {
            case Enums.HorizontalAlignment.Center:
                targetElement.attribute.textAlign(TextAlign.Center)
                break;
            case Enums.HorizontalAlignment.Right:
                targetElement.attribute.textAlign(TextAlign.End)
                break;
            default:
                targetElement.attribute.textAlign(TextAlign.Start)
                break;
        }

        const lineHeights = this.hostConfig.lineHeights;

        if (lineHeights) {
            switch (this.effectiveSize) {
                case Enums.TextSize.Small:
                    this._computedLineHeight = lineHeights.small;
                    break;
                case Enums.TextSize.Medium:
                    this._computedLineHeight = lineHeights.medium;
                    break;
                case Enums.TextSize.Large:
                    this._computedLineHeight = lineHeights.large;
                    break;
                case Enums.TextSize.ExtraLarge:
                    this._computedLineHeight = lineHeights.extraLarge;
                    break;
                default:
                    this._computedLineHeight = lineHeights.default;
                    break;
            }
        } else {
            // Looks like 1.33 is the magic number to compute line-height
            // from font size.
            this._computedLineHeight =
                this.getFontSize(this.hostConfig.getFontTypeDefinition(this.effectiveFontType)) *
                1.33;
        }
        targetElement.attribute.lineHeight(this._computedLineHeight)
    }

    getJsonTypeName(): string {
        return "TextBlock";
    }

    getEffectiveTextStyleDefinition(): TextStyleDefinition {
        if (this.style) {
            return this.hostConfig.textStyles.getStyleByName(this.style);
        }

        return super.getEffectiveTextStyleDefinition();
    }

    updateLayout(processChildren: boolean = false) {
        super.updateLayout(processChildren);

        if (GlobalSettings.useAdvancedTextBlockTruncation && this.maxLines && this.isDisplayed()) {
            // Reset the element's innerHTML in case the available room for
            // content has increased
            this.restoreOriginalContent();
            this.truncateIfSupported(this._computedLineHeight * this.maxLines);
        }
    }
}

export class TextRun extends BaseTextBlock {
    //#region Schema

    static readonly italicProperty = new BoolProperty(Versions.v1_2, "italic", false);
    static readonly strikethroughProperty = new BoolProperty(Versions.v1_2, "strikethrough", false);
    static readonly highlightProperty = new BoolProperty(Versions.v1_2, "highlight", false);
    static readonly underlineProperty = new BoolProperty(Versions.v1_3, "underline", false);

    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        schema.add(BaseTextBlock.selectActionProperty);
    }

    @property(TextRun.italicProperty)
    italic: boolean = false;

    @property(TextRun.strikethroughProperty)
    strikethrough: boolean = false;

    @property(TextRun.highlightProperty)
    highlight: boolean = false;

    @property(TextRun.underlineProperty)
    underline: boolean = false;

    //#endregion

    protected internalRender(context: UIContext): FrameNode | undefined {
        if (this.text) {
            const preProcessedText: string = this.preProcessPropertyValue(BaseTextBlock.textProperty);
            const hostConfig = this.hostConfig;

            let formattedText = TextFormatters.formatText(this.lang, preProcessedText);

            if (!formattedText) {
                formattedText = "";
            }

            const element = typeNode.createNode(context, "Text");
            if(this.selectAction) {
                element.attribute.decoration({ type: TextDecorationType.Underline });
            }
            element.initialize(formattedText);

            this.applyStylesTo(element);

            if (this.selectAction && hostConfig.supportsInteractivity) {
                const href = this.selectAction.getHref();

                element.attribute.fontColor("#4007A2");
                element.commonEvent.setOnClick((e: ClickEvent) => {
                    if (this.selectAction && this.selectAction.isEffectivelyEnabled()) {
                        this.selectAction.execute(context);
                    }
                })

                this.selectAction.setupElementForAccessibility(element);
            }

            return element;
        } else {
            return undefined;
        }
    }

    applyStylesTo(targetElement: typeNode.Text) {
        super.applyStylesTo(targetElement);

        if (this.italic) {
            targetElement.attribute.fontStyle(FontStyle.Italic);
        }

        if (this.strikethrough) {
            targetElement.attribute.decoration({ type: TextDecorationType.LineThrough });
        }

        if (this.highlight) {
            const colorDefinition = this.getColorDefinition(
                this.getEffectiveStyleDefinition().foregroundColors,
                this.effectiveColor
            );

            const backgroundColor = Utils.stringToCssColor(
                this.effectiveIsSubtle
                    ? colorDefinition.highlightColors.subtle
                    : colorDefinition.highlightColors.default
            );
            if (backgroundColor) {
                targetElement.commonAttribute.backgroundColor(backgroundColor);
            }
        }

        if (this.underline) {
            targetElement.attribute.decoration({ type: TextDecorationType.Underline });
        }
    }

    getJsonTypeName(): string {
        return "TextRun";
    }

    get isStandalone(): boolean {
        return false;
    }

    get isInline(): boolean {
        return true;
    }
}

export class RichTextBlock extends CardElement {
    private _inlines: CardElement[] = [];

    private internalAddInline(inline: CardElement, forceAdd: boolean = false) {
        if (!inline.isInline) {
            throw new Error(Strings.errors.elementCannotBeUsedAsInline());
        }

        const doAdd: boolean = inline.parent === undefined || forceAdd;

        if (!doAdd && inline.parent !== this) {
            throw new Error(Strings.errors.inlineAlreadyParented());
        } else {
            inline.setParent(this);

            this._inlines.push(inline);
        }
    }

    protected internalParse(source: ESObject, context: SerializationContext) {
        super.internalParse(source, context);

        this._inlines = [];

        if (Array.isArray(source["inlines"])) {
            for(let i = 0; i < source["inlines"].length; i++ ){
                let jsonInline: ESObject = source["inlines"][i];
                let inline: CardElement | undefined;

                if (typeof jsonInline === "string") {
                    const textRun = new TextRun();
                    textRun.text = jsonInline;

                    inline = textRun;
                } else {
                    // No fallback for inlines in 1.2
                    inline = context.parseElement(this, jsonInline, [], false);
                }

                if (inline) {
                    this.internalAddInline(inline, true);
                }
            }
        }
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        if (this._inlines.length > 0) {
            const jsonInlines: ESObject[] = [];

            for (const inline of this._inlines) {
                jsonInlines.push(inline.toJSON(context));
            }

            context.serializeValue(target, "inlines", jsonInlines);
        }
    }

    protected internalRender(context: UIContext): FrameNode | undefined {
        if (this._inlines.length > 0) {
            let element: typeNode.Flex | typeNode.Row;

            if (this.forElementId) {
                const labelElement = typeNode.createNode(context, "Row");
                element = labelElement;
                switch (this.getEffectiveHorizontalAlignment()) {
                    case Enums.HorizontalAlignment.Center:
                        element.attribute.justifyContent(FlexAlign.Center);
                        break;
                    case Enums.HorizontalAlignment.Right:
                        element.attribute.justifyContent(FlexAlign.End);
                        break;
                    default:
                        element.attribute.justifyContent(FlexAlign.Start);
                        break;
                }
            } else {
                element = typeNode.createNode(context, "Flex");
                element.attribute.width("100%");
                let option: FlexOptions = { wrap: FlexWrap.Wrap , direction:FlexDirection.Row};
                switch (this.getEffectiveHorizontalAlignment()) {
                    case Enums.HorizontalAlignment.Center:
                        option.justifyContent =FlexAlign.Center;
                        break;
                    case Enums.HorizontalAlignment.Right:
                        option.justifyContent =FlexAlign.End;
                        break;
                    default:
                        option.justifyContent =FlexAlign.Start;
                        break;
                }
                element.initialize(option);
            }

            let renderedInlines: number = 0;

            for (const inline of this._inlines) {

                const renderedInline = inline.render(context);
                if (renderedInline) {
                    element.appendChild(renderedInline);

                    renderedInlines++;

                }
            }

            if (renderedInlines > 0) {
                return element;
            }
        }

        return undefined;
    }

    forElementId?: string;

    asString(): string | undefined {
        let result = "";

        for (const inline of this._inlines) {
            result += inline.asString();
        }

        return result;
    }

    getJsonTypeName(): string {
        return "RichTextBlock";
    }

    getInlineCount(): number {
        return this._inlines.length;
    }

    getInlineAt(index: number): CardElement {
        if (index >= 0 && index < this._inlines.length) {
            return this._inlines[index];
        } else {
            throw new Error(Strings.errors.indexOutOfRange(index));
        }
    }

    addInline(inline: CardElement | string) {
        if (typeof inline === "string") {
            this.internalAddInline(new TextRun(inline));
        } else {
            this.internalAddInline(inline);
        }
    }

    removeInline(inline: CardElement): boolean {
        const index = this._inlines.indexOf(inline);

        if (index >= 0) {
            this._inlines[index].setParent(undefined);
            this._inlines.splice(index, 1);

            return true;
        }

        return false;
    }
}

export class Fact extends SerializableObject {
    //#region Schema

    static readonly titleProperty = new StringProperty(Versions.v1_0, "title");
    static readonly valueProperty = new StringProperty(Versions.v1_0, "value");

    // For historic reasons, the "title" schema property is exposed as "name" in the OM.
    @property(Fact.titleProperty)
    name?: string;

    @property(Fact.valueProperty)
    value?: string;

    //#endregion

    protected getSchemaKey(): string {
        return "Fact";
    }

    constructor(name?: string, value?: string) {
        super();

        this.name = name;
        this.value = value;
    }
}

export class FactSet extends CardElement {
    //#region Schema

    static readonly factsProperty = new SerializableObjectCollectionProperty(
        Versions.v1_0,
        "facts",
        Fact
    );

    @property(FactSet.factsProperty)
    facts: Fact[]=  [];

    //#endregion

    protected get useDefaultSizing(): boolean {
        return false;
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        let element: typeNode.Column | undefined;
        const hostConfig = this.hostConfig;

        if (this.facts.length > 0) {
            element = typeNode.createNode(context,"Column");
            element.attribute.alignItems(HorizontalAlign.Start)
            element.commonAttribute.align(Alignment.Start)
            if(this.minPixelWidth) {
                element.commonAttribute.constraintSize({
                    minWidth: this.minPixelWidth,
                })
            }
            for (let i = 0; i < this.facts.length; i++) {
                const trElement = typeNode.createNode(context,"Flex");
                trElement.attribute.width("auto")

                if (i > 0) {
                    trElement.commonAttribute.margin({top:hostConfig.factSet.spacing});
                }

                // Title column
                let tdElement = typeNode.createNode(context,"Row");
                tdElement.commonAttribute.padding(0);

                if (hostConfig.factSet.title.maxWidth) {
                    tdElement.commonAttribute.constraintSize({maxWidth:hostConfig.factSet.title.maxWidth});
                }

                tdElement.attribute.alignItems(VerticalAlign.Top);

                let textBlock = new TextBlock();
                textBlock.setParent(this);
                textBlock.text =
                    !this.facts[i].name && this.isDesignMode() ? "Title" : this.facts[i].name;
                textBlock.size = hostConfig.factSet.title.size;
                textBlock.color = hostConfig.factSet.title.color;
                textBlock.isSubtle = hostConfig.factSet.title.isSubtle;
                textBlock.weight = hostConfig.factSet.title.weight;
                textBlock.wrap = hostConfig.factSet.title.wrap;
                textBlock.spacing = Enums.Spacing.None;

                Utils.appendChild(tdElement, textBlock.render(context));
                Utils.appendChild(trElement, tdElement);

                // Spacer column
                tdElement = typeNode.createNode(context,"Row");
                tdElement.commonAttribute.width(10);

                Utils.appendChild(trElement, tdElement);

                // Value column
                tdElement = typeNode.createNode(context,"Row");
                tdElement.commonAttribute.padding(0);
                tdElement.attribute.alignItems(VerticalAlign.Top);

                textBlock = new TextBlock();
                textBlock.setParent(this);
                textBlock.text = this.facts[i].value;
                textBlock.size = hostConfig.factSet.value.size;
                textBlock.color = hostConfig.factSet.value.color;
                textBlock.isSubtle = hostConfig.factSet.value.isSubtle;
                textBlock.weight = hostConfig.factSet.value.weight;
                textBlock.wrap = hostConfig.factSet.value.wrap;
                textBlock.spacing = Enums.Spacing.None;

                Utils.appendChild(tdElement, textBlock.render(context));
                Utils.appendChild(trElement, tdElement);
                Utils.appendChild(element, trElement);
            }
        }

        return element;
    }

    getJsonTypeName(): string {
        return "FactSet";
    }
}

class ImageDimensionProperty extends PropertyDefinition {

    private internalName : string = "";
    private fallbackProperty?: ValueSetProperty;

    getInternalName(): string {
        return this.internalName;
    }

    parse(
        sender: SerializableObject,
        source: PropertyBag,
        context: BaseSerializationContext
    ): number | undefined {
        let result: number | undefined = undefined;
        const sourceValue = source[this.name] as string;

        if (sourceValue === undefined) {
            return this.defaultValue;
        }

        let isValid = false;

        if (typeof sourceValue === "string") {
            try {
                const size = SizeAndUnit.parse(sourceValue, true);

                if (size.unit === Enums.SizeUnit.Pixel) {
                    result = size.physicalSize;

                    isValid = true;
                }
            } catch {
                // Swallow the exception
            }

            // If the source value isn't valid per this property definition,
            // check its validity per the fallback property, if specified
            if (!isValid && this.fallbackProperty) {
                isValid = this.fallbackProperty.isValidValue(sourceValue, context);
            }
        }

        if (!isValid) {
            context.logParseEvent(
                sender,
                Enums.ValidationEvent.InvalidPropertyValue,
                Strings.errors.invalidPropertyValue(sourceValue, this.name)
            );
        }

        return result;
    }

    toJSON(
        sender: SerializableObject,
        target: PropertyBag,
        value: number | undefined,
        context: BaseSerializationContext
    ) {
        context.serializeValue(
            target,
            this.name,
            typeof value === "number" && !isNaN(value) ? value + "px" : undefined
        );
    }

    constructor(
        targetVersion: Version,
        name: string,
        internalName: string,
        fallbackProperty?: ValueSetProperty
    ) {
        super(targetVersion, name);
        this.internalName = internalName;
        this.fallbackProperty = fallbackProperty;
    }
}

export class Image extends CardElement {
    //#region Schema

    static readonly urlProperty = new StringProperty(Versions.v1_0, "url");
    static readonly altTextProperty = new StringProperty(Versions.v1_0, "altText");
    static readonly backgroundColorProperty = new StringProperty(Versions.v1_1, "backgroundColor");
    static readonly styleProperty = new EnumProperty(
        Versions.v1_0,
        "style",
        Enums.ImageStyle,
        Enums.ImageStyle.Default
    );
    static readonly sizeProperty = new EnumProperty(
        Versions.v1_0,
        "size",
        Enums.Size,
        Enums.Size.Auto
    );
    static readonly pixelWidthProperty = new ImageDimensionProperty(
        Versions.v1_1,
        "width",
        "pixelWidth"
    );
    static readonly pixelHeightProperty = new ImageDimensionProperty(
        Versions.v1_1,
        "height",
        "pixelHeight",
        CardElement.heightProperty
    );
    static readonly selectActionProperty = new ActionProperty(Versions.v1_1, "selectAction", [
        "Action.ShowCard"
    ]);
    static readonly shouldForceLoadProperty = new BoolProperty(Versions.v1_6, "forceLoad", false);

    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        schema.remove(CardElement.heightProperty);
    }

    public renderedImageElement?: FrameNode;

    @property(Image.urlProperty)
    url?: string;

    @property(Image.altTextProperty)
    altText?: string;

    @property(Image.backgroundColorProperty)
    backgroundColor?: string;

    @property(Image.sizeProperty)
    size: Enums.Size = Enums.Size.Auto;

    @property(Image.styleProperty)
    style: Enums.ImageStyle = Enums.ImageStyle.Default;

    @property(Image.pixelWidthProperty)
    pixelWidth: number = 0;

    @property(Image.pixelHeightProperty)
    pixelHeight?: number;

    @property(Image.selectActionProperty)
    selectAction?: Action;

    @property(Image.shouldForceLoadProperty)
    forceLoad?: boolean;

    //#endregion

    private imgWidth : number | undefined = 0;

    private imgHeight : number | undefined = 0;

    private applySize(element: FrameNode) {
        if (this.pixelWidth || this.pixelHeight) {
            if (this.pixelWidth) {
                // element.style.width = this.pixelWidth + "px";
                element.commonAttribute.width(this.pixelWidth)
            }

            if (this.pixelHeight) {
                // element.style.height = this.pixelHeight + "px";
                element.commonAttribute.height(this.pixelHeight)
            }
        } else {
            if (this.maxHeight) {
                // If the image is constrained in height, we set its height property and
                // auto and stretch are ignored (default to medium). THis is necessary for
                // ImageSet which uses a maximum image height as opposed to the cards width
                // as a constraining dimension
                element.commonAttribute.height(this.hostConfig.getEffectiveImageSize(this.size))
                element.commonAttribute.constraintSize({maxHeight:this.maxHeight});
            } else {
                switch (this.size) {
                    case Enums.Size.Stretch:
                        element.commonAttribute.width('100%')
                        break;
                    case Enums.Size.Auto:
                        if(element.getNodeType() == "Image") {
                            element.commonAttribute.width(this.imgWidth);
                            element.commonAttribute.height(this.imgHeight);
                        }
                        break
                    default:
                        element.commonAttribute.width(this.hostConfig.getEffectiveImageSize(this.size))
                        break;
                }
                element.commonAttribute.constraintSize({maxHeight:'100%'});
            }
        }
    }

    protected get useDefaultSizing() {
        return false;
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        let element: typeNode.Flex | undefined = undefined;
        if (this.url) {
            element = typeNode.createNode(context,"Flex");
            if(this.pixelWidth) {
                element.attribute.width(this.pixelWidth);
            } else {
                element.attribute.width('auto');
            }
            if(this.pixelHeight) {
                element.attribute.height(this.pixelHeight);
            } else {
                element.attribute.height('auto');
            }
            // Cache hostConfig to avoid walking the parent hierarchy multiple times
            const hostConfig = this.hostConfig;

            switch (this.getEffectiveHorizontalAlignment()) {
                case Enums.HorizontalAlignment.Center:
                    element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.Center});
                    break;
                case Enums.HorizontalAlignment.Right:
                    element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.End});
                    break;
                default:
                    element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.Start});
                    break;
            }
            const imageElement = typeNode.createNode(context,"Image");
            this.renderedImageElement = imageElement;
            imageElement.attribute.objectFit(ImageFit.Contain);
            let url = this.setImageSource();
            let initializeUrl = imageElement.initialize(url);
            initializeUrl.onComplete((e)=>{
                this.imgWidth = e?.width;
                this.imgHeight = e?.height;
                this.applySize(imageElement);
                LogUtils.getInstance().info("image onComplete w "+e?.width+" h "+e?.height)
                raiseImageLoadedEvent(this);
            })
            initializeUrl.onError((error: ImageError)=>{
                LogUtils.getInstance().info("image onError" + JSON.stringify(error))
                if (this.renderedElement) {
                    const card = this.getRootElement() as AdaptiveCard;

                    clearElement(this.renderedElement);
                    if (card && card.designMode) {
                        const errorElement = typeNode.createNode(context, "Flex");
                        errorElement.initialize({alignItems:ItemAlign.Center, justifyContent:FlexAlign.Center})
                        errorElement.attribute.align(Alignment.Center);
                        errorElement.attribute.backgroundColor("#EEEEEE");
                        errorElement.attribute.foregroundColor("#000000");
                        errorElement.attribute.padding(10);
                        this.applySize(errorElement);
                        this.renderedElement.appendChild(errorElement);
                    }
                    else {
                        const altTextProperty = this.preProcessPropertyValue(Image.altTextProperty) as string;
                        if (altTextProperty && altTextProperty.length > 0) {
                            const errorElement = typeNode.createNode(context, "Text");
                            errorElement.attribute.align(Alignment.Center);
                            errorElement.attribute.backgroundColor("#EEEEEE");
                            errorElement.attribute.foregroundColor("#000000");
                            errorElement.attribute.padding(10);
                            errorElement.initialize(altTextProperty);
                            this.applySize(errorElement);
                            this.renderedElement.appendChild(errorElement);
                        }
                    }
                }

                raiseImageLoadedEvent(this);
            })

            imageElement.commonAttribute.constraintSize({minWidth:0});

            if (this.selectAction && hostConfig.supportsInteractivity) {

                imageElement.commonEvent.setOnKeyEvent((e)=>{
                    if (
                        this.selectAction &&
                        this.selectAction.isEffectivelyEnabled() &&
                            (e.keyText === "Enter" || e.keyText === "Space")
                    ) {
                        this.selectAction.execute(context);
                    }
                })

                imageElement.commonEvent.setOnClick((e)=>{
                    if (this.selectAction && this.selectAction.isEffectivelyEnabled()) {
                        this.selectAction.execute(context);
                    }
                })

                this.selectAction.setupElementForAccessibility(imageElement);

            }


            if (this.style === Enums.ImageStyle.Person) {
                if(this.pixelWidth > 0) {
                    imageElement.attribute.borderRadius(this.pixelWidth/2);
                } else {
                    if(this.imgWidth! > 0) {
                        imageElement.attribute.borderRadius((this.imgWidth!)/2);
                    }
                }
                imageElement.attribute.backgroundImagePosition(Alignment.Center);
                imageElement.attribute.objectRepeat(ImageRepeat.NoRepeat);
            }

            const backgroundColor = Utils.stringToCssColor(this.backgroundColor);
            if (backgroundColor) {
                imageElement.attribute.backgroundColor(backgroundColor);
            }
            element.appendChild(imageElement);
        }

        return element;
    }

    maxHeight?: number;

    getJsonTypeName(): string {
        return "Image";
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        if (this.selectAction) {
            result.push(this.selectAction);
        }

        return result;
    }

    getActionById(id: string) {
        let result = super.getActionById(id);
        if (!result && this.selectAction) {
            result = this.selectAction.getActionById(id);
        }
        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        return this.url ? [{ url: this.url, mimeType: "image" }] : [];
    }

    private setImageSource(): string {
        const imageForceLoader: ImageForceLoader = new ImageForceLoader(this.forceLoad, this.url);
        imageForceLoader.configureImage(this);
        let url = this.preProcessPropertyValue(Image.urlProperty) as string;
        imageForceLoader.resetImage(this);
        return url;
    }
}

// configures Image element to fetch a new image data from url source instead of relying on cache
// currently rudimentary refreshing scheme is used
// by attaching unique query string to url, we bypass the cache usage
class ImageForceLoader{
    private uniqueHash : string = "";
    public readonly urlWithForceLoadOption : string = "";
    private url : string | undefined = ""
    constructor(
         doForceLoad: boolean | undefined,
         url : string | undefined,
    )
    {
        this.url = url;
        if (url && url.length && doForceLoad) {
            // we can do better by appending unique key such as uuid instead of epoch
            // however the current usage is for front-end ui and networking,
            // since ui is running in single main thread, this is sufficient mechanism
            // without needing to depend on external library for our small use cases.
            this.uniqueHash = '?' + Date.now();
            this.urlWithForceLoadOption = url + this.uniqueHash;
        }
    }

    public configureImage(image: Image): void {
        if (this.urlWithForceLoadOption && this.urlWithForceLoadOption.length) {
            image.url = this.urlWithForceLoadOption;
        }
    }

    public resetImage(image: Image): void {
        image.url = this.url;
    }
}

export abstract class CardElementContainer extends CardElement {
    //#region Schema

    static readonly selectActionProperty = new ActionProperty(Versions.v1_1, "selectAction", [
        "Action.ShowCard"
    ]);

    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        if (!this.isSelectable) {
            schema.remove(CardElementContainer.selectActionProperty);
        }
    }

    @property(CardElementContainer.selectActionProperty)
    protected _selectAction?: Action;

    //#endregion

    protected isElementAllowed(element: CardElement) {
        return this.hostConfig.supportsInteractivity || !element.isInteractive;
    }

    protected applyPadding() {
        super.applyPadding();

        if (!this.renderedElement) {
            return;
        }

        let physicalPadding = new SpacingDefinition();

        if (this.getEffectivePadding()) {
            physicalPadding = this.hostConfig.paddingDefinitionToSpacingDefinition(
                this.getEffectivePadding()
            );
        }
        this.renderedElement.commonAttribute.padding({top:physicalPadding.top, right:physicalPadding.right, bottom:physicalPadding.bottom, left:physicalPadding.left});
        this.renderedElement.commonAttribute.margin({left:0, right:0});
    }

    protected get isSelectable(): boolean {
        return false;
    }

    protected forbiddenChildElements(): string[] {
        return [];
    }

    abstract getItemCount(): number;
    abstract getItemAt(index: number): CardElement;
    abstract getFirstVisibleRenderedItem(): CardElement | undefined;
    abstract getLastVisibleRenderedItem(): CardElement | undefined;
    abstract removeItem(item: CardElement): boolean;

    allowVerticalOverflow: boolean = false;

    releaseDOMResources() {
        super.releaseDOMResources();

        for (let i = 0; i < this.getItemCount(); i++) {
            this.getItemAt(i).releaseDOMResources();
        }
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        for (let i = 0; i < this.getItemCount(); i++) {
            const item = this.getItemAt(i);

            if (!this.hostConfig.supportsInteractivity && item.isInteractive) {
                context.addFailure(
                    this,
                    Enums.ValidationEvent.InteractivityNotAllowed,
                    Strings.errors.interactivityNotAllowed()
                );
            }

            if (!this.isElementAllowed(item)) {
                context.addFailure(
                    this,
                    Enums.ValidationEvent.InteractivityNotAllowed,
                    Strings.errors.elementTypeNotAllowed(item.getJsonTypeName())
                );
            }

            item.internalValidateProperties(context);
        }

        if (this._selectAction) {
            this._selectAction.internalValidateProperties(context);
        }
    }

    render(context:UIContext): FrameNode | undefined {
        const element = super.render(context);

        if (element) {
            const hostConfig = this.hostConfig;

            if (
                element &&
                this.isSelectable &&
                this._selectAction &&
                hostConfig.supportsInteractivity
            ) {
                element.commonAttribute.onClick((e)=>{
                    try {
                        if (this._selectAction && this._selectAction.isEffectivelyEnabled()) {
                            this._selectAction.execute(context);
                        }
                    }catch (e) {
                    }
                })

                element.commonAttribute.onKeyEvent((e)=>{
                    if (
                        this._selectAction &&
                        this._selectAction.isEffectivelyEnabled() &&
                            (e.keyText === "Enter" || e.keyText === "Space")
                    ) {
                        this._selectAction.execute(context);
                    }
                })

                this._selectAction.setupElementForAccessibility(element);

            }
        }

        return element;
    }

    updateLayout(processChildren: boolean = true) {
        super.updateLayout(processChildren);

        if (processChildren) {
            for (let i = 0; i < this.getItemCount(); i++) {
                this.getItemAt(i).updateLayout();
            }
        }
    }
    getAllInputs(processActions: boolean = true): Input[] {
        let result: Input[] = [];
        for (let i = 0; i < this.getItemCount(); i++) {
            result.push(...this.getItemAt(i).getAllInputs(processActions));
        }
        return result;
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        for (let i = 0; i < this.getItemCount(); i++) {
            result.push(...this.getItemAt(i).getAllActions());
        }

        if (this._selectAction) {
            result.push(this._selectAction);
        }

        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        let result: IResourceInformation[] = [];

        for (let i = 0; i < this.getItemCount(); i++) {
            result.push(...this.getItemAt(i).getResourceInformation());
        }

        return result;
    }

    getElementById(id: string): CardElement | undefined {
        let result = super.getElementById(id);

        if (!result) {
            for (let i = 0; i < this.getItemCount(); i++) {
                result = this.getItemAt(i).getElementById(id);

                if (result) {
                    break;
                }
            }
        }

        return result;
    }

    /**
     * @inheritdoc
     */
    findDOMNodeOwner(node: FrameNode): CardObject | undefined {
        let target: CardObject | undefined = undefined;

        for (let i = 0; i < this.getItemCount(); i++) {
            // recur through child elements
            target = this.getItemAt(i).findDOMNodeOwner(node);

            if (target) {
                return target;
            }
        }

        // If not found in children, check the actions
        for (let i = 0; i < this.getActionCount(); i++) {
            target = this.getActionAt(i)?.findDOMNodeOwner(node);

            if (target) {
                return target;
            }
        }

        // if not found in children or actions, defer to parent implementation
        return super.findDOMNodeOwner(node);
    }
}

export class ImageSet extends CardElementContainer {
    //#region Schema

    static readonly imagesProperty = new SerializableObjectCollectionProperty(
        Versions.v1_0,
        "images",
        Image,
        (sender: SerializableObject, item: Image) => {
            item.setParent(sender as CardElement);
        }
    );

    static readonly imageSizeProperty = new EnumProperty(
        Versions.v1_0,
        "imageSize",
        Enums.ImageSize,
        Enums.ImageSize.Medium
    );

    static readonly imagePresentationStyle = new EnumProperty(
        Versions.v1_6,
        "style",
        Enums.ImageSetPresentationStyle,
        Enums.ImageSetPresentationStyle.Default
    );

    static readonly pixelOffset = new NumProperty(
        Versions.v1_6,
        "offset",
        0,
        undefined
    );

    @property(ImageSet.imagesProperty)
    private _images: Image[] = [];

    @property(ImageSet.imageSizeProperty)
    imageSize: Enums.ImageSize = Enums.ImageSize.Medium;

    @property(ImageSet.imagePresentationStyle)
    presentationStyle: Enums.ImageSetPresentationStyle = Enums.ImageSetPresentationStyle.Default;

    @property(ImageSet.pixelOffset)
    pixelOffset: number = 0;

    //#endregion

    protected internalRender(context: UIContext): FrameNode | undefined {
        let element: typeNode.Flex | undefined = undefined;

        if (this._images.length > 0) {
            const imageSetIsGrid = (this.presentationStyle === Enums.ImageSetPresentationStyle.Grid);



            element = typeNode.createNode(context, "Flex");
            element?.initialize({ wrap:FlexWrap.Wrap});

            let renderImageSize : Enums.Size;
            switch (this.imageSize) {
                case Enums.ImageSize.Small:
                    renderImageSize = Enums.Size.Small;
                    break;
                case Enums.ImageSize.Large:
                    renderImageSize = Enums.Size.Large;
                    break;
                default:
                    renderImageSize = Enums.Size.Medium;
                    break;
            }

            const effectiveImageSize = this.hostConfig.getEffectiveImageSize(renderImageSize);

            for (const image of this._images) {
                image.maxHeight = this.hostConfig.imageSet.maxImageHeight;

                if (imageSetIsGrid) {
                    image.pixelWidth = effectiveImageSize;
                } else {
                    image.size = renderImageSize;
                }

                const imageContainer = image.render(context);

                if (imageContainer) {
                    imageContainer.commonAttribute.margin(0);

                    if (imageSetIsGrid) {
                        imageContainer.commonAttribute.flexBasis(px2vp(effectiveImageSize));
                        imageContainer.commonAttribute.height(px2vp(effectiveImageSize));
                        imageContainer.commonAttribute.flexGrow(0);
                        imageContainer.commonAttribute.flexShrink(0);
                        const renderedImageStyle = image.renderedImageElement?.commonAttribute;
                        if (renderedImageStyle) {
                            renderedImageStyle.width("100%");
                            renderedImageStyle.height("100%");
                            (renderedImageStyle as ImageAttribute).objectFit(ImageFit.Cover);
                        }
                    }

                    Utils.appendChild(element, imageContainer);
                }
            }

            if (this.presentationStyle == Enums.ImageSetPresentationStyle.Stacked) {
                this.applyStackedPresentationStyle();
            }
        }


        return element;
    }

    applyStackedPresentationStyle() {
        if (this._images[0].renderedImageElement) {
            let dimension: number | undefined = StackedImageConfigurator.parseNumericPixelDimension(this._images[0].renderedImageElement.commonAttribute.height.toString());
            let bgColor = this.getEffectiveBackgroundColor();
            if (dimension) {
                let stackedImageConfigurator: StackedImageConfigurator = new StackedImageConfigurator(this.pixelOffset,
                    dimension, bgColor);
                stackedImageConfigurator.configureImagesArrayAsStackedLayout(this._images);
            }
        }
    }

    getEffectiveBackgroundColor() : string | undefined {
        let parentContainer = this.getParentContainer();
        let style = parentContainer?.getEffectiveStyle();

        const styleDefinition = this.hostConfig.containerStyles.getStyleByName(
            style,
            this.hostConfig.containerStyles.getStyleByName(this.defaultStyle)
        );

        return Utils.stringToCssColor(styleDefinition.backgroundColor);
    }

    getItemCount(): number {
        return this._images.length;
    }

    getItemAt(index: number): CardElement {
        return this._images[index];
    }

    getFirstVisibleRenderedItem(): CardElement | undefined {
        return this._images && this._images.length > 0 ? this._images[0] : undefined;
    }

    getLastVisibleRenderedItem(): CardElement | undefined {
        return this._images && this._images.length > 0
            ? this._images[this._images.length - 1]
            : undefined;
    }

    removeItem(item: CardElement): boolean {
        if (item instanceof Image) {
            const itemIndex = this._images.indexOf(item);

            if (itemIndex >= 0) {
                this._images.splice(itemIndex, 1);

                item.setParent(undefined);

                this.updateLayout();

                return true;
            }
        }

        return false;
    }

    getJsonTypeName(): string {
        return "ImageSet";
    }

    addImage(image: Image) {
        if (!image.parent) {
            this._images.push(image);

            image.setParent(this);
        } else {
            throw new Error("This image already belongs to another ImageSet");
        }
    }

    indexOf(cardElement: CardElement): number {
        return cardElement instanceof Image ? this._images.indexOf(cardElement) : -1;
    }
}

class StackedImageConfigurator {
    private sign45 = 0.7071;
    private maxImageCounts: number = 2;
    private offset: number = 0;
    private normalizationConstant: number = 0;
    private border: number = 5;
    private dimension: number = 0;
    private style: string;

    constructor(offset: number, dimension: number, style: string | undefined) {
        this.dimension = dimension;
        this.normalizationConstant = (dimension * this.sign45 - 0.5 * dimension) * 2;
        // offset determines how far images are placed from each other
        // at zero, images are separated only by the border
        // there is no restriction on how far they are apart in positive values, their actual
        // positioning is limited by maximum size imposed by Image renderer
        // a negative value can decrease upto the diameter of the image since a value less than the diameter
        // put the images past each other, and the use of such value is not reasonable request
        // users should change image positions in such case.
        this.offset = this.sign45 * (Math.max(offset, -dimension) - this.normalizationConstant);
        this.style = style ? style : "";
    }

    private moveImageRight(element: FrameNode) {
        element.commonAttribute.margin({ left: px2vp( this.offset )});
    }

    private moveImageUp(element: FrameNode) {
        element.commonAttribute.margin({ bottom: px2vp( this.offset + this.dimension )});
    }

    private moveImageDown(element: FrameNode) {
        element.commonAttribute.margin({ top: px2vp( this.offset + this.dimension )});
    }

    private makeImageRound(element: FrameNode) {

        element.commonAttribute.borderRadius("50%");
        element.commonAttribute.backgroundImagePosition({ x: "50%", y: "50%"});
        element.commonAttribute.backgroundImage(undefined, ImageRepeat.NoRepeat);
    }

    private applyBorder(element: FrameNode) {
        element.commonAttribute.height(vp2px(this.dimension + this.border * 2));
        element.commonAttribute.border({
            width: this.border,
            color: this.style,
            style: BorderStyle.Solid
        })
    }

    private configureImageForBottomLeft(element: FrameNode) {
        this.moveImageDown(element);
        this.makeImageRound(element);
        this.applyBorder(element);
        element.commonAttribute.zIndex(2);
    }

    private configureImageForTopRight(element: FrameNode) {
        this.moveImageUp(element);
        this.moveImageRight(element);
        this.makeImageRound(element);
        element.commonAttribute.zIndex(1);
    }

    // stacked layout is applied when there are two images in ImageSet,
    // first image in the ImageSet is put bottom left of ImageSet,
    // second image is placed top right diagonally to the first image at 45 angle
    // first image is placed over the second image should the overlap to occur.
    public configureImagesArrayAsStackedLayout(elements: Array<Image>) {
        if (elements.length == 1) {
            if (elements[0].renderedImageElement) {
                this.makeImageRound(elements[0].renderedImageElement);
            }
        }
        else if (elements.length <= this.maxImageCounts) {
            if (elements[0].renderedImageElement && elements[1].renderedImageElement) {
                this.configureImageForBottomLeft(elements[0].renderedImageElement);
                this.configureImageForTopRight(elements[1].renderedImageElement);
            }
        }
    }

    public static parseNumericPixelDimension(dimension: string): number | undefined  {
        if (dimension?.substring(dimension.length - 2) == 'px') {
            return parseInt(dimension.substring(0, dimension.length - 2));
        }
        return undefined;
    }
}


enum InputEventType {
    InitialRender,
    MouseEnterOnCard,
    MouseLeaveOnCard,
    FocusLeave
}

export abstract class Input extends CardElement implements IInput {

    //#region Schema
    static readonly labelProperty = new StringProperty(Versions.v1_3, "label", true);
    static readonly isRequiredProperty = new BoolProperty(Versions.v1_3, "isRequired", false);
    static readonly errorMessageProperty = new StringProperty(Versions.v1_3, "errorMessage", true);
    static readonly inputStyleProperty = new EnumProperty(
        Versions.v1_6,
        "inputStyle",
        Enums.InputStyle,
        Enums.InputStyle.Default,
        [
            { value: Enums.InputStyle.RevealOnHover },
            { value: Enums.InputStyle.Default }
        ]
    );
    static readonly labelWidthProperty = new CustomProperty<SizeAndUnit | undefined>(
        Versions.v1_6,
        "labelWidth",
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            let result: SizeAndUnit | undefined = prop.defaultValue;
            const value: string = source[prop.name];
            let invalidLabelWidth = false;

            if (typeof value === "number" && !isNaN(value)) {
                result = new SizeAndUnit(value, Enums.SizeUnit.Weight);
                if (result.physicalSize < 0 || result.physicalSize > 100) {
                    invalidLabelWidth = true;
                }
            }
            else if (typeof value === "string") {
                try {
                    result = SizeAndUnit.parse(value);
                } catch (e) {
                    invalidLabelWidth = true;
                }
            } else {
                invalidLabelWidth = true;
            }

            if (invalidLabelWidth) {
                context.logParseEvent(
                    sender,
                    Enums.ValidationEvent.InvalidPropertyValue,
                    Strings.errors.invalidInputLabelWidth()
                );
                result = undefined;
            }

            return result;
        },
        (
            sender: SerializableObject,
            property: PropertyDefinition,
            target: PropertyBag,
            value: SizeAndUnit | undefined,
            context: BaseSerializationContext
        ) => {
            if (value instanceof SizeAndUnit) {
                if (value.unit === Enums.SizeUnit.Pixel) {
                    context.serializeValue(target, "labelWidth", value.physicalSize + "px");
                } else {
                    context.serializeNumber(target, "labelWidth", value.physicalSize);
                }
            }
        },
        undefined
    );

    static readonly labelPositionProperty = new EnumProperty(
        Versions.v1_6,
        "labelPosition",
        Enums.InputLabelPosition,
        Enums.InputLabelPosition.Above,
        [
            { value: Enums.InputLabelPosition.Inline },
            { value: Enums.InputLabelPosition.Above }
        ]
    );

    @property(Input.labelProperty)
    label?: string;

    @property(Input.isRequiredProperty)
    isRequired?: boolean;

    @property(Input.errorMessageProperty)
    errorMessage?: string;

    @property(Input.inputStyleProperty)
    inputStyle: Enums.InputStyle = Enums.InputStyle.Default;

    @property(Input.labelWidthProperty)
    labelWidth?: SizeAndUnit;

    @property(Input.labelPositionProperty)
    labelPosition?: Enums.InputLabelPosition;

    //#endregion

    private _outerContainerElement: typeNode.Flex | undefined;
    private _inputControlContainerElement: typeNode.Flex | undefined;
    private _renderedErrorMessageElement?: FrameNode;
    private _renderedLabelElement?: FrameNode;
    private _renderedInputControlElement?: FrameNode;
    private _oldValue: ESObject;

    protected getAllLabelIds(): string[] {
        const labelIds: string[] = [];

        if (this.labelledBy) {
            labelIds.push(this.labelledBy);
        }

        if (this._renderedLabelElement) {
            labelIds.push(this._renderedLabelElement.getId());
        }

        if (this._renderedErrorMessageElement) {
            labelIds.push(this._renderedErrorMessageElement.getId());
        }

        return labelIds;
    }

    protected updateInputControlAriaLabelledBy() {
        if (this._renderedInputControlElement) {
            const labelIds: string[] = this.getAllLabelIds();

            if (labelIds.length > 0) {
                this._renderedInputControlElement.commonAttribute.customProperty("aria-labelledby", labelIds.join(" "))
            } else {
                this._renderedInputControlElement.commonAttribute.customProperty("aria-labelledby", undefined);
            }
        }
    }

    protected get isNullable(): boolean {
        return true;
    }

    protected get renderedInputControlElement(): FrameNode | undefined {
        return this._renderedInputControlElement;
    }

    protected get inputControlContainerElement(): typeNode.Flex | undefined {
        return this._inputControlContainerElement;
    }

    protected overrideInternalRender(context: UIContext): FrameNode | undefined {
        const hostConfig = this.hostConfig;

        this._outerContainerElement = typeNode.createNode(context, "Flex");
        this._outerContainerElement.attribute.height("auto");

        if (this.labelPosition === Enums.InputLabelPosition.Inline) {
            this._outerContainerElement.initialize({ direction: FlexDirection.Row});
        } else {
            this._outerContainerElement.initialize({ direction: FlexDirection.Column});
        }

        const renderedInputControlId = Utils.generateUniqueId();

        if (this.label) {
            const labelRichTextBlock = new RichTextBlock();
            labelRichTextBlock.setParent(this);
            labelRichTextBlock.forElementId = renderedInputControlId;

            const labelInline = new TextRun(this.label);
            labelRichTextBlock.addInline(labelInline);

            if (this.isRequired) {
                labelInline.init(hostConfig.inputs.label.requiredInputs);

                const isRequiredCueInline = new TextRun(
                    hostConfig.inputs.label.requiredInputs.suffix
                );
                isRequiredCueInline.color = hostConfig.inputs.label.requiredInputs.suffixColor;
                isRequiredCueInline.ariaHidden = true;

                labelRichTextBlock.addInline(isRequiredCueInline);
            } else {
                labelInline.init(hostConfig.inputs.label.optionalInputs);
            }

            this._renderedLabelElement = labelRichTextBlock.render(context);

            if (this._renderedLabelElement) {
                if (this.labelPosition === Enums.InputLabelPosition.Inline) {
                    // For inline label position: label should be in center of the div and no extra spacing needed
                    this._renderedLabelElement.commonAttribute.alignSelf(ItemAlign.Center);
                } else {
                    this._renderedLabelElement.commonAttribute.margin({
                        bottom: hostConfig.getEffectiveSpacing(hostConfig.inputs.label.inputSpacing)
                    })
                }
                this._outerContainerElement.appendChild(this._renderedLabelElement);
            }
        }

        this._inputControlContainerElement = typeNode.createNode(context, "Flex");

        if (this.height === "stretch") {
            this._inputControlContainerElement.attribute.flexGrow(1);
            this._inputControlContainerElement.attribute.flexShrink(1);
            this._inputControlContainerElement.attribute.flexBasis("auto");
            this._inputControlContainerElement.initialize({ alignItems: ItemAlign.Stretch })
        }

        this._renderedInputControlElement = this.internalRender(context);

        if (this._renderedInputControlElement) {
            this._renderedInputControlElement.commonAttribute.constraintSize({
                minWidth: 0
            })

            this._inputControlContainerElement.appendChild(this._renderedInputControlElement);
            this._outerContainerElement.appendChild(this._inputControlContainerElement);

            if (this._renderedLabelElement && this.labelPosition === Enums.InputLabelPosition.Inline) {
                if (!this.labelWidth) {
                    const defaultLabelWidth = hostConfig.inputs.label.width;
                    this._renderedLabelElement.commonAttribute.width(defaultLabelWidth.toString() + "%");
                    this._inputControlContainerElement.commonAttribute.width((100 - defaultLabelWidth) + "%");
                }
                else if (this.labelWidth.unit == Enums.SizeUnit.Weight) {
                    const labelWidthInPercent = this.labelWidth.physicalSize;
                    this._renderedLabelElement.commonAttribute.width(labelWidthInPercent.toString() + "%");
                    this._inputControlContainerElement.commonAttribute.width((100 - labelWidthInPercent).toString() + "%")
                }
                else if (this.labelWidth.unit == Enums.SizeUnit.Pixel) {
                    const labelWidthInPixel = this.labelWidth.physicalSize;
                    this._renderedLabelElement.commonAttribute.width(labelWidthInPixel.toString())
                }
            }

            this.updateVisualState(InputEventType.InitialRender);
            if (this._renderedInputControlElement) {
                this._renderedInputControlElement.commonEvent.setOnFocus(()=>{
                    this.updateVisualState(InputEventType.FocusLeave);
                })
            }
            this.updateInputControlAriaLabelledBy();

            return this._outerContainerElement;
        }

        this.resetDirtyState();

        return undefined;
    }

    protected valueChanged() {
        this.getRootElement().updateActionsEnabledState();

        if (this.isValid()) {
            this.resetValidationFailureCue();
        }

        if (this.onValueChanged) {
            this.onValueChanged(this);
        }

        raiseInputValueChangedEvent(this);
    }

    protected resetValidationFailureCue() {
        if (this.renderedInputControlElement) {

            this.updateInputControlAriaLabelledBy();

            if (this._renderedErrorMessageElement) {
                this._outerContainerElement?.removeChild(this._renderedErrorMessageElement);
                this._renderedErrorMessageElement = undefined;
            }
        }
    }

    protected showValidationErrorMessage(context: UIContext) {
        if (
            this.renderedElement &&
            this.errorMessage &&
            GlobalSettings.displayInputValidationErrors
        ) {
            const errorMessageTextBlock = new TextBlock();
            errorMessageTextBlock.setParent(this);
            errorMessageTextBlock.text = this.errorMessage;
            errorMessageTextBlock.wrap = true;
            errorMessageTextBlock.init(this.hostConfig.inputs.errorMessage);

            this._renderedErrorMessageElement = errorMessageTextBlock.render(context);

            if (this._renderedErrorMessageElement) {
                this._outerContainerElement?.appendChild(this._renderedErrorMessageElement);

                this.updateInputControlAriaLabelledBy();
            }
        }
    }

    protected get allowRevealOnHoverStyle() {
        return this.hostConfig.inputs && this.hostConfig.inputs.allowRevealOnHoverStyle;
    }

    protected shouldHideInputAdornersForRevealOnHover(input: FrameNode, eventType: InputEventType) {
        // show/hide input adorners (date picker, time picker, select dropdown picker) with inputStyle RevealOnHover
        // 1. intial render of card: hide input adorners
        // 2. mouse hover on the card: show input adorners
        // 3. mouse hover outside the card: hide input adorners unless input is still in focus state
        // 4. input loses focus: hide the input adorners unless mouse is still hovering on the card

        // check if input still has the focus
        const isInputInFocus = false;
        // check if mouse is still on the card
        const inputHoverClassName = this.hostConfig.makeCssClassName("ac-inputStyle-revealOnHover-onhover");
        const isMouseOverCard: boolean = false;

        const hideInputAdorners = (eventType === InputEventType.InitialRender) ||
            (eventType === InputEventType.FocusLeave && !isMouseOverCard) ||
            (eventType === InputEventType.MouseLeaveOnCard && !isInputInFocus);
        return hideInputAdorners;
    }

    updateVisualState(eventType: InputEventType): void {
        if (!this.allowRevealOnHoverStyle ||
            !this._renderedInputControlElement ||
            this.inputStyle !== Enums.InputStyle.RevealOnHover) {
            return;
        }
        if (eventType === InputEventType.InitialRender) {
            // on initial render, we will show input fields as read only view
           // 原始样式ac-inputStyle-revealOnHover-onrender
            this._renderedInputControlElement.commonAttribute.border({
                width: 1,
                style: BorderStyle.Solid,
                color: Color.Transparent
            })
            this._renderedInputControlElement.commonAttribute.backgroundColor(null);
            this._renderedInputControlElement.commonEvent.setOnHover(()=>{
                this._renderedInputControlElement?.commonAttribute.border({
                    width: 1,
                    style: BorderStyle.Solid,
                    color: "#686868"
                })
            })
        }
        else if (eventType === InputEventType.MouseEnterOnCard) {
            // on hover on the card, we will reveal the inputs by showing borders etc
            // ac-inputStyle-revealOnHover-onhover class is also used to identify if mouse is hovering on the card
            // 原始样式ac-inputStyle-revealOnHover-onhover
            this._renderedInputControlElement.commonAttribute.border({
                width: 1,
                style: BorderStyle.Solid,
                color: "#DDDDDD"
            })
        } else if (eventType === InputEventType.MouseLeaveOnCard) {
            // 原始样式ac-inputStyle-revealOnHover-onhover
            this._renderedInputControlElement.commonAttribute.border(undefined);
        }
    }

    onValueChanged?: (sender: Input) => void;

    labelledBy?: string;

    abstract isSet(): boolean;

    focus() {
        if (this._renderedInputControlElement) {
        }
    }

    isValid(): boolean {
        return true;
    }

    isDirty(): boolean {
        return this.value !== this._oldValue;
    }

    resetDirtyState() {
        this._oldValue = this.value;
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        if (!this.id) {
            context.addFailure(
                this,
                Enums.ValidationEvent.PropertyCantBeNull,
                Strings.errors.inputsMustHaveUniqueId()
            );
        }

        if (this.isRequired) {
            if (!this.label) {
                context.addFailure(
                    this,
                    Enums.ValidationEvent.RequiredInputsShouldHaveLabel,
                    "Required inputs should have a label"
                );
            }

            if (!this.errorMessage) {
                context.addFailure(
                    this,
                    Enums.ValidationEvent.RequiredInputsShouldHaveErrorMessage,
                    "Required inputs should have an error message"
                );
            }
        }
    }

    validateValue(context: UIContext): boolean {
        this.resetValidationFailureCue();

        const result = this.isRequired ? this.isSet() && this.isValid() : this.isValid();


        if (!result && this.renderedInputControlElement) {
            this.showValidationErrorMessage(context);
        }

        return result;
    }

    getAllInputs(processActions: boolean = true): Input[] {
        return [this];
    }

    render(context: UIContext): FrameNode | undefined {
        let result = super.render(context);

        this.resetDirtyState();

        return result;
    }

    abstract get value(): ESObject;

    get isInteractive(): boolean {
        return true;
    }
}

export class TextInput extends Input {
    //#region Schema

    static readonly valueProperty = new StringProperty(Versions.v1_0, "value");
    static readonly maxLengthProperty = new NumProperty(Versions.v1_0, "maxLength");
    static readonly isMultilineProperty = new BoolProperty(Versions.v1_0, "isMultiline", false);
    static readonly placeholderProperty = new StringProperty(Versions.v1_0, "placeholder");
    static readonly styleProperty = new EnumProperty(
        Versions.v1_0,
        "style",
        Enums.InputTextStyle,
        Enums.InputTextStyle.Text,
        [
            { value: Enums.InputTextStyle.Text },
            { value: Enums.InputTextStyle.Tel },
            { value: Enums.InputTextStyle.Url },
            { value: Enums.InputTextStyle.Email },
            { value: Enums.InputTextStyle.Password, targetVersion: Versions.v1_5 }
        ]
    );
    static readonly inlineActionProperty = new ActionProperty(Versions.v1_0, "inlineAction", [
        "Action.ShowCard"
    ]);
    static readonly regexProperty = new StringProperty(Versions.v1_3, "regex", true);

    @property(TextInput.valueProperty)
    defaultValue?: string;

    @property(TextInput.maxLengthProperty)
    maxLength?: number;

    @property(TextInput.isMultilineProperty)
    isMultiline: boolean = false;

    @property(TextInput.placeholderProperty)
    placeholder?: string;

    @property(TextInput.styleProperty)
    style: Enums.InputTextStyle = Enums.InputTextStyle.Text;

    @property(TextInput.inlineActionProperty)
    inlineAction?: Action;

    @property(TextInput.regexProperty)
    regex?: string;

    textValue?: string;

    //#endregion

    private setupInput(input: typeNode.TextInput | typeNode.TextArea) {
        input.attribute.flexGrow(1);
        input.attribute.flexShrink(1);
        input.attribute.flexBasis("auto");

        input.attribute.tabIndex(this.isDesignMode() ? -1 : 0);
        let option: TextInputOptions = {};

        if (this.placeholder) {
            option.placeholder = this.placeholder;
            input.attribute.customProperty("aria-label", this.placeholder)
        }

        if (this.defaultValue) {
            option.text = this.defaultValue;
        }

        input.initialize(option);
        input.attribute.onChange((value: string)=>{
            this.textValue = value;
        })

        if (this.maxLength && this.maxLength > 0) {
            input.attribute.maxLength(this.maxLength);
        }

        input.attribute.onEditChange(()=>{
            this.valueChanged();
        })

        input.attribute.onKeyEvent((e: KeyEvent)=>{
            //  // Ctrl+Enter pressed
            LogUtils.getInstance().warn("方法未实现");
            if(e.type === KeyType.Down){
            }
        })
    }

    protected internalRender(context: UIContext): FrameNode | undefined {
        let result: typeNode.TextInput | typeNode.TextArea;

        if (this.isMultiline && this.style !== Enums.InputTextStyle.Password) {
            result = typeNode.createNode(context, "TextArea");
            // TextArea API14新增属性，兼容低版本
            if(!result){
                result = typeNode.createNode(context, "TextInput");
            }
            // 原始样式"ac-input"
            result.attribute.fontFamily('Segoe UI sans-serif');
            result.attribute.fontSize(14)
            result.attribute.fontColor(Color.Black)
            // 原始样式"ac-textInput"
            result.attribute.width("100%");
            result.attribute.height(31);
            result.attribute.border({
                width: 1,
                color: "#DDDDDD",
                style: BorderStyle.Solid
            })
            result.attribute.padding({
                top: 4,
                right: 8,
                bottom: 4,
                left: 8
            })
            result.commonEvent.setOnHover(()=>{
                result?.attribute.border(null);
                result?.attribute.backgroundColor(null);
            })
            // 原始样式"ac-multiline"
            result.attribute.height(72);

            if (this.height === "stretch") {
                result.attribute.height("initial")
            }
        } else {
            result = typeNode.createNode(context, "TextInput");
            // 原始样式"ac-input"
            result.attribute.fontFamily('Segoe UI sans-serif');
            result.attribute.fontSize(14)
            result.attribute.fontColor(Color.Black)
            // 原始样式"ac-textInput"
            result.attribute.height(31);
            result.attribute.border({
                width: 1,
                color: "#DDDDDD",
                style: BorderStyle.Solid
            })
            result.attribute.padding({
                top: 4,
                right: 8,
                bottom: 4,
                left: 8
            })
            result.commonEvent.setOnHover(()=>{
                result?.attribute.border(null);
                result?.attribute.backgroundColor(null);
            })
            let type = Enums.InputTextStyle[this.style];
            let inputType: InputType;
            switch (type){
                case "Text":
                    inputType = InputType.Normal;
                    break;
                case "Tel":
                    inputType = InputType.PhoneNumber;
                    break;
                case "Url":
                    inputType = InputType.URL;
                    break;
                case "Email":
                    inputType = InputType.Email;
                    break;
                case "Password":
                    inputType = InputType.Password;
                    break;
                default:
                    inputType = InputType.Normal;
                    break;
            }
            result.attribute.type(inputType);
        }

        this.setupInput(result);

        return result;
    }

    protected overrideInternalRender(context: UIContext): FrameNode | undefined {
        const renderedInputControl = super.overrideInternalRender(context);

        if (this.inlineAction) {
            const button = typeNode.createNode(context, "Button");
            if(this.inlineAction.isEffectivelyEnabled()){
                // 原始样式"ac-inlineActionButton"
                button.attribute.labelStyle({
                    overflow: TextOverflow.Ellipsis,
                    font:{
                        family:"sans-serif",
                        size: 14
                    }
                })
                button.attribute.fontColor(Color.Black);
                button.attribute.backgroundColor(Color.Transparent);
                button.attribute.height(31);
                button.attribute.align(Alignment.Center);
                button.attribute.alignSelf(ItemAlign.Center);
            }else{
                // 原始样式"ac-inlineActionButton-disabled"
            }

            button.commonEvent.setOnClick((e: ClickEvent)=>{
                if (this.inlineAction && this.inlineAction.isEffectivelyEnabled()) {
                    this.inlineAction.execute(context);
                }
            })

            if (this.inlineAction.iconUrl) {

                const icon = typeNode.createNode(context, "Image");
                icon.attribute.height("100%");
                icon.attribute.customProperty("role", "presentation");

                // The below trick is necessary as a workaround in Chrome where the icon is initially displayed
                // at its native size then resized to 100% of the button's height. This cfreates an unpleasant
                // flicker. On top of that, Chrome's flex implementation fails to prperly re-layout the button
                // after the image has loaded and been gicven its final size. The below trick also fixes that.
                icon.attribute.visibility(Visibility.None);
                icon.attribute.onComplete(()=>{
                    icon.attribute.visibility(Visibility.Visible);
                })
                icon.attribute.onError(()=>{
                    button.removeChild(icon);
                    let textContent =
                        this.inlineAction && this.inlineAction.title
                            ? this.inlineAction.title
                            : Strings.defaults.inlineActionTitle();
                    button.initialize(textContent);
                })

                icon.initialize(this.inlineAction.iconUrl);
                button.appendChild(icon);
            } else {
                let textContent = this.inlineAction.title
                    ? this.inlineAction.title
                    : Strings.defaults.inlineActionTitle();
                button.initialize(textContent);
            }

            this.inlineAction.setupElementForAccessibility(button, true);

            button.attribute.margin({
                 left: 8
            })

            this.inputControlContainerElement?.appendChild(button);
        }

        return renderedInputControl;
    }

    updateVisualState(eventType: InputEventType): void {
        if (!this.allowRevealOnHoverStyle) {
            return;
        }

        if (!(this.inlineAction || this.isMultiline)) {
            super.updateVisualState(eventType);
        }
    }

    getJsonTypeName(): string {
        return "Input.Text";
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        if (this.inlineAction) {
            result.push(this.inlineAction);
        }

        return result;
    }

    getActionById(id: string) {
        let result = super.getActionById(id);

        if (!result && this.inlineAction) {
            result = this.inlineAction.getActionById(id);
        }

        return result;
    }

    isSet(): boolean {
        return this.value ? true : false;
    }

    isValid(): boolean {
        if (!this.value) {
            return true;
        }

        if (this.regex) {
            return new RegExp(this.regex, "g").test(this.value);
        }

        return true;
    }

    get value(): string | undefined {
        if (this.renderedInputControlElement) {
            return this.textValue
        } else {
            return undefined;
        }
    }
}


export class NumberInput extends Input {
    //#region Schema

    static readonly valueProperty = new NumProperty(Versions.v1_0, "value");
    static readonly placeholderProperty = new StringProperty(Versions.v1_0, "placeholder");
    static readonly minProperty = new NumProperty(Versions.v1_0, "min");
    static readonly maxProperty = new NumProperty(Versions.v1_0, "max");

    @property(NumberInput.valueProperty)
    defaultValue?: number;

    @property(NumberInput.minProperty)
    min?: number;

    @property(NumberInput.maxProperty)
    max?: number;

    @property(NumberInput.placeholderProperty)
    placeholder?: string;

    textValue?: string | number;

    //#endregion

    private _numberInputElement: typeNode.TextInput | undefined;

    protected internalRender(context: UIContext): FrameNode | undefined {
        this._numberInputElement = typeNode.createNode(context, "TextInput");
        this._numberInputElement.attribute.type(InputType.Number);

        // 原始样式"ac-input"、"ac-numberInput"
        this._numberInputElement.attribute.fontFamily('Segoe UI sans-serif');
        this._numberInputElement.attribute.fontSize(14)
        this._numberInputElement.attribute.fontColor(Color.Black)
        this._numberInputElement.attribute.height(31);
        //
        this._numberInputElement.attribute.border({
            width: 1,
            color: "#DDDDDD",
            style: BorderStyle.Solid
        })
        this._numberInputElement.attribute.padding({
            top: 4,
            right: 10,
            bottom: 5,
            left: 10
        })
        this._numberInputElement.attribute.backgroundColor(null);
        this._numberInputElement.attribute.width("100%");
        this._numberInputElement.commonEvent.setOnHover(()=>{
            this._numberInputElement?.attribute.border(null);
            this._numberInputElement?.attribute.backgroundColor(null);
        })

        this._numberInputElement.attribute.tabIndex(this.isDesignMode() ? -1 : 0)

        let option: TextInputOptions = {};
        if (this.defaultValue !== undefined) {
            option = { text: this.defaultValue.toString() };
        }

        if (this.placeholder) {
            option.placeholder = this.placeholder;
        }
        this._numberInputElement.initialize(option);

        this._numberInputElement.attribute.onEditChange(()=>{
            this.valueChanged();
        })
        this._numberInputElement.attribute.onChange((value: string)=>{
            this.textValue = value;
        })

        return this._numberInputElement;
    }

    getJsonTypeName(): string {
        return "Input.Number";
    }

    isSet(): boolean {
        return this.value !== undefined && !isNaN(this.value);
    }

    isValid(): boolean {
        if (this.value === undefined) {
            return !this.isRequired;
        }

        let result = true;

        if (this.min !== undefined) {
            result = result && this.value >= this.min;
        }

        if (this.max !== undefined) {
            result = result && this.value <= this.max;
        }

        return result;
    }

    get value(): number | undefined {
        try {
            return this.textValue ? Number(this.textValue) : undefined;
        }catch (e){
            return undefined
        }
    }

    set value(value: number | undefined) {
        if (value && this._numberInputElement) {
            this._numberInputElement.initialize({ text: value.toString()});
        }
    }
}


export const enum ActionButtonState {
    Normal,
    Expanded,
    Subdued
}

export type ActionType = Action;

export abstract class Action extends CardObject {
    //#region Schema

    static readonly titleProperty = new StringProperty(Versions.v1_0, "title");
    static readonly iconUrlProperty = new StringProperty(Versions.v1_1, "iconUrl");
    static readonly styleProperty = new ValueSetProperty(
        Versions.v1_2,
        "style",
        [
            { value: Enums.ActionStyle.Default },
            { value: Enums.ActionStyle.Positive },
            { value: Enums.ActionStyle.Destructive }
        ],
        Enums.ActionStyle.Default
    );
    static readonly modeProperty = new ValueSetProperty(
        Versions.v1_5,
        "mode",
        [{ value: Enums.ActionMode.Primary }, { value: Enums.ActionMode.Secondary }],
        Enums.ActionMode.Primary
    );
    static readonly tooltipProperty = new StringProperty(Versions.v1_5, "tooltip");
    static readonly isEnabledProperty = new BoolProperty(Versions.v1_5, "isEnabled", true);
    static readonly roleProperty = new EnumProperty(Versions.v1_6, "role", Enums.ActionRole);

    @property(Action.titleProperty)
    title?: string;

    @property(Action.iconUrlProperty)
    iconUrl?: string;

    @property(Action.styleProperty)
    style: string = Enums.ActionStyle.Default;

    @property(Action.modeProperty)
    mode: string = Enums.ActionMode.Primary;

    @property(Action.tooltipProperty)
    tooltip?: string;

    @property(Action.isEnabledProperty)
    isEnabled: boolean = false;
    
    @property(Action.roleProperty)
    role?: Enums.ActionRole;

    //#endregion

    private renderButtonContent(context:UIContext) {
        if (this.renderedElement) {
            // Cache hostConfig for perf
            const hostConfig = this.hostConfig;

            const titleElement = typeNode.createNode(context,"Text");
            titleElement.attribute.constraintSize({minHeight:30});
            if (
                !(
                    hostConfig.actions.iconPlacement === Enums.ActionIconPlacement.AboveTitle ||
                    hostConfig.actions.allowTitleToWrap
                )
            ) {
            }

            // 如果未initialize，按钮在页面不显示
            titleElement.initialize(this.title || "");


            if (!this.iconUrl) {
                this.renderedElement.appendChild(titleElement);
            } else {
                const rowElement = typeNode.createNode(context, "Row");
                const iconElement = typeNode.createNode(context,"Image");
                iconElement.attribute.width(hostConfig.actions.iconSize);
                iconElement.attribute.height(hostConfig.actions.iconSize);
                iconElement.attribute.flexGrow(0);
                iconElement.attribute.flexShrink(0);
                iconElement.attribute.flexBasis('auto');
                iconElement.attribute.customProperty("role", "presentation");
                iconElement.initialize(this.iconUrl);

                if (hostConfig.actions.iconPlacement === Enums.ActionIconPlacement.AboveTitle) {
                    const element =  this.renderedElement as typeNode.Flex;
                    element.attribute.width('auto');
                    element.attribute.height('auto');
                    element.initialize({direction:FlexDirection.Column});
                    if (this.title) {
                        iconElement.attribute.margin({bottom:6})
                    }
                } else {
                    iconElement.attribute.constraintSize({maxHeight:'100%'});
                    if (this.title) {
                        iconElement.attribute.margin({right:6});
                    }
                }
                rowElement.appendChild(iconElement);
                rowElement.appendChild(titleElement);
                this.renderedElement.appendChild(rowElement);
            }
        }
    }

    private getParentContainer(): Container | undefined {
        if (this.parent instanceof Container) {
            return this.parent;
        }

        return this.parent ? this.parent.getParentContainer() : undefined;
    }

    private _state: ActionButtonState = ActionButtonState.Normal;
    public _actionCollection?: ActionCollection; // hold the reference to its action collection
    private _isFocusable: boolean = true;

    isDesignMode(): boolean {
        const rootElement = this.getRootObject();

        return rootElement instanceof CardElement && rootElement.isDesignMode();
    }

    protected updateCssClasses() {
        if (this.parent && this.renderedElement) {
            const hostConfig = this.parent.hostConfig;
            const parentContainer = this.getParentContainer();

            if (parentContainer) {
                const parentContainerStyle = parentContainer.getEffectiveStyle();
            }

            switch (this._state) {
                case ActionButtonState.Normal:
                    // No additional classes needed
                    break;

                case ActionButtonState.Expanded:
                    break;
                case ActionButtonState.Subdued:
                    break;
            }

        }
    }

    protected getDefaultSerializationContext(): BaseSerializationContext {
        return new SerializationContext();
    }

    protected internalGetReferencedInputs(): Dictionary<Input> {
        return {};
    }

    protected internalPrepareForExecution(_inputs: Dictionary<Input> | undefined) {
        // Do nothing in base implementation
    }

    protected internalValidateInputs(referencedInputs: Dictionary<Input> | undefined, context: UIContext): Input[] {
        const result: Input[] = [];

        if (referencedInputs) {
            for (const key of Object.keys(referencedInputs)) {
                const input = referencedInputs[key];

                if (!input.validateValue(context)) {
                    result.push(input);
                }
            }
        }

        return result;
    }

    protected shouldSerialize(context: SerializationContext): boolean {
        return context.actionRegistry.findByName(this.getJsonTypeName()) !== undefined;
    }

    protected raiseExecuteActionEvent(context: UIContext) {
        if (this.onExecute) {
            this.onExecute(this);
        }

        raiseExecuteActionEvent(this, context);
    }

    protected internalAfterExecute() {
        let rootObject = this.getRootObject();

        if (rootObject instanceof CardElement) {
            rootObject.updateActionsEnabledState();
        }
    }

    onExecute: (sender: Action) => void = () => {
    };

    getHref(): string | undefined {
        return "";
    }

    getAriaRole(): string {
        let ariaRole = this.getAriaRoleFromEnum();
        return ariaRole ?? "button";
    }
    
    getAriaRoleFromEnum(): string | undefined {
        switch (this.role) {
            case Enums.ActionRole.Button:
                return "button";
            case Enums.ActionRole.Link:
                return "link";
            case Enums.ActionRole.Menu:
                return "menu";
            case Enums.ActionRole.MenuItem:
                return "menuitem";
            case Enums.ActionRole.Tab:
                return "tab";
            default:
                return undefined;
        }
    }

    setupElementForAccessibility(element: FrameNode | typeNode.Button, promoteTooltipToLabel: boolean = false) {
        element.commonAttribute.tabIndex(this.isEffectivelyEnabled() && !this.isDesignMode() ? 0 : -1);
        if (element.getNodeType() === 'Button') {
            element = element as typeNode.Button;
            let isEnabled = this.isEffectivelyEnabled();
            (element as typeNode.Button).attribute.stateEffect(isEnabled);
            if(!isEnabled) {
                (element as typeNode.Button).attribute.opacity(0.4);
            }
        }
    }

    parse(source: PropertyBag, context?: SerializationContext):void {
        return super.parse(source, context ? context : new SerializationContext());
    }

    render(context:UIContext) {
        const buttonElement = typeNode.createNode(context, "Button");
        buttonElement.attribute.width('100%');
        buttonElement.attribute.height(50);
        buttonElement.attribute.fontColor('#646464')
        buttonElement.attribute.backgroundColor('#FCFFFE');
        buttonElement.attribute.border({width:1,color:'black'})
        buttonElement.attribute.align(Alignment.Center);
        buttonElement.attribute.fontWeight(FontWeight.Bolder);
        buttonElement.commonEvent.setOnClick((e)=>{
            if (this.isEffectivelyEnabled()) {
                this.execute(context);
            }
        })

        this._renderedElement = buttonElement;
        this.renderButtonContent(context);
        this.updateCssClasses();
        this.setupElementForAccessibility(buttonElement);
    }

    execute(context:UIContext) {
        if (this._actionCollection) {
            this._actionCollection.actionExecuted(context, this);
        }
        this.raiseExecuteActionEvent(context);
        this.internalAfterExecute();
    }

    prepareForExecution(context: UIContext): boolean {
        const referencedInputs = this.getReferencedInputs();
        const invalidInputs = this.internalValidateInputs(referencedInputs, context);

        if (invalidInputs.length > 0) {
            invalidInputs[0].focus();
            return false;
        }
        this.internalPrepareForExecution(referencedInputs);
        return true;
    }

    remove(): boolean {
        if (this._actionCollection) {
            return this._actionCollection.removeAction(this);
        }

        return false;
    }

    getAllInputs(processActions: boolean = true): Input[] {
        return [];
    }

    getAllActions(): Action[] {
        return [this];
    }

    getResourceInformation(): IResourceInformation[] {
        return this.iconUrl ? [{ url: this.iconUrl, mimeType: "image" }] : [];
    }

    getActionById(id: string): Action | undefined {
        return this.id === id ? this : undefined;
    }

    getReferencedInputs(): Dictionary<Input> | undefined {
        return this.internalGetReferencedInputs();
    }

    /**
     * Validates the inputs associated with this action.
     *
     * @returns A list of inputs that failed validation, or an empty array if no input failed validation.
     */
    validateInputs(context: UIContext): Input[] {
        return this.internalValidateInputs(this.getReferencedInputs(), context);
    }

    updateEnabledState() {
        // Do nothing in base implementation
    }

    isEffectivelyEnabled(): boolean {
        return this.isEnabled;
    }

    get isPrimary(): boolean {
        return this.style === Enums.ActionStyle.Positive;
    }

    set isPrimary(value: boolean) {
        if (value) {
            this.style = Enums.ActionStyle.Positive;
        } else {
            if (this.style === Enums.ActionStyle.Positive) {
                this.style = Enums.ActionStyle.Default;
            }
        }
    }

    get hostConfig(): HostConfig {
        return this.parent ? this.parent.hostConfig : defaultHostConfig;
    }

    get parent(): CardElement | undefined {
        return this._parent as CardElement;
    }

    get state(): ActionButtonState {
        return this._state;
    }

    set state(value: ActionButtonState) {
        if (this._state !== value) {
            this._state = value;

            this.updateCssClasses();
        }
    }

    get isFocusable(): boolean {
        return this._isFocusable;
    }

    set isFocusable(value: boolean) {
        if (this._isFocusable !== value) {
            this._isFocusable = value;

            this.updateCssClasses();
        }
    }
}

export abstract class SubmitActionBase extends Action {
    //#region Schema

    static readonly dataProperty = new PropertyDefinition(Versions.v1_0, "data");
    static readonly associatedInputsProperty = new CustomProperty(
        Versions.v1_3,
        "associatedInputs",
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            const value = source[prop.name] as string;

            if (value !== undefined && typeof value === "string") {
                return value.toLowerCase() === "none" ? "none" : "auto";
            }

            return undefined;
        },
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            target: PropertyBag,
            value: string | undefined,
            context: BaseSerializationContext
        ) => {
            context.serializeValue(target, prop.name, value);
        }
    );
    static readonly disabledUnlessAssociatedInputsChangeProperty = new BoolProperty(
        Versions.v1_6,
        "disabledUnlessAssociatedInputsChange",
        false
    );

    @property(SubmitActionBase.dataProperty)
    private _originalData?: PropertyBag;

    @property(SubmitActionBase.associatedInputsProperty)
    associatedInputs?: "auto" | "none";

    @property(SubmitActionBase.disabledUnlessAssociatedInputsChangeProperty)
    disabledUnlessAssociatedInputsChange: boolean = false;

    //#endregion

    private _isPrepared: boolean = false;
    private _processedData?: PropertyBag;
    private _areReferencedInputsDirty: boolean = false;

    protected internalGetReferencedInputs(): Dictionary<Input> {
        const result: Dictionary<Input> = {};

        if (this.associatedInputs !== "none") {
            let current: CardElement | undefined = this.parent;
            let inputs: Input[] = [];

            while (current) {
                inputs.push(...current.getAllInputs(false));

                current = current.parent;
            }

            for (const input of inputs) {
                if (input.id) {
                    result[input.id] = input;
                }
            }
        }

        return result;
    }

    protected internalPrepareForExecution(inputs: Dictionary<Input> | undefined) {
        if (this._originalData) {
            this._processedData = JSON.parse(JSON.stringify(this._originalData));
        } else {
            this._processedData = {};
        }

        if (this._processedData && inputs) {
            for (const key of Object.keys(inputs)) {
                const input = inputs[key];

                if (input.id && input.isSet()) {
                    try {
                        this._processedData[input.id] =
                            typeof input.value === "string" ? input.value : input.value.toString();
                    }catch (e) {
                    }
                }
            }
        }

        this._isPrepared = true;
    }

    protected internalAfterExecute() {
        if (GlobalSettings.resetInputsDirtyStateAfterActionExecution) {
            this.resetReferencedInputsDirtyState();
        }
    }

    resetReferencedInputsDirtyState() {
        let referencedInputs = this.getReferencedInputs();

        this._areReferencedInputsDirty = false;

        if (referencedInputs) {
            for (const key of Object.keys(referencedInputs)) {
                const input = referencedInputs[key];

                input.resetDirtyState();
            }
        }
    }

    updateEnabledState() {
        this._areReferencedInputsDirty = false;

        let referencedInputs = this.getReferencedInputs();

        if (referencedInputs) {
            for (const key of Object.keys(referencedInputs)) {
                const input = referencedInputs[key];

                if (input.isDirty()) {
                    this._areReferencedInputsDirty = true;

                    break;
                }
            }
        }

        this.updateCssClasses();

        if (this._renderedElement) {
            this.setupElementForAccessibility(this._renderedElement);
        }
    }

    isEffectivelyEnabled(): boolean {
        let result = super.isEffectivelyEnabled();

        return this.disabledUnlessAssociatedInputsChange
            ? result && this._areReferencedInputsDirty
            : result;
    }

    get data(): object | undefined {
        return this._isPrepared ? this._processedData : this._originalData;
    }

    set data(value: object | undefined) {
        this._originalData = value as PropertyBag;
        this._isPrepared = false;
    }
}

export class SubmitAction extends SubmitActionBase {
    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Action.Submit" = "Action.Submit";

    getJsonTypeName(): string {
        return SubmitAction.JsonTypeName;
    }
}

export abstract class UniversalAction extends SubmitActionBase {
    // This is the base class for all actions that can be executed via the
    // adaptiveCards/action activity
}

export class ExecuteAction extends UniversalAction {
    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Action.Execute" = "Action.Execute";

    //#region Schema

    static readonly verbProperty = new StringProperty(Versions.v1_4, "verb");

    @property(ExecuteAction.verbProperty)
    verb?: string;

    //#endregion

    getJsonTypeName(): string {
        return ExecuteAction.JsonTypeName;
    }
}

export class DataQuery extends UniversalAction {
    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Data.Query" = "Data.Query";

    //#region Schema

    static readonly datasetProperty = new StringProperty(Versions.v1_6, "dataset");
    static readonly filterProperty = new StringProperty(Versions.v1_6, "filter");
    static readonly countProperty = new NumProperty(Versions.v1_6, "count");
    static readonly skipProperty = new NumProperty(Versions.v1_6, "skip");

    @property(DataQuery.datasetProperty)
    dataset: string|undefined;

    @property(DataQuery.filterProperty)
    filter: string|undefined;

    @property(DataQuery.countProperty)
    count?: number;

    @property(DataQuery.skipProperty)
    skip?: number;

    //#endregion

    getJsonTypeName(): string {
        return DataQuery.JsonTypeName;
    }

    get isStandalone(): boolean {
        return false;
    }
}

export class OpenUrlAction extends Action {
    //#region Schema

    static readonly urlProperty = new StringProperty(Versions.v1_0, "url");

    @property(OpenUrlAction.urlProperty)
    url?: string;

    //#endregion

    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Action.OpenUrl" = "Action.OpenUrl";

    getJsonTypeName(): string {
        return OpenUrlAction.JsonTypeName;
    }

    getAriaRole(): string {
        let ariaRole = this.getAriaRoleFromEnum();
        return ariaRole ?? "link";
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        if (!this.url) {
            context.addFailure(
                this,
                Enums.ValidationEvent.PropertyCantBeNull,
                Strings.errors.propertyMustBeSet("url")
            );
        }
    }

    getHref(): string | undefined {
        return this.url;
    }
}

export class ToggleVisibilityAction extends Action {
    //#region Schema

    static readonly targetElementsProperty = new CustomProperty<PropertyBag>(
        Versions.v1_2,
        "targetElements",
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            const result: PropertyBag = {};

            if (Array.isArray(source[prop.name])) {
                for (let i = 0; i < source[prop.name].length; i++) {
                    if (typeof source[prop.name][i] === "string") {
                        result[source[prop.name][i]] = undefined;
                    } else if (typeof source[prop.name][i] === "object") {
                        const elementId:string = source[prop.name][i]["elementId"];

                        if (typeof elementId === "string") {
                            result[elementId] = Utils.parseBool(source[prop.name][i]["isVisible"]);
                        }
                    }
                }
            }

            return result;
        },
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            target: PropertyBag,
            value: PropertyBag,
            context: BaseSerializationContext
        ) => {
            const targetElements: ESObject[] = [];

            for (const id of Object.keys(value)) {
                if (typeof value[id] === "boolean") {
                    targetElements.push({
                        elementId: id,
                        isVisible: value[id]
                    });
                } else {
                    targetElements.push(id);
                }
            }

            context.serializeArray(target, prop.name, targetElements);
        },
        {},
        (sender: SerializableObject) => {
            return {};
        }
    );

    @property(ToggleVisibilityAction.targetElementsProperty)
    targetElements:  Record< string , ESObject>= {};


    //#endregion

    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Action.ToggleVisibility" = "Action.ToggleVisibility";

    private updateAriaControlsAttribute() {
        // apply aria labels to make it clear which elements this action will toggle
        if (this.targetElements) {
            const elementIds = Object.keys(this.targetElements);

            if (this._renderedElement) {
                if (elementIds.length > 0) {
                    this._renderedElement.commonAttribute.customProperty("aria-controls", elementIds.join(" "));
                } else {
                    this._renderedElement.commonAttribute.customProperty("aria-controls",{});
                }
            }
        }
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        if (!this.targetElements) {
            context.addFailure(
                this,
                Enums.ValidationEvent.PropertyCantBeNull,
                Strings.errors.propertyMustBeSet("targetElements")
            );
        }
    }

    getJsonTypeName(): string {
        return ToggleVisibilityAction.JsonTypeName;
    }

    render(context:UIContext) {
        super.render(context);

        this.updateAriaControlsAttribute();
    }

    execute(context:UIContext) {
        super.execute(context);
        if (this.parent) {
            for (const elementId of Object.keys(this.targetElements)) {
                const targetElement = this.parent.getRootElement().getElementById(elementId);

                if (targetElement) {
                    if (typeof this.targetElements[elementId] === "boolean") {
                        targetElement.isVisible = this.targetElements[elementId];
                    } else {
                        targetElement.isVisible = !targetElement.isVisible;
                    }
                }
            }
        }
    }

    addTargetElement(elementId: string, isVisible: boolean | undefined = undefined) {
        this.targetElements[elementId] = isVisible;
        this.updateAriaControlsAttribute();
    }

    removeTargetElement(elementId: string) {
        Utils.DeleteRecord(this.targetElements,elementId)

        this.updateAriaControlsAttribute();
    }
}

class StringWithSubstitutionProperty extends PropertyDefinition {
    parse(
        sender: SerializableObject,
        source: PropertyBag,
        context: BaseSerializationContext
    ): StringWithSubstitutions {
        const result = new StringWithSubstitutions();
        result.set(Utils.parseString(source[this.name]));

        return result;
    }

    toJSON(
        sender: SerializableObject,
        target: PropertyBag,
        value: StringWithSubstitutions,
        context: BaseSerializationContext
    ): void {
        context.serializeValue(target, this.name, value.getOriginal());
    }

    constructor( targetVersion: Version, name: string) {
        super(targetVersion, name, undefined, () => {
            return new StringWithSubstitutions();
        });
    }
}


export class ShowCardAction extends Action {
    // Note the "weird" way this field is declared is to work around a breaking
    // change introduced in TS 3.1 wrt d.ts generation. DO NOT CHANGE
    static readonly JsonTypeName: "Action.ShowCard" = "Action.ShowCard";

    protected updateCssClasses() {
        super.updateCssClasses();

        if (this.renderedElement) {
            const effectiveHostConfig = this.parent ? this.parent.hostConfig : defaultHostConfig;

        }
    }

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        super.internalParse(source, context);

        const jsonCard = source["card"] as PropertyBag;

        if (jsonCard) {
            this.card.parse(jsonCard, context);
        } else {
            context.logParseEvent(
                this,
                Enums.ValidationEvent.PropertyCantBeNull,
                Strings.errors.showCardMustHaveCard()
            );
        }
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        if (this.card) {
            context.serializeValue(target, "card", this.card.toJSON(context));
        }
    }

    protected raiseExecuteActionEvent(context: UIContext) {
        if (this.hostConfig.actions.showCard.actionMode === Enums.ShowCardActionMode.Popup) {
            // Only raise the event in Popup mode.
            super.raiseExecuteActionEvent(context);
        }
    }

    readonly card: AdaptiveCard = new InlineAdaptiveCard();

    releaseDOMResources() {
        super.releaseDOMResources();

        this.card.releaseDOMResources();
    }

    getJsonTypeName(): string {
        return ShowCardAction.JsonTypeName;
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        this.card.internalValidateProperties(context);
    }

    setParent(value: CardElement) {
        super.setParent(value);

        this.card.setParent(value);
    }

    getAllInputs(processActions: boolean = true): Input[] {
        return this.card.getAllInputs(processActions);
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        result.push(...this.card.getAllActions());

        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        let result = super.getResourceInformation();

        result.push(...this.card.getResourceInformation());

        return result;
    }

    getActionById(id: string): Action | undefined {
        let result = super.getActionById(id);

        if (!result) {
            result = this.card.getActionById(id);
        }

        return result;
    }
}


class ActionCollection {
    private _owner: CardElement;
    private _actionCardContainer: FrameNode | null = null;
    private _expandedAction?: ShowCardAction;
    private _actionCard?: FrameNode;

    private isActionAllowed(action: Action): boolean {
        const forbiddenTypes = this._owner.getForbiddenActionTypes();

        if (forbiddenTypes) {
            for (const forbiddenType of forbiddenTypes) {
                if (action === forbiddenType) {
                    return false;
                }
            }
        }
        return true;
    }

    private refreshContainer() {
        clearElement(this._actionCardContainer);
        if (!this._actionCard) {
            // this._actionCardContainer.style.marginTop = "0px";
            this._actionCardContainer?.commonAttribute.margin({top:0});
            return;
        }

        let top = this.renderedActionCount > 0
            ? this._owner.hostConfig.actions.showCard.inlineTopMargin
            : "0px";
        this._actionCardContainer?.commonAttribute.margin({top:top});

        const padding = this._owner.getEffectivePadding();

        this._owner.getImmediateSurroundingPadding(padding);

        const physicalPadding =
            this._owner.hostConfig.paddingDefinitionToSpacingDefinition(padding);

        if (this._actionCard) {
            Utils.appendChild(this._actionCardContainer, this._actionCard);
        }
    }

    private layoutChanged() {
        this._owner.getRootElement().updateLayout();
    }

    private showActionCard(context:UIContext,
        action: ShowCardAction,
        suppressStyle: boolean = false,
        raiseEvent: boolean = true
    ) {
        (action.card as InlineAdaptiveCard).suppressStyle = suppressStyle;

        // Always re-render a ShowCard action in design mode; reuse already rendered ShowCard (if available) otherwise
        const renderedCard: FrameNode | undefined =
            action.card.renderedElement && !this._owner.isDesignMode()
                ? action.card.renderedElement
                : action.card.render(context);

        this._actionCard = renderedCard;
        this._expandedAction = action;

        this.refreshContainer();

        if (raiseEvent) {
            this.layoutChanged();

            raiseInlineCardExpandedEvent(action, true);
        }
    }

    private collapseExpandedAction() {
        for (const action of this._renderedActions) {
            action.state = ActionButtonState.Normal;
        }

        const previouslyExpandedAction = this._expandedAction;

        this._expandedAction = undefined;
        this._actionCard = undefined;

        this.refreshContainer();

        if (previouslyExpandedAction) {
            this.layoutChanged();

            raiseInlineCardExpandedEvent(previouslyExpandedAction, false);
        }
    }

    private expandShowCardAction(context:UIContext, action: ShowCardAction, raiseEvent: boolean) {
        let afterSelectedAction = false;

        for (const renderedAction of this._renderedActions) {
            // Remove actions after selected action from tabOrder if the actions are oriented horizontally, to skip focus directly to expanded card
            if (
                this._owner.hostConfig.actions.actionsOrientation == Enums.Orientation.Horizontal &&
                afterSelectedAction
            ) {
                renderedAction.isFocusable = false;
            }

            if (renderedAction !== action) {
                renderedAction.state = ActionButtonState.Subdued;
            } else {
                renderedAction.state = ActionButtonState.Expanded;

                afterSelectedAction = true;

                if (renderedAction.renderedElement) {
                    renderedAction.renderedElement.commonEvent.setOnBlur(()=>{
                        for (const ra of this._renderedActions) {
                                ra.isFocusable = true;
                        }
                    })
                }
            }
        }

        this.showActionCard(context,
            action,
            !(this._owner.isAtTheVeryLeft() && this._owner.isAtTheVeryRight()),
            raiseEvent
        );
    }

    private _items: Action[] = [];
    // private _overflowAction?: OverflowAction;
    private _renderedActions: Action[] = [];

    constructor(owner: CardElement) {
        this._owner = owner;
    }

    releaseDOMResources() {
        for (let action of this._renderedActions) {
            action.releaseDOMResources();
        }
    }

    actionExecuted(context:UIContext, action: Action) {
        if (!(action instanceof ShowCardAction)) {
            this.collapseExpandedAction();
        } else {
            if (action === this._expandedAction) {
                this.collapseExpandedAction();
            } else if (
                this._owner.hostConfig.actions.showCard.actionMode ===
                Enums.ShowCardActionMode.Inline
            ) {
                this.expandShowCardAction(context, action, true);
            }
        }
    }

    parse(source: PropertyBag, context: SerializationContext) {
        this.clear();

        if (Array.isArray(source)) {
            source.forEach((item:PropertyBag) => {
                LogUtils.getInstance().info("parseAction item "+JSON.stringify(item))
                let forbiddenActions: string[] = [];

                // If the action owner is a ContainerWithActions, we should check for forbidden actions
                if (this._owner instanceof ContainerWithActions) {
                    forbiddenActions = this._owner.getForbiddenActionNames();
                }

                const action = context.parseAction(
                    this._owner,
                    item,
                    forbiddenActions,
                    !this._owner.isDesignMode()
                );

                if (action) {
                    this.addAction(action);
                }
            });
        }
    }

    toJSON(target: PropertyBag, propertyName: string, context: SerializationContext): void {
        context.serializeArray(target, propertyName, this._items);
    }

    getActionAt(id: number): Action | undefined {
        return this._items[id];
    }

    getActionCount(): number {
        return this._items.length;
    }

    getActionById(id: string): Action | undefined {
        let result: Action | undefined = undefined;

        for (const item of this._items) {
            result = item.getActionById(id);

            if (result) {
                break;
            }
        }

        return result;
    }

    validateProperties(context: ValidationResults) {
        if (
            this._owner.hostConfig.actions.maxActions &&
            this._items.length > this._owner.hostConfig.actions.maxActions
        ) {
            context.addFailure(
                this._owner,
                Enums.ValidationEvent.TooManyActions,
                Strings.errors.tooManyActions(this._owner.hostConfig.actions.maxActions)
            );
        }

        if (this._items.length > 0 && !this._owner.hostConfig.supportsInteractivity) {
            context.addFailure(
                this._owner,
                Enums.ValidationEvent.InteractivityNotAllowed,
                Strings.errors.interactivityNotAllowed()
            );
        }

        for (const item of this._items) {
            if (!this.isActionAllowed(item)) {
                context.addFailure(
                    this._owner,
                    Enums.ValidationEvent.ActionTypeNotAllowed,
                    Strings.errors.actionTypeNotAllowed(item.getJsonTypeName())
                );
            }

            item.internalValidateProperties(context);
        }
    }

    render(context:UIContext,orientation: Enums.Orientation): FrameNode | undefined {
        // Cache hostConfig for better perf
        const hostConfig = this._owner.hostConfig;

        if (!hostConfig.supportsInteractivity) {
            return undefined;
        }

        const element = typeNode.createNode(context,"Column")
        element.attribute.alignItems(HorizontalAlign.Start)
        const maxActions = hostConfig.actions.maxActions
            ? Math.min(hostConfig.actions.maxActions, this._items.length)
            : this._items.length;

        this._actionCardContainer = typeNode.createNode(context,"Stack")

        this._renderedActions = [];

        if (
            hostConfig.actions.preExpandSingleShowCardAction &&
            maxActions === 1 &&
            this._items[0] instanceof ShowCardAction &&
            this.isActionAllowed(this._items[0])
        ) {
            this._renderedActions.push(this._items[0]);
        } else {
            const buttonStrip = typeNode.createNode(context,"Flex");
            if (orientation === Enums.Orientation.Horizontal) {
                if (
                    this._owner.horizontalAlignment &&
                    hostConfig.actions.actionAlignment !== Enums.ActionAlignment.Stretch
                ) {
                    switch (this._owner.horizontalAlignment) {
                        case Enums.HorizontalAlignment.Center:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.Center})
                            break;
                        case Enums.HorizontalAlignment.Right:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.End})
                            break;
                        default:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.Start})
                            break;
                    }
                } else {
                    switch (hostConfig.actions.actionAlignment) {
                        case Enums.ActionAlignment.Center:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.Center})
                            break;
                        case Enums.ActionAlignment.Right:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.End})
                            break;
                        default:
                            buttonStrip.initialize({direction:FlexDirection.Row, justifyContent:FlexAlign.Start})
                            break;
                    }
                }
            } else {
                if (
                    this._owner.horizontalAlignment &&
                    hostConfig.actions.actionAlignment !== Enums.ActionAlignment.Stretch
                ) {
                    switch (this._owner.horizontalAlignment) {
                        case Enums.HorizontalAlignment.Center:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.Center})
                            break;
                        case Enums.HorizontalAlignment.Right:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.End})
                            break;
                        default:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.Start})
                            break;
                    }
                } else {
                    switch (hostConfig.actions.actionAlignment) {
                        case Enums.ActionAlignment.Center:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.Center})
                            break;
                        case Enums.ActionAlignment.Right:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.End})
                            break;
                        case Enums.ActionAlignment.Stretch:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.Stretch})
                            break;
                        default:
                            buttonStrip.initialize({direction:FlexDirection.Column, alignItems:ItemAlign.Start})
                            break;
                    }
                }
            }

            const allowedActions = this._items.filter(this.isActionAllowed.bind(this));

            let primaryActions: Action[] = [];
            const secondaryActions: Action[] = [];

            if (!this._owner.isDesignMode()) {
                allowedActions.forEach((action) =>
                    action.mode === Enums.ActionMode.Secondary
                        ? secondaryActions.push(action)
                        : primaryActions.push(action)
                );

                // If primaryActions.length > maxActions, extra actions are moved to overflow
                const overflowPrimaryActions = primaryActions.splice(hostConfig.actions.maxActions);

                if (GlobalSettings.allowMoreThanMaxActionsInOverflowMenu) {
                    secondaryActions.push(...overflowPrimaryActions);
                }

            } else {
                primaryActions = allowedActions;
            }

            for (let i = 0; i < primaryActions.length; i++) {
                const action = primaryActions[i];
                action.render(context);

                if (action.renderedElement) {
                    if (
                        hostConfig.actions.actionsOrientation === Enums.Orientation.Horizontal &&
                        hostConfig.actions.actionAlignment === Enums.ActionAlignment.Stretch
                    ) {
                        action.renderedElement.commonAttribute.flexGrow(0);
                        action.renderedElement.commonAttribute.flexShrink(1);
                        action.renderedElement.commonAttribute.flexBasis('100%');
                    } else {
                        action.renderedElement.commonAttribute.flexGrow(0);
                        action.renderedElement.commonAttribute.flexShrink(1);
                        action.renderedElement.commonAttribute.flexBasis('auto');
                    }

                    buttonStrip.appendChild(action.renderedElement);

                    this._renderedActions.push(action);

                    if (i < primaryActions.length - 1 && hostConfig.actions.buttonSpacing > 0) {
                        const spacer = typeNode.createNode(context,"Flex");
                        if (orientation === Enums.Orientation.Horizontal) {
                            spacer.commonAttribute.flexGrow(0);
                            spacer.commonAttribute.flexShrink(1);
                            spacer.commonAttribute.flexBasis('auto');
                            spacer.commonAttribute.width(hostConfig.actions.buttonSpacing + "px");
                        } else {
                            spacer.commonAttribute.height(hostConfig.actions.buttonSpacing + "px");
                        }
                        Utils.appendChild(buttonStrip, spacer);
                    }
                }
            }

            const buttonStripParentContainer = typeNode.createNode(context,"Flex");
            buttonStripParentContainer.initialize({alignItems:ItemAlign.Start,justifyContent:FlexAlign.Start})
            const buttonStripContainer = typeNode.createNode(context,"Scroll");
            if(orientation == Enums.Orientation.Horizontal) {
                buttonStripContainer.attribute.scrollable(ScrollDirection.Horizontal);
            }
            else{
                buttonStripContainer.attribute.scrollable(ScrollDirection.Vertical);
            }
            buttonStripContainer.attribute.scrollBar(BarState.Off);
            buttonStripContainer.appendChild(buttonStrip);
            buttonStripParentContainer.appendChild(buttonStripContainer);
            Utils.appendChild(element, buttonStripParentContainer);
        }

        Utils.appendChild(element, this._actionCardContainer);

        for (const renderedAction of this._renderedActions) {
            if (renderedAction.state === ActionButtonState.Expanded) {
                this.expandShowCardAction(context, renderedAction as ShowCardAction, false);
                break;
            }
        }
        return this._renderedActions.length > 0 ? element : undefined;
    }

    addAction(action: Action) {
        if (!action) {
            throw new Error("The action parameter cannot be null.");
        }

        if ((!action.parent || action.parent === this._owner) && this._items.indexOf(action) < 0) {
            this._items.push(action);

            if (!action.parent) {
                action.setParent(this._owner);
            }

            action._actionCollection = this;
        } else {
            throw new Error(Strings.errors.actionAlreadyParented());
        }
    }

    removeAction(action: Action): boolean {
        if (this.expandedAction && this._expandedAction === action) {
            this.collapseExpandedAction();
        }

        const actionIndex = this._items.indexOf(action);

        if (actionIndex >= 0) {
            this._items.splice(actionIndex, 1);

            action.setParent(undefined);

            for (let i = 0; i < this._renderedActions.length; i++) {
                if (this._renderedActions[i] === action) {
                    this._renderedActions.splice(i, 1);

                    break;
                }
            }

            return true;
        }
        return false;
    }

    clear() {
        this._items = [];
        this._renderedActions = [];
        this._expandedAction = undefined;
    }

    getAllInputs(processActions: boolean = true): Input[] {
        let result: Input[] = [];

        if (processActions) {
            for (const action of this._items) {
                result.push(...action.getAllInputs());
            }
        }

        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        let result: IResourceInformation[] = [];

        for (const action of this._items) {
            result.push(...action.getResourceInformation());
        }

        return result;
    }

    get renderedActionCount(): number {
        return this._renderedActions.length;
    }

    get expandedAction(): ShowCardAction | undefined {
        return this._expandedAction;
    }
}

export class ActionSet extends CardElement {
    //#region Schema

    static readonly orientationProperty = new EnumProperty(
        Versions.v1_1,
        "orientation",
        Enums.Orientation
    );

    @property(ActionSet.orientationProperty)
    orientation?: Enums.Orientation;

    //#endregion

    private _actionCollection: ActionCollection;

    protected internalParse(source: ESObject, context: SerializationContext) {
        super.internalParse(source, context);

        this._actionCollection.parse(source["actions"], context);
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        this._actionCollection.toJSON(target, "actions", context);
    }

    protected internalRender(context: UIContext): FrameNode | undefined {
        return this._actionCollection.render(context,
            this.orientation !== undefined
                ? this.orientation
                : this.hostConfig.actions.actionsOrientation
        );
    }

    constructor() {
        super();
        this._actionCollection = new ActionCollection(this);
    }

    releaseDOMResources() {
        super.releaseDOMResources();

        this._actionCollection.releaseDOMResources();
    }

    isBleedingAtBottom(): boolean {
        if (this._actionCollection.renderedActionCount === 0) {
            return super.isBleedingAtBottom();
        } else {
            if (this._actionCollection.getActionCount() === 1) {
                return (
                    this._actionCollection.expandedAction !== undefined &&
                        !this.hostConfig.actions.preExpandSingleShowCardAction
                );
            } else {
                return this._actionCollection.expandedAction !== undefined;
            }
        }
    }

    getJsonTypeName(): string {
        return "ActionSet";
    }

    getActionCount(): number {
        return this._actionCollection.getActionCount();
    }

    getActionAt(index: number): Action | undefined {
        if (index >= 0 && index < this.getActionCount()) {
            return this._actionCollection.getActionAt(index);
        } else {
            return super.getActionAt(index);
        }
    }

    getActionById(id: string): Action | undefined {
        const result: Action | undefined = this._actionCollection.getActionById(id);

        return result ? result : super.getActionById(id);
    }

    getAllActions(): Action[] {
        const result = super.getAllActions();

        for (let i = 0; i < this.getActionCount(); i++) {
            let action = this.getActionAt(i);

            if (action) {
                result.push(action);
            }
        }

        return result;
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        this._actionCollection.validateProperties(context);
    }

    addAction(action: Action) {
        this._actionCollection.addAction(action);
    }

    getAllInputs(processActions: boolean = true): Input[] {
        return processActions ? this._actionCollection.getAllInputs() : [];
    }

    getResourceInformation(): IResourceInformation[] {
        return this._actionCollection.getResourceInformation();
    }

    /**
     * @inheritdoc
     */
    findDOMNodeOwner(node: FrameNode): CardObject | undefined {
        let target: CardObject | undefined = undefined;

        for (let i = 0; i < this.getActionCount(); i++) {
            const action = this.getActionAt(i);

            if (action) {
                // recur through each Action
                target = action.findDOMNodeOwner(node);

                if (target) {
                    return target;
                }
            }
        }

        // if not found in any Action, defer to parent implementation
        return super.findDOMNodeOwner(node);
    }

    getElementById(id: string): CardElement | undefined {
        let result = super.getElementById(id);

        if (!result) {
            result = this.getElementByIdFromAction(id);
        }

        return result;
    }

    get isInteractive(): boolean {
        return true;
    }
}

export class ContainerStyleProperty extends ValueSetProperty {

    readonly defaultValue?: string;
    readonly onGetInitialValue?: (sender: SerializableObject) => string

    constructor(
        targetVersion: Version,
        name: string,
        defaultValue?: string,
        onGetInitialValue?: (sender: SerializableObject) => string
    ) {
        super(
            targetVersion,
            name,
            [
                { value: Enums.ContainerStyle.Default },
                { value: Enums.ContainerStyle.Emphasis },
                { targetVersion: Versions.v1_2, value: Enums.ContainerStyle.Accent },
                { targetVersion: Versions.v1_2, value: Enums.ContainerStyle.Good },
                { targetVersion: Versions.v1_2, value: Enums.ContainerStyle.Attention },
                { targetVersion: Versions.v1_2, value: Enums.ContainerStyle.Warning }
            ],
            defaultValue,
            onGetInitialValue
        );
    }
}

export abstract class StylableCardElementContainer extends CardElementContainer {
    //#region Schema

    static readonly styleProperty = new ContainerStyleProperty(Versions.v1_0, "style");

    @property(StylableCardElementContainer.styleProperty)
    get style(): string | undefined {
        if (this.allowCustomStyle) {
            const style:ESObject = this.getValue(StylableCardElementContainer.styleProperty);

            if (style && this.hostConfig.containerStyles.getStyleByName(style)) {
                return style;
            }
        }

        return undefined;
    }

    set style(value: string | undefined) {
        this.setValue(StylableCardElementContainer.styleProperty, value);
    }

    //#endregion

    protected get allowCustomStyle(): boolean {
        return true;
    }

    protected get hasExplicitStyle(): boolean {
        return this.getValue(StylableCardElementContainer.styleProperty) !== undefined;
    }

    protected applyBorder() {
        // No border in base implementation
    }

    protected applyBackground() {
        if (this.renderedElement) {
            const styleDefinition = this.hostConfig.containerStyles.getStyleByName(
                this.style,
                this.hostConfig.containerStyles.getStyleByName(this.defaultStyle)
            );

            if (styleDefinition.backgroundColor) {
                const bgColor = Utils.stringToCssColor(styleDefinition.backgroundColor);
                if (bgColor) {
                    this.renderedElement.commonAttribute.backgroundColor(bgColor);
                }
            }
        }
    }

    protected applyPadding() {
        super.applyPadding();

        if (!this.renderedElement) {
            return;
        }

        let physicalPadding = new SpacingDefinition();

        if (this.getEffectivePadding()) {
            physicalPadding = this.hostConfig.paddingDefinitionToSpacingDefinition(
                this.getEffectivePadding()
            );
        }

        this.renderedElement.commonAttribute.padding({top:physicalPadding.top, right:physicalPadding.right,
            bottom:physicalPadding.bottom, left:physicalPadding.left});
        if (this.isBleeding()) {
            // Bleed into the first parent that does have padding
            const padding = new PaddingDefinition();

            this.getImmediateSurroundingPadding(padding);

            const surroundingPadding =
                this.hostConfig.paddingDefinitionToSpacingDefinition(padding);

            this.renderedElement.commonAttribute.margin({left:-surroundingPadding.left, right:-surroundingPadding.right});
            if (!this.isDesignMode()) {
                this.renderedElement.commonAttribute.margin({top:-surroundingPadding.top, bottom:-surroundingPadding.bottom});
            }

            if (
                this.separatorElement &&
                    this.separatorOrientation === Enums.Orientation.Horizontal
            ) {
                this.renderedElement.commonAttribute.margin({left:-surroundingPadding.left, right:-surroundingPadding.right});
            }
        } else {
            this.renderedElement.commonAttribute.margin({left:0, right:0, top:0, bottom:0});
            if (
                this.separatorElement &&
                    this.separatorOrientation === Enums.Orientation.Horizontal
            ) {
                this.renderedElement.commonAttribute.margin({left:0, right:0});
            }
        }
    }

    protected getHasBackground(ignoreBackgroundImages: boolean = false): boolean {
        let currentElement: CardElement | undefined = this.parent;

        while (currentElement) {
            let currentElementHasBackgroundImage: boolean = false;

            if (ignoreBackgroundImages) {
                currentElementHasBackgroundImage = false;
            } else {
                currentElementHasBackgroundImage =
                    currentElement instanceof Container
                        ? currentElement.backgroundImage.isValid()
                        : false;
            }

            if (currentElement instanceof StylableCardElementContainer) {
                if (
                    this.hasExplicitStyle &&
                        (currentElement.getEffectiveStyle() !== this.getEffectiveStyle() ||
                            currentElementHasBackgroundImage)
                ) {
                    return true;
                }
            }

            currentElement = currentElement.parent;
        }
        return false
    }

    protected getDefaultPadding(): PaddingDefinition {
        return this.getHasBackground() || this.getHasBorder()
            ? new PaddingDefinition(
                Enums.Spacing.Padding,
                Enums.Spacing.Padding,
                Enums.Spacing.Padding,
                Enums.Spacing.Padding
            )
            : super.getDefaultPadding();
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        const explicitStyle = this.getValue(StylableCardElementContainer.styleProperty) as string;

        if (explicitStyle !== undefined) {
            const styleDefinition = this.hostConfig.containerStyles.getStyleByName(explicitStyle);

            if (!styleDefinition) {
                context.addFailure(
                    this,
                    Enums.ValidationEvent.InvalidPropertyValue,
                    Strings.errors.invalidPropertyValue(explicitStyle, "style")
                );
            }
        }
    }

    render(context:UIContext): FrameNode | undefined {
        const renderedElement = super.render(context);

        if (renderedElement && this.getHasBackground()) {
            this.applyBackground();
        }

        this.applyBorder();

        return renderedElement;
    }

    getEffectiveStyle(): string {
        const effectiveStyle = this.style;

        return effectiveStyle ? effectiveStyle : super.getEffectiveStyle();
    }
}

export abstract class ContainerBase extends StylableCardElementContainer {
    //#region Schema

    static readonly bleedProperty = new BoolProperty(Versions.v1_2, "bleed", false);
    static readonly minHeightProperty = new PixelSizeProperty(Versions.v1_2, "minHeight");

    @property(ContainerBase.bleedProperty)
    private _bleed: boolean = false;

    @property(ContainerBase.minHeightProperty)
    minPixelHeight?: number;

    //#endregion

    protected adjustRenderedElementSize(renderedElement: FrameNode) {
        super.adjustRenderedElementSize(renderedElement);
        renderedElement.commonAttribute.constraintSize({
            minWidth: '100%',
            minHeight: this.minPixelHeight
        })
    }

    protected getHasExpandedAction(): boolean {
        return false;
    }

    protected getBleed(): boolean {
        return this._bleed;
    }

    protected setBleed(value: boolean) {
        this._bleed = value;
    }

    protected get renderedActionCount(): number {
        return 0;
    }

    isBleeding(): boolean {
        return (this.getHasBackground() || this.hostConfig.alwaysAllowBleed) && this.getBleed();
    }
}

export class BackgroundImage extends SerializableObject {
    //#region Schema

    static readonly urlProperty = new StringProperty(Versions.v1_0, "url");
    static readonly fillModeProperty = new EnumProperty(
        Versions.v1_2,
        "fillMode",
        Enums.FillMode,
        Enums.FillMode.Cover
    );
    static readonly horizontalAlignmentProperty = new EnumProperty(
        Versions.v1_2,
        "horizontalAlignment",
        Enums.HorizontalAlignment,
        Enums.HorizontalAlignment.Left
    );
    static readonly verticalAlignmentProperty = new EnumProperty(
        Versions.v1_2,
        "verticalAlignment",
        Enums.VerticalAlignment,
        Enums.VerticalAlignment.Top
    );

    @property(BackgroundImage.urlProperty)
    url?: string;

    @property(BackgroundImage.fillModeProperty)
    fillMode?: Enums.FillMode;

    @property(BackgroundImage.horizontalAlignmentProperty)
    horizontalAlignment?: Enums.HorizontalAlignment;

    @property(BackgroundImage.verticalAlignmentProperty)
    verticalAlignment?: Enums.VerticalAlignment;

    //#endregion

    protected getSchemaKey(): string {
        return "BackgroundImage";
    }

    protected internalParse(source: ESObject, context: BaseSerializationContext):void {
        if (typeof source === "string") {
            this.resetDefaultValues();
            this.url = source;
        } else {
            return super.internalParse(source, context);
        }
    }

    apply(element: CardElement) {
        if (this.url && element.renderedElement) {
            switch (this.fillMode) {
                case Enums.FillMode.Repeat:
                    element.renderedElement.commonAttribute.backgroundImage(element.preProcessPropertyValue(BackgroundImage.urlProperty, this.url),ImageRepeat.XY)
                    break;
                case Enums.FillMode.RepeatHorizontally:
                    element.renderedElement.commonAttribute.backgroundImage(
                        element.preProcessPropertyValue(BackgroundImage.urlProperty, this.url), ImageRepeat.X)
                    break;
                case Enums.FillMode.RepeatVertically:
                    element.renderedElement.commonAttribute.backgroundImage(
                        element.preProcessPropertyValue(BackgroundImage.urlProperty, this.url), ImageRepeat.Y)
                    break;
                case Enums.FillMode.Cover:
                default:
                    element.renderedElement.commonAttribute.backgroundImage(
                        element.preProcessPropertyValue(BackgroundImage.urlProperty, this.url), ImageRepeat.NoRepeat)
                    element.renderedElement.commonAttribute.backgroundImageSize(ImageSize.Cover)
                    break;
            }

            switch (this.horizontalAlignment) {
                case Enums.HorizontalAlignment.Left:
                    element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.Start)
                    break;
                case Enums.HorizontalAlignment.Center:
                    element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.Center)
                    break;
                case Enums.HorizontalAlignment.Right:
                    element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.End)
                    break;
            }

            switch (this.verticalAlignment) {
                case Enums.VerticalAlignment.Top:
                    if (this.horizontalAlignment == Enums.HorizontalAlignment.Left) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.TopStart)
                    } else if (this.horizontalAlignment == Enums.HorizontalAlignment.Center) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.Top)
                    } else if (this.horizontalAlignment == Enums.HorizontalAlignment.Right) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.TopEnd)
                    }
                    break;
                case Enums.VerticalAlignment.Center:
                    break;
                case Enums.VerticalAlignment.Bottom:
                    if (this.horizontalAlignment == Enums.HorizontalAlignment.Left) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.BottomStart)
                    } else if (this.horizontalAlignment == Enums.HorizontalAlignment.Center) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.Bottom)
                    } else if (this.horizontalAlignment == Enums.HorizontalAlignment.Right) {
                        element.renderedElement.commonAttribute.backgroundImagePosition(Alignment.BottomEnd)
                    }
                    break;
            }
        }
    }

    isValid(): boolean {
        return this.url ? true : false;
    }
}

export class Container extends ContainerBase {
    //#region Schema
    static readonly backgroundImageProperty = new SerializableObjectProperty(
        Versions.v1_0,
        "backgroundImage",
        BackgroundImage
    );
    static readonly verticalContentAlignmentProperty = new EnumProperty(
        Versions.v1_1,
        "verticalContentAlignment",
        Enums.VerticalAlignment
    );
    static readonly rtlProperty = new BoolProperty(Versions.v1_0, "rtl");

    @property(Container.backgroundImageProperty)
    get backgroundImage(): BackgroundImage {
        return this.getValue(Container.backgroundImageProperty);
    }

    @property(Container.verticalContentAlignmentProperty)
    verticalContentAlignment?: Enums.VerticalAlignment;

    @property(Container.rtlProperty)
    rtl?: boolean;

    //#endregion

    private _items: CardElement[] = [];
    private _renderedItems: CardElement[] = [];

    protected insertItemAt(item: CardElement, index: number, forceInsert: boolean) {
        if (!item.parent || forceInsert) {
            if (item.isStandalone) {
                if (index < 0 || index >= this._items.length) {
                    this._items.push(item);
                } else {
                    this._items.splice(index, 0, item);
                }

                item.setParent(this);
            } else {
                throw new Error(Strings.errors.elementTypeNotStandalone(item.getJsonTypeName()));
            }
        } else {
            throw new Error(Strings.errors.elementAlreadyParented());
        }
    }

    protected getItemsCollectionPropertyName(): string {
        return "items";
    }

    protected applyBackground() {
        if (this.backgroundImage.isValid() && this.renderedElement) {
            this.backgroundImage.apply(this);
        }
        super.applyBackground();
    }

    protected applyRTL(element: FrameNode|undefined) {
        if (this.rtl !== undefined) {
            // element.dir = this.rtl ? "rtl" : "ltr";
            element?.commonAttribute.direction(this.rtl ? Direction.Rtl : Direction.Ltr)
        }
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        this._renderedItems = [];
        LogUtils.getInstance().info("Container internalRender");

        // Cache hostConfig to avoid walking the parent hierarchy several times
        const hostConfig = this.hostConfig;
        const element = typeNode.createNode(context,"Column");

        if(this.minPixelHeight) {
            element.commonAttribute.constraintSize({
                minHeight: this.minPixelHeight,
            })
        }

        if(this.minPixelWidth) {
            element.commonAttribute.constraintSize({
                minWidth: this.minPixelWidth,
            })
        }


        this.applyRTL(element);



        switch (this.getEffectiveVerticalContentAlignment()) {
            case Enums.VerticalAlignment.Center:
                LogUtils.getInstance().info("Container Center")
                element.attribute.alignItems(HorizontalAlign.Center);
                break;
            case Enums.VerticalAlignment.Bottom:
                LogUtils.getInstance().info("Container End")
                element.attribute.alignItems(HorizontalAlign.End);
                break;
            default:
                LogUtils.getInstance().info("Container Start")
                element.attribute.alignItems(HorizontalAlign.Start);
                break;
        }

        if (this._items.length > 0) {
            for (const item of this._items) {
                const renderedItem = this.isElementAllowed(item) ? item.render(context) : undefined;

                if (renderedItem) {
                    if (this._renderedItems.length > 0 && item.separatorElement) {
                        element.attribute.flexGrow(0);
                        element.attribute.flexShrink(0);
                        element.attribute.flexBasis('auto');
                        Utils.appendChild(element, item.separatorElement);
                    }

                    Utils.appendChild(element, renderedItem);

                    this._renderedItems.push(item);
                }
            }
        } else {
            if (this.isDesignMode()) {
                const placeholderElement = this.createPlaceholderElement(context);
                placeholderElement.commonAttribute.width('100%')
                placeholderElement.commonAttribute.height('100%')

                element.appendChild(placeholderElement);
            }
        }

        return element;
    }

    protected truncateOverflow(maxHeight: number): boolean {
        if (this.renderedElement) {

            return true;
        }

        return false;
    }

    protected undoOverflowTruncation() {
    }

    protected getHasBackground(ignoreBackgroundImages: boolean = false): boolean {
        let result = ignoreBackgroundImages ? false : this.backgroundImage.isValid();

        return result || super.getHasBackground(ignoreBackgroundImages);

    }

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        super.internalParse(source, context);
        this.clear();
        this.setShouldFallback(false);

        let jsonItems = source[this.getItemsCollectionPropertyName()] as PropertyBag;

        if (Array.isArray(jsonItems)) {

            jsonItems.forEach((item:PropertyBag) => {
                LogUtils.getInstance().info("parseElement item "+JSON.stringify(item))
                const element = context.parseElement(
                    this,
                    item,
                    this.forbiddenChildElements(),
                    !this.isDesignMode()
                );

                if (element) {
                    this.insertItemAt(element, -1, true);
                }
            });
        }
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        const collectionPropertyName = this.getItemsCollectionPropertyName();

        context.serializeArray(target, collectionPropertyName, this._items);
    }

    protected get isSelectable(): boolean {
        return true;
    }

    getEffectivePadding(): PaddingDefinition {
        if (
            GlobalSettings.removePaddingFromContainersWithBackgroundImage &&
            !this.getHasBackground(true)
        ) {
            return new PaddingDefinition();
        }

        return super.getEffectivePadding();
    }

    getEffectiveVerticalContentAlignment(): Enums.VerticalAlignment {
        if (this.verticalContentAlignment !== undefined) {
            return this.verticalContentAlignment;
        }

        const parentContainer = this.getParentContainer();

        return parentContainer
            ? parentContainer.getEffectiveVerticalContentAlignment()
            : Enums.VerticalAlignment.Top;
    }

    getItemCount(): number {
        return this._items.length;
    }

    getItemAt(index: number): CardElement {
        return this._items[index];
    }

    getFirstVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedItems && this._renderedItems.length > 0) {
            for (const item of this._renderedItems) {
                if (item.isVisible) {
                    return item;
                }
            }
        }

        return undefined;
    }

    getLastVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedItems && this._renderedItems.length > 0) {
            for (let i = this._renderedItems.length - 1; i >= 0; i--) {
                if (this._renderedItems[i].isVisible) {
                    return this._renderedItems[i];
                }
            }
        }

        return undefined;
    }

    getJsonTypeName(): string {
        return "Container";
    }

    isFirstElement(element: CardElement): boolean {
        const designMode = this.isDesignMode();

        for (const item of this._items) {
            if (item.isVisible || designMode) {
                return item === element;
            }
        }

        return false;
    }

    isLastElement(element: CardElement): boolean {
        const designMode = this.isDesignMode();

        for (let i = this._items.length - 1; i >= 0; i--) {
            if (this._items[i].isVisible || designMode) {
                return this._items[i] === element;
            }
        }

        return false;
    }

    isRtl(): boolean {
        if (this.rtl !== undefined) {
            return this.rtl;
        } else {
            const parentContainer = this.getParentContainer();

            return parentContainer ? parentContainer.isRtl() : false;
        }
    }

    isBleedingAtTop(): boolean {
        const firstRenderedItem = this.getFirstVisibleRenderedItem();

        return (
            this.isBleeding() || (firstRenderedItem ? firstRenderedItem.isBleedingAtTop() : false)
        );
    }

    isBleedingAtBottom(): boolean {
        const lastRenderedItem = this.getLastVisibleRenderedItem();

        return (
            this.isBleeding() ||
            (lastRenderedItem
                ? lastRenderedItem.isBleedingAtBottom() &&
                  lastRenderedItem.getEffectiveStyle() === this.getEffectiveStyle()
                : false)
        );
    }

    indexOf(cardElement: CardElement): number {
        return this._items.indexOf(cardElement);
    }

    addItem(item: CardElement) {
        this.insertItemAt(item, -1, false);
    }

    insertItemBefore(item: CardElement, insertBefore: CardElement) {
        this.insertItemAt(item, this._items.indexOf(insertBefore), false);
    }

    insertItemAfter(item: CardElement, insertAfter: CardElement) {
        this.insertItemAt(item, this._items.indexOf(insertAfter) + 1, false);
    }

    removeItem(item: CardElement): boolean {
        const itemIndex = this._items.indexOf(item);

        if (itemIndex >= 0) {
            this._items.splice(itemIndex, 1);

            item.setParent(undefined);

            this.updateLayout();

            return true;
        }

        return false;
    }

    clear() {
        this._items = [];
        this._renderedItems = [];
    }

    getResourceInformation(): IResourceInformation[] {
        const result = super.getResourceInformation();
        if (this.backgroundImage.isValid()) {
            result.push({
                // eslint-disable-next-line @typescript-eslint/no-unnecessary-type-assertion -- validated by `isValid()`
                url: this.backgroundImage.url!,
                mimeType: "image"
            });
        }
        return result;
    }

    getActionById(id: string): Action | undefined {
        let result: Action | undefined = super.getActionById(id);

        if (!result) {
            if (this.selectAction) {
                result = this.selectAction.getActionById(id);
            }
            if (!result) {
                for (const item of this._items) {
                    result = item.getActionById(id);

                    if (result) {
                        break;
                    }
                }
            }
        }

        return result;
    }

    get padding(): PaddingDefinition | undefined {
        return this.getPadding();
    }

    set padding(value: PaddingDefinition | undefined) {
        this.setPadding(value);
    }

    get selectAction(): Action | undefined {
        return this._selectAction;
    }

    set selectAction(value: Action | undefined) {
        this._selectAction = value;
    }

    get bleed(): boolean {
        return this.getBleed();
    }

    set bleed(value: boolean) {
        this.setBleed(value);
    }
}

export type ColumnWidth = SizeAndUnit | "auto" | "stretch";

export class Column extends Container {
    //#region Schema

    static readonly widthProperty = new CustomProperty<ColumnWidth>(
        Versions.v1_0,
        "width",
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            let result: ColumnWidth = prop.defaultValue;
            const value:ESObject = source[prop.name];
            let invalidWidth = false;

            if (typeof value === "number" && !isNaN(value)) {
                result = new SizeAndUnit(value, Enums.SizeUnit.Weight);
            } else if (value === "auto" || value === "stretch") {
                result = value;
            } else if (typeof value === "string") {
                try {
                    result = SizeAndUnit.parse(value);

                    if (
                        result.unit === Enums.SizeUnit.Pixel &&
                        prop.targetVersion.compareTo(context.targetVersion) > 0
                    ) {
                        invalidWidth = true;
                    }
                } catch (e) {
                    invalidWidth = true;
                }
            } else {
                invalidWidth = true;
            }

            if (invalidWidth) {
                context.logParseEvent(
                    sender,
                    Enums.ValidationEvent.InvalidPropertyValue,
                    Strings.errors.invalidColumnWidth(value)
                );

                result = "auto";
            }

            return result;
        },
        (
            sender: SerializableObject,
            property: PropertyDefinition,
            target: PropertyBag,
            value: ColumnWidth,
            context: BaseSerializationContext
        ) => {
            if (value instanceof SizeAndUnit) {
                if (value.unit === Enums.SizeUnit.Pixel) {
                    context.serializeValue(target, "width", value.physicalSize + "px");
                } else {
                    context.serializeNumber(target, "width", value.physicalSize);
                }
            } else {
                context.serializeValue(target, "width", value);
            }
        },
        "stretch"
    );

    @property(Column.widthProperty)
    width: ColumnWidth = "stretch";

    public _computedWeight: number = 0;

    protected adjustRenderedElementSize(renderedElement: FrameNode) {
        const minDesignTimeColumnHeight = 20;

        if (this.isDesignMode()) {

            renderedElement.commonAttribute.constraintSize({
                minWidth: '20px', minHeight: (!this.minPixelHeight
                    ? minDesignTimeColumnHeight
                    : Math.max(this.minPixelHeight, minDesignTimeColumnHeight)) + "px"
            })


        } else {
            renderedElement.commonAttribute.constraintSize({
                minWidth: '0'
            })

            if (this.minPixelHeight) {
                renderedElement.commonAttribute.constraintSize({
                    minHeight: this.minPixelHeight + "px"
                })
            }
        }

        if (this.width === "auto") {
            renderedElement.commonAttribute.flexGrow(0);
            renderedElement.commonAttribute.flexShrink(1);
            renderedElement.commonAttribute.flexBasis("auto");
        } else if (this.width === "stretch") {
            renderedElement.commonAttribute.flexGrow(1);
            renderedElement.commonAttribute.flexShrink(1);
            renderedElement.commonAttribute.flexBasis("50px");
        } else if (this.width instanceof SizeAndUnit) {
            if (this.width.unit === Enums.SizeUnit.Pixel) {
                renderedElement.commonAttribute.flexGrow(0);
                renderedElement.commonAttribute.flexShrink(0);
                renderedElement.commonAttribute.flexBasis("auto");
                renderedElement.commonAttribute.width(this.width.physicalSize)

            } else {
                renderedElement.commonAttribute.flexGrow(1);
                renderedElement.commonAttribute.flexShrink(1);
                renderedElement.commonAttribute.flexBasis((this._computedWeight > 0 ? this._computedWeight :
                this.width.physicalSize) + "%");

            }
        }
    }

    protected shouldSerialize(_context: SerializationContext): boolean {
        return true;
    }

    protected get separatorOrientation(): Enums.Orientation {
        return Enums.Orientation.Vertical;
    }

    constructor(width: ColumnWidth = "stretch") {
        super();

        this.width = width;
    }

    getJsonTypeName(): string {
        return "Column";
    }

    get hasVisibleSeparator(): boolean {
        if (this.parent && this.parent instanceof ColumnSet) {
            return this.separatorElement !== undefined && !this.parent.isLeftMostElement(this);
        } else {
            return false;
        }
    }

    get isStandalone(): boolean {
        return false;
    }
}

export class ColumnSet extends ContainerBase {
    private _columns: Column[] = [];
    private _renderedColumns: Column[] = [];

    private createColumnInstance(source: ESObject, context: SerializationContext): Column | undefined {
        return context.parseCardObject<Column>(
            this,
            source,
            [],
            !this.isDesignMode(),
            (typeName: string | undefined) => {
                return !typeName || typeName === "Column" ? new Column() : undefined;
            },
            (typeName: string | undefined, _errorType: Enums.TypeErrorType) => {
                context.logParseEvent(
                    undefined,
                    Enums.ValidationEvent.ElementTypeNotAllowed,
                    Strings.errors.elementTypeNotAllowed(typeName)
                );
            }
        );
    }

    protected internalRender(context: UIContext): FrameNode | undefined {
        this._renderedColumns = [];

        if (this._columns.length > 0) {
            // Cache hostConfig to avoid walking the parent hierarchy several times
            const hostConfig = this.hostConfig;
            const element = typeNode.createNode(context,"Flex");

            switch (this.getEffectiveHorizontalAlignment()) {
                case Enums.HorizontalAlignment.Center:
                    // 测试动画Agenda.template.json需要将alignItems改为ItemAlign.Start，不确定是否会引起其他问题
                    element.initialize({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start })
                    break;
                case Enums.HorizontalAlignment.Right:
                    element.initialize({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Start })
                    break;
                default:
                    element.initialize({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start })
                    break;
            }
            let totalWeight: number = 0;

            for (const column of this._columns) {
                if (
                    column.width instanceof SizeAndUnit &&
                    column.width.unit === Enums.SizeUnit.Weight
                ) {
                    totalWeight += column.width.physicalSize;
                }
            }

            for (const column of this._columns) {
                if (
                    column.width instanceof SizeAndUnit &&
                    column.width.unit === Enums.SizeUnit.Weight &&
                    totalWeight > 0
                ) {
                    const computedWeight = (100 / totalWeight) * column.width.physicalSize;

                    // Best way to emulate "internal" access I know of
                    column._computedWeight = computedWeight;
                }

                const renderedColumn = column.render(context);

                if (renderedColumn) {
                    if (this._renderedColumns.length > 0 && column.separatorElement) {
                        // column.separatorElement.style.flex = "0 0 auto";
                        column.separatorElement.commonAttribute.flexGrow(0);
                        column.separatorElement.commonAttribute.flexShrink(0);
                        column.separatorElement.commonAttribute.flexBasis("auto");

                        Utils.appendChild(element, column.separatorElement);
                    }

                    Utils.appendChild(element, renderedColumn);

                    this._renderedColumns.push(column);
                }
            }

            return this._renderedColumns.length > 0 ? element : undefined;
        } else {
            return undefined;
        }
    }

    protected truncateOverflow(maxHeight: number): boolean {
        return true;
    }

    protected undoOverflowTruncation() {
    }

    protected get isSelectable(): boolean {
        return true;
    }

    protected internalParse(source: ESObject, context: SerializationContext) {
        super.internalParse(source, context);

        this._columns = [];
        this._renderedColumns = [];

        const jsonColumns:ESObject = source.columns;

        if (Array.isArray(jsonColumns)) {
            for(let i=0;i<jsonColumns.length;i++){
                const column = this.createColumnInstance(jsonColumns[i], context);

                if (column) {
                    this._columns.push(column);
                }
            }
        }
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        context.serializeArray(target, "columns", this._columns);
    }

    isFirstElement(element: CardElement): boolean {
        for (const column of this._columns) {
            if (column.isVisible) {
                return column === element;
            }
        }

        return false;
    }

    isBleedingAtTop(): boolean {
        if (this.isBleeding()) {
            return true;
        }

        if (this._renderedColumns && this._renderedColumns.length > 0) {
            for (const column of this._columns) {
                if (column.isBleedingAtTop()) {
                    return true;
                }
            }
        }

        return false;
    }

    isBleedingAtBottom(): boolean {
        if (this.isBleeding()) {
            return true;
        }

        if (this._renderedColumns && this._renderedColumns.length > 0) {
            for (const column of this._columns) {
                if (column.isBleedingAtBottom()) {
                    return true;
                }
            }
        }

        return false;
    }

    getItemCount(): number {
        return this._columns.length;
    }

    getFirstVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedColumns && this._renderedColumns.length > 0) {
            return this._renderedColumns[0];
        } else {
            return undefined;
        }
    }

    getLastVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedColumns && this._renderedColumns.length > 0) {
            return this._renderedColumns[this._renderedColumns.length - 1];
        } else {
            return undefined;
        }
    }

    getColumnAt(index: number): Column {
        return this._columns[index];
    }

    getItemAt(index: number): CardElement {
        return this.getColumnAt(index);
    }

    getJsonTypeName(): string {
        return "ColumnSet";
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        let weightedColumns: number = 0;
        let stretchedColumns: number = 0;

        for (const column of this._columns) {
            if (typeof column.width === "number") {
                weightedColumns++;
            } else if (column.width === "stretch") {
                stretchedColumns++;
            }
        }

        if (weightedColumns > 0 && stretchedColumns > 0) {
            context.addFailure(
                this,
                Enums.ValidationEvent.Hint,
                Strings.hints.dontUseWeightedAndStrecthedColumnsInSameSet()
            );
        }
    }

    addColumn(column: Column) {
        if (!column.parent) {
            this._columns.push(column);

            column.setParent(this);
        } else {
            throw new Error(Strings.errors.columnAlreadyBelongsToAnotherSet());
        }
    }

    removeItem(item: CardElement): boolean {
        if (item instanceof Column) {
            const itemIndex = this._columns.indexOf(item);

            if (itemIndex >= 0) {
                this._columns.splice(itemIndex, 1);

                item.setParent(undefined);

                this.updateLayout();

                return true;
            }
        }

        return false;
    }

    indexOf(cardElement: CardElement): number {
        return cardElement instanceof Column ? this._columns.indexOf(cardElement) : -1;
    }

    isLeftMostElement(element: CardElement): boolean {
        return this._columns.indexOf(element as Column) === 0;
    }

    isRightMostElement(element: CardElement): boolean {
        return this._columns.indexOf(element as Column) === this._columns.length - 1;
    }

    isTopElement(element: CardElement): boolean {
        return this._columns.indexOf(element as Column) >= 0;
    }

    isBottomElement(element: CardElement): boolean {
        return this._columns.indexOf(element as Column) >= 0;
    }

    getActionById(id: string): Action | undefined {
        let result: Action | undefined = undefined;

        for (const column of this._columns) {
            result = column.getActionById(id);

            if (result) {
                break;
            }
        }

        return result;
    }

    get bleed(): boolean {
        return this.getBleed();
    }

    set bleed(value: boolean) {
        this.setBleed(value);
    }

    get padding(): PaddingDefinition | undefined {
        return this.getPadding();
    }

    set padding(value: PaddingDefinition | undefined) {
        this.setPadding(value);
    }
}

function raiseImageLoadedEvent(image: Image) {
    const card = image.getRootElement() as AdaptiveCard;
    const onImageLoadedHandler =
        card && card.onImageLoaded ? card.onImageLoaded : AdaptiveCard.onImageLoaded;

    if (onImageLoadedHandler) {
        onImageLoadedHandler(image);
    }
}

function raiseAnchorClickedEvent(
    element: CardElement,
    anchor: FrameNode,
    ev?: MouseEvent
): boolean {
    const card = element.getRootElement() as AdaptiveCard;
    const onAnchorClickedHandler =
        card && card.onAnchorClicked ? card.onAnchorClicked : AdaptiveCard.onAnchorClicked;

    return onAnchorClickedHandler !== undefined
        ? onAnchorClickedHandler(element, anchor, ev)
        : false;
}

function raiseExecuteActionEvent(action: Action, context: UIContext) {
    const card = action.parent ? (action.parent.getRootElement() as AdaptiveCard) : undefined;
    const onExecuteActionHandler =
        card && card.onExecuteAction ? card.onExecuteAction : AdaptiveCard.onExecuteAction;

    if (action.prepareForExecution(context) && onExecuteActionHandler) {
        onExecuteActionHandler(action);
    }
}

function raiseInlineCardExpandedEvent(action: ShowCardAction, isExpanded: boolean) {
    const card = action.parent ? (action.parent.getRootElement() as AdaptiveCard) : undefined;
    const onInlineCardExpandedHandler =
        card && card.onInlineCardExpanded
            ? card.onInlineCardExpanded
            : AdaptiveCard.onInlineCardExpanded;

    if (onInlineCardExpandedHandler) {
        onInlineCardExpandedHandler(action, isExpanded);
    }
}

function raiseInputValueChangedEvent(input: Input) {
    const card = input.getRootElement() as AdaptiveCard;
    const onInputValueChangedHandler =
        card && card.onInputValueChanged
            ? card.onInputValueChanged
            : AdaptiveCard.onInputValueChanged;

    if (onInputValueChangedHandler) {
        onInputValueChangedHandler(input);
    }
}

function raiseElementVisibilityChangedEvent(
    element: CardElement,
    shouldUpdateLayout: boolean = true
) {
    const rootElement = element.getRootElement();

    if (shouldUpdateLayout) {
        rootElement.updateLayout();
    }

    const card = rootElement as AdaptiveCard;
    const onElementVisibilityChangedHandler =
        card && card.onElementVisibilityChanged
            ? card.onElementVisibilityChanged
            : AdaptiveCard.onElementVisibilityChanged;

    if (onElementVisibilityChangedHandler !== undefined) {
        onElementVisibilityChangedHandler(element);
    }
}

export abstract class ContainerWithActions extends Container {
    private _actionCollection: ActionCollection;

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        super.internalParse(source, context);

        this.parseActions(source, context);
    }

    protected parseActions(source: PropertyBag, context: SerializationContext) {
        this._actionCollection.parse(source["actions"], context);
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        this._actionCollection.toJSON(target, "actions", context);
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        const element = super.internalRender(context);

        if (element) {
            const renderedActions = this._actionCollection.render(context,
                this.hostConfig.actions.actionsOrientation
            );

            if (renderedActions) {
                Utils.appendChild(
                    element,
                    renderSeparation(context,
                        this.hostConfig,
                        {
                            spacing: this.hostConfig.getEffectiveSpacing(
                                this.hostConfig.actions.spacing
                            )
                        },
                        Enums.Orientation.Horizontal
                    )
                );
                Utils.appendChild(element, renderedActions);
            }

            if (this.renderIfEmpty) {
                return element;
            } else {
                return element.getChildrenCount() > 0 ? element : undefined;
            }
        } else {
            return undefined;
        }
    }

    protected getHasExpandedAction(): boolean {
        if (this.renderedActionCount === 0) {
            return false;
        } else if (this.renderedActionCount === 1) {
            return (
                this._actionCollection.expandedAction !== undefined &&
                !this.hostConfig.actions.preExpandSingleShowCardAction
            );
        } else {
            return this._actionCollection.expandedAction !== undefined;
        }
    }

    protected get renderedActionCount(): number {
        return this._actionCollection.renderedActionCount;
    }

    protected get renderIfEmpty(): boolean {
        return false;
    }

    constructor() {
        super();
        this._actionCollection = new ActionCollection(this);
    }

    releaseDOMResources() {
        super.releaseDOMResources();

        this._actionCollection.releaseDOMResources();
    }

    getActionCount(): number {
        return this._actionCollection.getActionCount();
    }

    getActionAt(index: number): Action | undefined {
        if (index >= 0 && index < this.getActionCount()) {
            return this._actionCollection.getActionAt(index);
        } else {
            return super.getActionAt(index);
        }
    }

    getActionById(id: string): Action | undefined {
        const result: Action | undefined = this._actionCollection.getActionById(id);

        return result ? result : super.getActionById(id);
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        if (this._actionCollection) {
            this._actionCollection.validateProperties(context);
        }
    }

    isLastElement(element: CardElement): boolean {
        return super.isLastElement(element) && this._actionCollection.getActionCount() === 0;
    }

    addAction(action: Action) {
        this._actionCollection.addAction(action);
    }

    clear() {
        super.clear();

        this._actionCollection.clear();
    }

    getAllInputs(processActions: boolean = true): Input[] {
        let result = super.getAllInputs(processActions);

        if (processActions) {
            result.push(...this._actionCollection.getAllInputs(processActions));
        }

        return result;
    }

    getResourceInformation(): IResourceInformation[] {
        let result = super.getResourceInformation();

        result.push(...this._actionCollection.getResourceInformation());

        return result;
    }

    isBleedingAtBottom(): boolean {
        if (this._actionCollection.renderedActionCount === 0) {
            return super.isBleedingAtBottom();
        } else {
            if (this._actionCollection.getActionCount() === 1) {
                return (
                    this._actionCollection.expandedAction !== undefined &&
                        !this.hostConfig.actions.preExpandSingleShowCardAction
                );
            } else {
                return this._actionCollection.expandedAction !== undefined;
            }
        }
    }

    getForbiddenActionNames(): string[] {
        return [];
    }

    getElementById(id: string): CardElement | undefined {
        let result = super.getElementById(id);

        if (!result) {
            result = this.getElementByIdFromAction(id);
        }

        return result;
    }

    get isStandalone(): boolean {
        return false;
    }
}

export interface IMarkdownProcessingResult {
    didProcess: boolean;
    outputHtml?: string;
}

export class RefreshActionProperty extends PropertyDefinition {
    parse(
        sender: RefreshDefinition,
        source: PropertyBag,
        context: SerializationContext
    ): ExecuteAction | undefined {
        const action = context.parseAction(sender.parent, source[this.name], [], false);

        if (action !== undefined) {
            if (action instanceof ExecuteAction) {
                return action;
            }

            context.logParseEvent(
                sender,
                Enums.ValidationEvent.ActionTypeNotAllowed,
                Strings.errors.actionTypeNotAllowed(action.getJsonTypeName())
            );
        }

        context.logParseEvent(
            sender,
            Enums.ValidationEvent.PropertyCantBeNull,
            Strings.errors.propertyMustBeSet("action")
        );

        return undefined;
    }

    toJSON(
        sender: SerializableObject,
        target: PropertyBag,
        value: ExecuteAction | undefined,
        context: SerializationContext
    ) {
        context.serializeValue(
            target,
            this.name,
            value ? value.toJSON(context) : undefined,
            undefined,
            true
        );
    }

    constructor(targetVersion: Version, name: string) {
        super(targetVersion, name, undefined);
    }
}

export class RefreshDefinition extends SerializableObject {
    //#region Schema

    static readonly actionProperty = new RefreshActionProperty(Versions.v1_4, "action");
    static readonly userIdsProperty = new StringArrayProperty(Versions.v1_4, "userIds");

    @property(RefreshDefinition.actionProperty)
    get action(): ExecuteAction {
        return this.getValue(RefreshDefinition.actionProperty);
    }

    set action(value: ExecuteAction) {
        this.setValue(RefreshDefinition.actionProperty, value);

        if (value) {
            value.setParent(this.parent);
        }
    }

    @property(RefreshDefinition.userIdsProperty)
    userIds?: string[];

    protected getSchemaKey(): string {
        return "RefreshDefinition";
    }

    //#endregion

    parent?: CardElement;
}

export class AuthCardButton extends SerializableObject {
    //#region Schema

    static readonly typeProperty = new StringProperty(Versions.v1_4, "type");
    static readonly titleProperty = new StringProperty(Versions.v1_4, "title");
    static readonly imageProperty = new StringProperty(Versions.v1_4, "image");
    static readonly valueProperty = new StringProperty(Versions.v1_4, "value");

    protected getSchemaKey(): string {
        return "AuthCardButton";
    }

    //#endregion

    @property(AuthCardButton.typeProperty)
    type?: string;

    @property(AuthCardButton.titleProperty)
    title?: string;

    @property(AuthCardButton.imageProperty)
    image?: string;

    @property(AuthCardButton.valueProperty)
    value?: string;
}

export class TokenExchangeResource extends SerializableObject {
    //#region Schema

    static readonly idProperty = new StringProperty(Versions.v1_4, "id");
    static readonly uriProperty = new StringProperty(Versions.v1_4, "uri");
    static readonly providerIdProperty = new StringProperty(Versions.v1_4, "providerId");

    protected getSchemaKey(): string {
        return "TokenExchangeResource";
    }

    //#endregion

    @property(TokenExchangeResource.idProperty)
    id?: string;

    @property(TokenExchangeResource.uriProperty)
    uri?: string;

    @property(TokenExchangeResource.providerIdProperty)
    providerId?: string;
}

export class Authentication extends SerializableObject {
    //#region Schema

    static readonly textProperty = new StringProperty(Versions.v1_4, "text");
    static readonly connectionNameProperty = new StringProperty(Versions.v1_4, "connectionName");
    static readonly buttonsProperty = new SerializableObjectCollectionProperty(
        Versions.v1_4,
        "buttons",
        AuthCardButton
    );
    static readonly tokenExchangeResourceProperty = new SerializableObjectProperty(
        Versions.v1_4,
        "tokenExchangeResource",
        TokenExchangeResource,
        true
    );

    protected getSchemaKey(): string {
        return "Authentication";
    }

    //#endregion

    @property(Authentication.textProperty)
    text?: string;

    @property(Authentication.connectionNameProperty)
    connectionName?: string;

    @property(Authentication.buttonsProperty)
    buttons?: AuthCardButton[];

    @property(Authentication.tokenExchangeResourceProperty)
    tokenExchangeResource?: TokenExchangeResource;
}

// @dynamic
export class AdaptiveCard extends ContainerWithActions {
    static readonly schemaUrl = "http://adaptivecards.io/schemas/adaptive-card.json";

    //#region Schema

    // eslint-disable-next-line @typescript-eslint/naming-convention
    protected static readonly $schemaProperty = new CustomProperty<string>(
        Versions.v1_0,
        "$schema",
        (
            sender: SerializableObject,
            property: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            return AdaptiveCard.schemaUrl;
        },
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            target: PropertyBag,
            value: Versions | undefined,
            context: BaseSerializationContext
        ) => {
            context.serializeValue(target, prop.name, AdaptiveCard.schemaUrl);
        }
    );

    static readonly versionProperty = new CustomProperty<Version | undefined>(
        Versions.v1_0,
        "version",
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            source: PropertyBag,
            context: BaseSerializationContext
        ) => {
            let version = Version.parse(source[prop.name], context);

            if (version === undefined) {
                version = Versions.latest;

                context.logParseEvent(
                    sender,
                    Enums.ValidationEvent.InvalidPropertyValue,
                    Strings.errors.invalidCardVersion(version.toString())
                );
            }

            return version;
        },
        (
            sender: SerializableObject,
            prop: PropertyDefinition,
            target: PropertyBag,
            value: Version | undefined,
            context: BaseSerializationContext
        ) => {
            if (value !== undefined) {
                context.serializeValue(target, prop.name, value.toString());
            }
        },
        Versions.v1_0
    );

    static readonly fallbackTextProperty = new StringProperty(Versions.v1_0, "fallbackText");
    static readonly speakProperty = new StringProperty(Versions.v1_0, "speak");
    static readonly refreshProperty = new SerializableObjectProperty(
        Versions.v1_4,
        "refresh",
        RefreshDefinition,
        true
    );
    static readonly authenticationProperty = new SerializableObjectProperty(
        Versions.v1_4,
        "authentication",
        Authentication,
        true
    );

    @property(AdaptiveCard.versionProperty)
    version?: Version;

    @property(AdaptiveCard.fallbackTextProperty)
    fallbackText?: string;

    @property(AdaptiveCard.speakProperty)
    speak?: string;

    @property(AdaptiveCard.refreshProperty)
    get refresh(): RefreshDefinition | undefined {
        return this.getValue(AdaptiveCard.refreshProperty);
    }

    set refresh(value: RefreshDefinition | undefined) {
        this.setValue(AdaptiveCard.refreshProperty, value);

        if (value) {
            value.parent = this;
        }
    }

    @property(AdaptiveCard.authenticationProperty)
    authentication?: Authentication;

    //#endregion

    private static _haveWarnedAboutNoMarkdownProcessing = false;

    static onAnchorClicked?: (
        element: CardElement,
        anchor: FrameNode,
        ev?: MouseEvent
    ) => boolean;
    static onExecuteAction?: (action: Action) => void;
    static onElementVisibilityChanged?: (element: CardElement) => void;
    static onImageLoaded?: (image: Image) => void;
    static onInlineCardExpanded?: (action: ShowCardAction, isExpanded: boolean) => void;
    static onInputValueChanged?: (input: Input) => void;
    static onCarouselEvent?: (carouselEvent: CarouselEvent) => void;
    static onProcessMarkdown?: (text: string, result: IMarkdownProcessingResult) => void;
    static onDisplayOverflowActionMenu?: (
        actions: readonly Action[],
        target?: FrameNode
    ) => boolean;
    static onRenderOverflowActions?: (
        actions: readonly Action[],
        isRootLevelActions: boolean
    ) => boolean;

    static get processMarkdown(): (text: string) => string {
        throw new Error(Strings.errors.processMarkdownEventRemoved());
    }

    // eslint-disable-next-line @typescript-eslint/naming-convention
    static set processMarkdown(_value: (text: string) => string) {
        throw new Error(Strings.errors.processMarkdownEventRemoved());
    }

    static applyMarkdown(text: string): IMarkdownProcessingResult {
        const result: IMarkdownProcessingResult = {
            didProcess: false
        };

        if (AdaptiveCard.onProcessMarkdown) {
            AdaptiveCard.onProcessMarkdown(text, result);
        } else if (text) {
            result.outputHtml = text;
            result.didProcess = true;
        } else if (!AdaptiveCard._haveWarnedAboutNoMarkdownProcessing) {
            // eslint-disable-next-line no-console
            console.warn(Strings.errors.markdownProcessingNotEnabled.toString());
            AdaptiveCard._haveWarnedAboutNoMarkdownProcessing = true;
        }

        return result;
    }

    private _fallbackCard?: AdaptiveCard;

    private isVersionSupported(): boolean {
        if (this.bypassVersionCheck) {
            return true;
        } else {
            const unsupportedVersion: boolean =
                !this.version ||
                !this.version.isValid ||
                this.maxVersion.major < this.version.major ||
                (this.maxVersion.major === this.version.major &&
                    this.maxVersion.minor < this.version.minor);

            return !unsupportedVersion;
        }
    }

    protected getDefaultSerializationContext(): BaseSerializationContext {
        return new SerializationContext(this.version);
    }

    protected getItemsCollectionPropertyName(): string {
        return "body";
    }

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        this._fallbackCard = undefined;
        const fallbackElement = context.parseElement(
            undefined,
            source["fallback"],
            this.forbiddenChildElements(),
            !this.isDesignMode()
        );

        if (fallbackElement) {
            this._fallbackCard = new AdaptiveCard();
            this._fallbackCard.addItem(fallbackElement);
        }

        super.internalParse(source, context);
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        this.setValue(AdaptiveCard.versionProperty, context.targetVersion);

        super.internalToJSON(target, context);
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        const renderedElement = super.internalRender(context);

        if (GlobalSettings.useAdvancedCardBottomTruncation && renderedElement) {
            // Unlike containers, the root card element should be allowed to
            // be shorter than its content (otherwise the overflow truncation
            // logic would never get triggered)
            // renderedElement.style.removeProperty("minHeight");
        }

        return renderedElement;
    }

    protected getHasBackground(ignoreBackgroundImages: boolean = false): boolean {
        return true;
    }

    protected getDefaultPadding(): PaddingDefinition {
        return new PaddingDefinition(
            Enums.Spacing.Padding,
            Enums.Spacing.Padding,
            Enums.Spacing.Padding,
            Enums.Spacing.Padding
        );
    }

    protected shouldSerialize(_context: SerializationContext): boolean {
        return true;
    }

    protected get renderIfEmpty(): boolean {
        return true;
    }

    protected get bypassVersionCheck(): boolean {
        return false;
    }

    protected get allowCustomStyle() {
        return this.hostConfig.adaptiveCard && this.hostConfig.adaptiveCard.allowCustomStyle;
    }

    protected get hasBackground(): boolean {
        return true;
    }

    onAnchorClicked?: (element: CardElement, anchor: FrameNode, ev?: MouseEvent) => boolean;
    onExecuteAction?: (action: Action) => void;
    onElementVisibilityChanged?: (element: CardElement) => void;
    onImageLoaded?: (image: Image) => void;
    onInlineCardExpanded?: (action: ShowCardAction, isExpanded: boolean) => void;
    onInputValueChanged?: (input: Input) => void;
    onCarouselEvent?: (carouselEvent: CarouselEvent) => void;
    onDisplayOverflowActionMenu?: (actions: readonly Action[], target?: FrameNode) => boolean;
    onRenderOverflowActions?: (actions: readonly Action[], isRootLevelActions: boolean) => boolean;

    designMode: boolean = false;

    getJsonTypeName(): string {
        return "AdaptiveCard";
    }

    internalValidateProperties(context: ValidationResults) {
        super.internalValidateProperties(context);

        if (this.getValue(CardElement.typeNameProperty) !== "AdaptiveCard") {
            context.addFailure(
                this,
                Enums.ValidationEvent.MissingCardType,
                Strings.errors.invalidCardType()
            );
        }

        if (!this.bypassVersionCheck && !this.version) {
            context.addFailure(
                this,
                Enums.ValidationEvent.PropertyCantBeNull,
                Strings.errors.propertyMustBeSet("version")
            );
        } else if (!this.isVersionSupported()) {
            context.addFailure(
                this,
                Enums.ValidationEvent.UnsupportedCardVersion,
                Strings.errors.unsupportedCardVersion(
                    this.version+"",
                    this.maxVersion.toString()
                )
            );
        }
    }

    render(context:UIContext,target?: FrameNode): FrameNode | undefined {
        let renderedCard: FrameNode | undefined;

        if (this.shouldFallback() && this._fallbackCard) {
            this._fallbackCard.hostConfig = this.hostConfig;
            renderedCard = this._fallbackCard.render(context);
        } else {
            renderedCard = super.render(context);

            if (renderedCard) {

                renderedCard.commonEvent.setOnTouch((e)=>{
                    switch (e.type){
                        case TouchType.Down:
                            this.updateInputsVisualState(true /* hover */);
                        case TouchType.Up:
                            this.updateInputsVisualState(false /* hover */);
                    }
                })
                this.getRootElement().updateActionsEnabledState();
            }
        }

        if (target) {
            Utils.appendChild(target, renderedCard);

            this.updateLayout();
        }
        return renderedCard;
    }

    updateLayout(processChildren: boolean = true) {
        super.updateLayout(processChildren);

        if (GlobalSettings.useAdvancedCardBottomTruncation && this.isDisplayed()) {
            const padding = this.hostConfig.getEffectiveSpacing(Enums.Spacing.Default);
        }
    }

    shouldFallback(): boolean {
        return super.shouldFallback() || !this.isVersionSupported();
    }

    get hasVisibleSeparator(): boolean {
        return false;
    }
}

class InlineAdaptiveCard extends AdaptiveCard {
    //#region Schema

    protected getSchemaKey(): string {
        return "InlineAdaptiveCard";
    }

    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        schema.remove(AdaptiveCard.$schemaProperty, AdaptiveCard.versionProperty);
    }

    //#endregion

    protected getDefaultPadding(): PaddingDefinition {
        return new PaddingDefinition(
            this.suppressStyle ? Enums.Spacing.None : Enums.Spacing.Padding,
            Enums.Spacing.Padding,
            this.suppressStyle ? Enums.Spacing.None : Enums.Spacing.Padding,
            Enums.Spacing.Padding
        );
    }

    protected get bypassVersionCheck(): boolean {
        return true;
    }

    protected get defaultStyle(): string {
        if (this.suppressStyle) {
            return Enums.ContainerStyle.Default;
        } else {
            return this.hostConfig.actions.showCard.style
                ? this.hostConfig.actions.showCard.style
                : Enums.ContainerStyle.Emphasis;
        }
    }

    suppressStyle: boolean = false;

    render(context:UIContext,target?: FrameNode): FrameNode | undefined {
        const renderedCard = super.render(context,target);
        return renderedCard;
    }
}

export class SerializationContext extends BaseSerializationContext {
    private _elementRegistry?: CardObjectRegistry<CardElement>;
    private _actionRegistry?: CardObjectRegistry<Action>;

    private _forbiddenTypes: Set<string> = new Set<string>();
    private internalParseCardObject<T extends CardObject>(
        parent: CardElement | undefined,
        source: PropertyBag,
        forbiddenTypes: Set<string>,
        allowFallback: boolean,
        createInstanceCallback: (typeName: string | undefined) => T | undefined,
        logParseEvent: (typeName: string | undefined, errorType: Enums.TypeErrorType) => void
    ): T | undefined {
        let result: T | undefined = undefined;

        if (source && typeof source === "object") {
            const oldForbiddenTypes = new Set<string>();
            this._forbiddenTypes.forEach((type) => {
                oldForbiddenTypes.add(type);
            });
            forbiddenTypes.forEach((type) => {
                this._forbiddenTypes.add(type);
            });

            const typeName = Utils.parseString(source["type"]);

            if (typeName && this._forbiddenTypes.has(typeName)) {
                logParseEvent(typeName, Enums.TypeErrorType.ForbiddenType);
            } else {
                let tryToFallback = false;

                result = createInstanceCallback(typeName);

                if (!result) {
                    tryToFallback = GlobalSettings.enableFallback && allowFallback;

                    logParseEvent(typeName, Enums.TypeErrorType.UnknownType);
                } else {
                    result.setParent(parent);
                    result.parse(source, this);

                    tryToFallback =
                        GlobalSettings.enableFallback && allowFallback && result.shouldFallback();
                }

                if (tryToFallback) {
                    // const fallback = source["fallback"];
                    if (!source["fallback"] && parent) {
                        parent.setShouldFallback(true);
                    }
                    if (typeof source["fallback"] === "string" && source["fallback"].toLowerCase() === "drop") {
                        result = undefined;
                    } else if (typeof source["fallback"] === "object") {
                        result = this.internalParseCardObject<T>(
                            parent,
                            source["fallback"],
                            forbiddenTypes,
                            true,
                            createInstanceCallback,
                            logParseEvent
                        );
                    }
                }
            }

            this._forbiddenTypes = oldForbiddenTypes;
        }

        return result;
    }

    protected cardObjectParsed(o: SerializableObject, source: PropertyBag) {
        if (o instanceof Action && this.onParseAction) {
            this.onParseAction(o, source, this);
        } else if (o instanceof CardElement && this.onParseElement) {
            this.onParseElement(o, source, this);
        }
    }

    onParseAction?: (action: Action, source: PropertyBag, context: SerializationContext) => void;
    onParseElement?: (element: CardElement, source: PropertyBag, context: SerializationContext) => void;

    shouldSerialize(o: SerializableObject): boolean {
        if (o instanceof Action) {
            return this.actionRegistry.findByName(o.getJsonTypeName()) !== undefined;
        } else if (o instanceof CardElement) {
            return this.elementRegistry.findByName(o.getJsonTypeName()) !== undefined;
        } else {
            return true;
        }
    }

    parseCardObject<T extends CardObject>(
        parent: CardElement | undefined,
        source: PropertyBag,
        forbiddenTypeNames: string[],
        allowFallback: boolean,
        createInstanceCallback: (typeName: string | undefined ) => T | undefined,
        logParseEvent: (typeName: string | undefined, errorType: Enums.TypeErrorType) => void
    ): T | undefined {
        const forbiddenTypes = new Set<string>(forbiddenTypeNames);
        const result = this.internalParseCardObject(
            parent,
            source,
            forbiddenTypes,
            allowFallback,
            createInstanceCallback,
            logParseEvent
        );

        if (result !== undefined) {
            this.cardObjectParsed(result, source);
        }

        return result;
    }

    parseElement(
        parent: CardElement | undefined,
        source: PropertyBag,
        forbiddenTypes: string[],
        allowFallback: boolean
    ): CardElement | undefined {
        return this.parseCardObject<CardElement>(
            parent,
            source,
            forbiddenTypes,
            allowFallback,
            (typeName: string|undefined) => {
                return this.elementRegistry.createInstance(typeName, this.targetVersion);
            },
            (typeName: string|undefined, errorType: Enums.TypeErrorType) => {
                if (errorType === Enums.TypeErrorType.UnknownType) {
                    this.logParseEvent(
                        undefined,
                        Enums.ValidationEvent.UnknownElementType,
                        Strings.errors.unknownElementType(typeName)
                    );
                } else {
                    this.logParseEvent(
                        undefined,
                        Enums.ValidationEvent.ElementTypeNotAllowed,
                        Strings.errors.elementTypeNotAllowed(typeName)
                    );
                }
            }
        );
    }

    parseAction(
        parent: CardElement|undefined,
        source: PropertyBag,
        forbiddenActionTypes: string[],
        allowFallback: boolean
    ): Action | undefined {
        return this.parseCardObject<Action>(
            parent,
            source,
            forbiddenActionTypes,
            allowFallback,
            (typeName: string|undefined) => {
                return this.actionRegistry.createInstance(typeName, this.targetVersion);
            },
            (typeName: string|undefined, errorType: Enums.TypeErrorType) => {
                if (errorType === Enums.TypeErrorType.UnknownType) {
                    this.logParseEvent(
                        undefined,
                        Enums.ValidationEvent.UnknownActionType,
                        Strings.errors.unknownActionType(typeName)
                    );
                } else {
                    this.logParseEvent(
                        undefined,
                        Enums.ValidationEvent.ActionTypeNotAllowed,
                        Strings.errors.actionTypeNotAllowed(typeName)
                    );
                }
            }
        );
    }

    get elementRegistry(): CardObjectRegistry<CardElement> {
        return this._elementRegistry ?? GlobalRegistry.elements;
    }

    // Not using a property setter here because the setter should accept "undefined"
    // whereas the getter should never return undefined.
    setElementRegistry(value: CardObjectRegistry<CardElement> | undefined) {
        this._elementRegistry = value;
    }

    get actionRegistry(): CardObjectRegistry<Action> {
        return this._actionRegistry ?? GlobalRegistry.actions;
    }

    // Not using a property setter here because the setter should accept "undefined"
    // whereas the getter should never return undefined.
    setActionRegistry(value: CardObjectRegistry<Action> | undefined) {
        this._actionRegistry = value;
    }
}

GlobalRegistry.defaultElements.register("Container", Container);
GlobalRegistry.defaultElements.register("TextBlock", TextBlock);
GlobalRegistry.defaultElements.register("RichTextBlock", RichTextBlock, Versions.v1_2);
GlobalRegistry.defaultElements.register("TextRun", TextRun, Versions.v1_2);
GlobalRegistry.defaultElements.register("Image", Image);
GlobalRegistry.defaultElements.register("ImageSet", ImageSet);
GlobalRegistry.defaultElements.register("FactSet", FactSet);
GlobalRegistry.defaultElements.register("ColumnSet", ColumnSet);
GlobalRegistry.defaultElements.register("ActionSet", ActionSet, Versions.v1_2);
GlobalRegistry.defaultElements.register("Input.Text", TextInput);
GlobalRegistry.defaultElements.register("Input.Number", NumberInput);
GlobalRegistry.defaultActions.register(OpenUrlAction.JsonTypeName, OpenUrlAction);
GlobalRegistry.defaultActions.register(SubmitAction.JsonTypeName, SubmitAction);
GlobalRegistry.defaultActions.register(ShowCardAction.JsonTypeName, ShowCardAction);
GlobalRegistry.defaultActions.register(
    ToggleVisibilityAction.JsonTypeName,
    ToggleVisibilityAction,
    Versions.v1_2
);
GlobalRegistry.defaultActions.register(ExecuteAction.JsonTypeName, ExecuteAction, Versions.v1_4);
class Params {
    url: string = "";
    text: string = "";

    constructor(url: string, text: string) {
        this.url = url;
        this.text = text;
    }
}
@Builder
function buildText(params: Params) {
    Hyperlink(params.url, params.text) {
    }
}