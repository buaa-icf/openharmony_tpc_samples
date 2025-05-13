// Copyright (C) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
import {
  ActionType,
  AdaptiveCard,
  CardElement,
  Container,
  SerializationContext,
  ShowCardAction,
  ToggleVisibilityAction
} from './card-elements';
import * as Enums from './enums';
import { TypeErrorType, ValidationEvent } from './enums';
import {
  BoolProperty,
  EnumProperty,
  NumProperty,
  PixelSizeProperty,
  property,
  PropertyBag,
  SerializableObjectSchema,
  Versions
} from './serialization';
import { Strings } from './strings';
import * as Utils from './utils';
import { GlobalSettings } from './shared';
import { FrameNode, typeNode, UIContext } from '@kit.ArkUI';
import { GlobalRegistry } from './GlobalRegistry';

// Note: to function correctly, consumers need to have CSS from swiper/css, swiper/css/pagination, and
// swiper/css/navigation

export class CarouselPage extends Container {
    //#region Schema
    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        // `style`, `bleed`, `isVisible` are not supported in CarouselPage
        schema.remove(Container.styleProperty);
        schema.remove(Container.bleedProperty);
        schema.remove(Container.isVisibleProperty);
    }
    //#endregion

    protected internalRender(context:UIContext): FrameNode | undefined {
        const carouselSlide = typeNode.createNode(context,"Column");
        // `isRtl()` will set the correct value of rtl by reading the value from the parents
        this.rtl = this.isRtl();
        const renderedElement = super.internalRender(context);
        Utils.appendChild(carouselSlide, renderedElement);
        return carouselSlide;
    }

    getForbiddenActionTypes(): ActionType[] {
        return [];
    }

    getForbiddenChildElements(): string[] {
        return this.forbiddenChildElements();
    }

    protected forbiddenChildElements(): string[] {
        return [
            ToggleVisibilityAction.JsonTypeName,
            ShowCardAction.JsonTypeName,
            "Media",
            "ActionSet",
            "Input.Text",
            "Input.Date",
            "Input.Time",
            "Input.Number",
            "Input.ChoiceSet",
            "Input.Toggle",
            "Carousel",
            ...super.forbiddenChildElements()
        ];
    }

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        super.internalParse(source, context);

        this.setShouldFallback(false);
    }

    protected shouldSerialize(_context: SerializationContext): boolean {
        return true;
    }

    getJsonTypeName(): string {
        return "CarouselPage";
    }

    get isStandalone(): boolean {
        return false;
    }

    get hasVisibleSeparator(): boolean {
        return false;
    }
}

export class Carousel extends Container {
    //#region Schema
    protected populateSchema(schema: SerializableObjectSchema) {
        super.populateSchema(schema);

        // `style`, `bleed`, `isVisible` are not supported in Carousel
        schema.remove(Container.styleProperty);
        schema.remove(Container.bleedProperty);
        schema.remove(Container.isVisibleProperty);
    }

    static readonly timerProperty = new NumProperty(Versions.v1_6, "timer", undefined);
    @property(Carousel.timerProperty)
    get timer(): number | undefined {
        let timer = this.getValue(Carousel.timerProperty) as number;
        return timer;
    }

    set timer(value: number | undefined) {
        this.setValue(Carousel.timerProperty, value);
    }

    static readonly initialPageProperty = new NumProperty(Versions.v1_6, "initialPage", 0);
    @property(Carousel.initialPageProperty)
    get initialPageIndex(): number {
        return this.getValue(Carousel.initialPageProperty);
    }

    set initialPageIndex(value: number) {
        if (this.isValidParsedPageIndex(value)) {
            this.setValue(Carousel.initialPageProperty, value);
        } else {
            console.warn(Strings.errors.invalidInitialPageIndex(value));
            this.setValue(Carousel.initialPageProperty, 0);
        }
    }

    static readonly loopProperty = new BoolProperty(Versions.v1_6, "loop", true);
    @property(Carousel.loopProperty)
    carouselLoop: boolean = true;

    static readonly orientationProperty = new EnumProperty(
        Versions.v1_6,
        "orientation",
        Enums.Orientation,
        Enums.Orientation.Horizontal
    );
    @property(Carousel.orientationProperty)
    carouselOrientation: Enums.Orientation = Enums.Orientation.Horizontal;

    static readonly carouselHeightProperty = new PixelSizeProperty(
        Versions.v1_6,
        "heightInPixels"
    );
    @property(Carousel.carouselHeightProperty)
    carouselHeight?: number;

    private isValidParsedPageIndex(index: number) : boolean {
        return this._pages ? this.isValidPageIndex(index, this._pages.length) : false;
    }

    private isValidRenderedPageIndex(index: number) : boolean {
        return this._renderedPages ? this.isValidPageIndex(index, this._renderedPages.length) : false;
    }

    private isValidPageIndex(index: number, collectionSize: number) {
        return (collectionSize > 0 && 0 <= index && index < collectionSize);
    }

    //#endregion

    get previousEventType(): Enums.CarouselInteractionEvent {
        return this._previousEventType;
    }

    set previousEventType(eventType: Enums.CarouselInteractionEvent) {
        this._previousEventType = eventType;
    }

    private _pages: CarouselPage[] = [];
    private _renderedPages: CarouselPage[]|undefined;
    private _carouselPageContainer: FrameNode|undefined;
    private _containerForAdorners: FrameNode|undefined;
    private _currentIndex: number = 0;
    private _previousEventType: Enums.CarouselInteractionEvent = Enums.CarouselInteractionEvent.Pagination;
    // private _observer: ResizeObserver | null;
    private _carousel: typeNode.Swiper | undefined;
    private _currentPageIndex:number = 0;

    // Question: Why do we place this on the Carousel instead of the CarouselPage?
    protected forbiddenChildElements(): string[] {
        return [
            ToggleVisibilityAction.JsonTypeName,
            ShowCardAction.JsonTypeName,
            "Media",
            "ActionSet",
            "Input.Text",
            "Input.Date",
            "Input.Time",
            "Input.Number",
            "Input.ChoiceSet",
            "Input.Toggle",
            ...super.forbiddenChildElements()
        ];
    }

    protected adjustRenderedElementSize(renderedElement: FrameNode) {
        super.adjustRenderedElementSize(renderedElement);
        if (this.height == "stretch" && this._containerForAdorners !== undefined) {
            this._containerForAdorners.commonAttribute.height('100%')
        }

        // Assign the explicit height to carouselPageContainer if given
        if (this.carouselHeight) {
            // this._carouselPageContainer.style.height = this.carouselHeight + "px";
            this._carouselPageContainer?.commonAttribute.height(this.carouselHeight)
        }
    }

    getJsonTypeName(): string {
        return "Carousel";
    }

    getItemCount(): number {
        return this._pages.length;
    }

    getItemAt(index: number): CardElement {
        return this._pages[index];
    }

    addPage(page: CarouselPage) {
        this._pages.push(page);
        page.setParent(this);
    }

    removeItem(item: CardElement): boolean {
        if (item instanceof CarouselPage) {
            const itemIndex = this._pages.indexOf(item);

            if (itemIndex >= 0) {
                this._pages.splice(itemIndex, 1);

                item.setParent(undefined);

                this.updateLayout();

                return true;
            }
        }

        return false;
    }

    getFirstVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedPages && this._renderedPages.length > 0) {
            return this._renderedPages[0];
        } else {
            return undefined;
        }
    }

    getLastVisibleRenderedItem(): CardElement | undefined {
        if (this.renderedElement && this._renderedPages && this._renderedPages.length > 0) {
            return this._renderedPages[this._renderedPages.length - 1];
        } else {
            return undefined;
        }
    }

    get currentPageId(): string | undefined {
        return undefined;
    }

    get currentPageIndex(): number | undefined {
        return this._currentPageIndex;
    }

    protected internalParse(source: PropertyBag, context: SerializationContext) {
        super.internalParse(source, context);

        this._pages = [];

        const jsonPages = source["pages"] as PropertyBag;
        if (Array.isArray(jsonPages)) {
            jsonPages.forEach((item:PropertyBag) => {
                const page = this.createCarouselPageInstance(item, context);
                if (page) {
                    this._pages.push(page);
                }
            });

        }

        // everything is parsed do validate on initial page index
        this.validateParsing(context);
    }

    private validateParsing(context: SerializationContext) {
        if (!this.isValidParsedPageIndex(this.initialPageIndex)) {
            context.logParseEvent(
                this,
                Enums.ValidationEvent.InvalidPropertyValue,
                Strings.errors.invalidInitialPageIndex(this.initialPageIndex)
            );
        }
    }

    protected internalToJSON(target: PropertyBag, context: SerializationContext) {
        super.internalToJSON(target, context);

        context.serializeArray(target, "pages", this._pages);
    }

    protected internalRender(context:UIContext): FrameNode | undefined {
        this._renderedPages = [];

        if (this._pages.length <= 0) {
            return undefined;
        }

        this.validateOrientationProperties();

        const cardLevelContainer = typeNode.createNode(context,"Column");
        const carouselContainer = typeNode.createNode(context,"Swiper");
        carouselContainer.attribute.width('100%')
        this._carouselPageContainer = carouselContainer;

        this.adjustRenderedElementSize(carouselContainer);

        const containerForAdorners = typeNode.createNode(context,"Column");
        this._containerForAdorners = containerForAdorners;

        cardLevelContainer.appendChild(containerForAdorners);

        const carouselWrapper = typeNode.createNode(context,"Flex");

        switch (this.getEffectiveVerticalContentAlignment()) {
            case Enums.VerticalAlignment.Top:
                carouselWrapper.attribute.align(Alignment.Start)
                break;
            case Enums.VerticalAlignment.Bottom:
                carouselWrapper.attribute.align(Alignment.End)
                break;
            default:
                carouselWrapper.attribute.align(Alignment.Center)
                break;
        }

        const navigationContainer = typeNode.createNode(context,"Column");

        const prevElementDiv = typeNode.createNode(context,"Column");
        const nextElementDiv = typeNode.createNode(context,"Column");
        const pagination = typeNode.createNode(context,"Column");
        navigationContainer.appendChild(prevElementDiv);
        Utils.addCancelSelectActionEventHandler(prevElementDiv);

        navigationContainer.appendChild(pagination);
        Utils.addCancelSelectActionEventHandler(pagination);

        navigationContainer.appendChild(nextElementDiv);
        Utils.addCancelSelectActionEventHandler(nextElementDiv);

        if (this.isDesignMode()) {
            prevElementDiv.attribute.zIndex(20)
            nextElementDiv.attribute.zIndex(20)
            pagination.attribute.zIndex(20)
        }

        const requestedNumberOfPages: number = Math.min(
            this._pages.length,
            this.hostConfig.carousel.maxCarouselPages
        );

        if (this._pages.length > 0) {
            for (let i = 0; i < requestedNumberOfPages; i++) {
                const page = this._pages[i];
                const renderedItem = this.isElementAllowed(page) ? page.render(context) : undefined;
                if (renderedItem) {
                    Utils.appendChild(carouselContainer, renderedItem);
                    this._renderedPages.push(page);
                }
            }
        }

        containerForAdorners.appendChild(carouselContainer);
        containerForAdorners.appendChild(navigationContainer);

        // `isRtl()` will set the correct value of rtl by reading the value from the parents
        this.rtl = this.isRtl();
        this.applyRTL(pagination);

        if (!this.isDesignMode()) {
            if (this.isValidRenderedPageIndex(this.initialPageIndex)) {
                this._currentIndex = this.initialPageIndex;
            } else {
                // console.warn(Strings.errors.invalidInitialPageIndex(this.initialPageIndex));
                this._currentIndex = 0
            }
        }

        this.initializeCarouselControl(
            carouselContainer,
            nextElementDiv,
            prevElementDiv,
            pagination,
            this.rtl
        );

        return this._renderedPages.length > 0 ? cardLevelContainer : undefined;
    }

    applyRTL(pagination: FrameNode) {
        super.applyRTL(this._carouselPageContainer);
    }

    validateOrientationProperties() {
        if (!this.carouselHeight) {
            this.carouselOrientation = Enums.Orientation.Horizontal;
        }
    }


    private initializeCarouselControl(
        carouselContainer: typeNode.Swiper,
        nextElement: FrameNode,
        prevElement: FrameNode,
        paginationElement: FrameNode,
        rtl: boolean | undefined
    ): void {

        this._carousel = carouselContainer;

       let swiperObj = this._carousel.initialize();
       swiperObj.index(this.initialPageIndex);
       swiperObj.onChange((index)=>{
           this._currentPageIndex = index;
            this.raiseCarouselEvent(Enums.CarouselInteractionEvent.Pagination);
        })
        swiperObj.loop(this.carouselLoop);
        if(this.timer !== undefined) {
            swiperObj.interval(this.timer);
            swiperObj.autoPlay(true);
            this.raiseCarouselEvent(Enums.CarouselInteractionEvent.Autoplay);
        }
        if(this.carouselOrientation === Enums.Orientation.Horizontal) {
           swiperObj.vertical(false)
        }else {
            swiperObj.vertical(true)
        }
    }

    private createCarouselPageInstance(
        source: PropertyBag,
        context: SerializationContext
    ): CarouselPage | undefined {
        return context.parseCardObject<CarouselPage>(
            this,
            source,
            this.forbiddenChildElements(),
            !this.isDesignMode(),
            (typeName: string|undefined) => {
                return !typeName || typeName === "CarouselPage" ? new CarouselPage() : undefined;
            },
            (typeName: string|undefined, _errorType: TypeErrorType) => {
                context.logParseEvent(
                    undefined,
                    ValidationEvent.ElementTypeNotAllowed,
                    Strings.errors.elementTypeNotAllowed(typeName)
                );
            }
        );
    }

    slideTo(index: number) {
        // this._carousel?.slideTo(index);
        this._carousel?.attribute.index(index)
    }

    get carouselPageContainer() {
        return this._carouselPageContainer;
    }

    get currentIndex(): number {
        return this._currentIndex;
    }

    set currentIndex(currentIndex: number) {
        this._currentIndex = currentIndex;
    }

    private createCarouselEvent (type : Enums.CarouselInteractionEvent): CarouselEvent
    {
        let currentPageId : string | undefined;
        if (this.currentPageIndex != undefined) {
            currentPageId = this.getItemAt(this.currentPageIndex).id;
        }
        return new CarouselEvent(type, this.id, currentPageId, this.currentPageIndex);
    }

    private raiseCarouselEvent(eventType : Enums.CarouselInteractionEvent) {
        const card = this.parent ? (this.parent.getRootElement() as AdaptiveCard) : undefined;
        const onCarouselEventHandler =
            card && card.onCarouselEvent
                ? card.onCarouselEvent
                : AdaptiveCard.onCarouselEvent;
        // pagination event is triggered on slide transition end event
        if (onCarouselEventHandler && eventType == Enums.CarouselInteractionEvent.Pagination) {
        // returns the event type that causes slide transition
            onCarouselEventHandler(this.createCarouselEvent(this.previousEventType));
        }
        this.previousEventType = eventType;
    }
}

export class CarouselEvent {
    public type: Enums.CarouselInteractionEvent;
    public carouselId: string | undefined;
    public activeCarouselPageId: string | undefined;
    public activeCarouselPageIndex: number | undefined;

    constructor(type: Enums.CarouselInteractionEvent,
    carouselId: string | undefined,
    activeCarouselPageId: string | undefined,
    activeCarouselPageIndex: number | undefined) {
    this.type = type;
    this.carouselId = carouselId;
    this.activeCarouselPageId = activeCarouselPageId;
    this.activeCarouselPageIndex = activeCarouselPageIndex;
}
}

GlobalRegistry.defaultElements.register(
    "Carousel",
    Carousel,
    Versions.v1_6
);

