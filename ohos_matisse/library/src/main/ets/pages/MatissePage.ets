/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import {
  PhotoPickerComponent,
  PickerOptions,
  ItemType,
  ClickType,
  MaxCountType,
  ReminderMode,
  photoAccessHelper
} from '@kit.MediaLibraryKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { promptAction, window } from '@kit.ArkUI';
import router from '@ohos.router';
import { PhotoMetadataUtils } from '../internal/utils/PhotoMetadataUtils';
import { fileUri } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import {
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserRange,
  PhotoBrowserInfo,
  PhotoBrowserUIElement,
  PickerController,
} from '@ohos.file.PhotoPickerComponent';

/**
 * Matisse media selection page component
 * Provides photo and video selection functionality with various configuration options
 */
@Component
export struct MatissePage {
  @State private originalChecked: boolean = false;
  @State private selectUris: string[] =[];
  @State private selectPaths:  string[] =[];
  @State private selectItemInfo: ItemInfo | null = null;
  @State private selectedItemInfos: ItemInfo[] = [];
  @State private currentUri: string = '';
  @State private isBrowserShow: boolean = false;
  @State private isPreviewText: Resource = $r('app.string.preview_text');
  @State private mButtonApplyText: Resource | string = $r('app.string.button_apply_default');
  @State private mButtonApplyStatus: boolean = false;
  @State private originalVisibility: Visibility = Visibility.Visible;
  @State private mButtonPreviewStatus: boolean = false;
  @State private mItemClickedStatus: boolean = false;
  @State private isVisibilityToggleAllowed: boolean = false;
  @State private mainVisibility: Visibility = Visibility.Visible;
  @State private previewTextVisibility: Visibility = Visibility.Visible;
  @Prop mimeType: string | null = null;
  @Prop mediaTypeExclusive: boolean = false;
  @Prop themeId: number = 0;
  @Prop orientation: number = 0;
  @Prop countable: boolean = true;
  @Prop maxSelectable: number = 1;
  @Prop maxImageSelectable: number = 0;
  @Prop maxVideoSelectable: number = 0;
  @Prop capture: boolean = false;
  @Prop originalable: boolean = true;
  @Prop autoHideToobar: boolean = false;
  @Prop originalMaxSize: number = Number.MAX_SAFE_INTEGER;
  forResult?: (uris: Array<string>, paths: Array<string>, originalChecked: boolean) => void;
  setOnCheckedListener?: (isChecked: boolean) => void;
  setOnSelectedListener?: (uriList: Array<string>, pathList: Array<string>) => void;
  private pickerOptions: PickerOptions = new PickerOptions();
  @State private pickerController: PickerController = new PickerController();
  private mPhotoMetadataUtils: PhotoMetadataUtils = PhotoMetadataUtils.getInstance();
  private computedMaxSelectable: number = 1;
  private computedMaxImageSelectable: number = 0;
  private computedMaxVideoSelectable: number = 0;
  private isFromCamera: boolean = false;

  /**
   * Component initialization
   * Configures picker options and validates selection limits
   */
  aboutToAppear(): void {
    this.computeMaxSelectable();
    this.configureMimeType();
    this.configurePickerOptions();
    this.applyOrientationRestriction();
    this.updateBottomToolbar();
  }

  /**
   * Component cleanup
   * Resets screen orientation to auto
   */
  aboutToDisappear(): void {
    window.getLastWindow(getContext(this) as common.UIAbilityContext)
      .then((win) => {
        win.setPreferredOrientation(0);
      });
  }

  /**
   * Computes maximum selectable count based on configuration
   */
  private computeMaxSelectable(): void {
    if (this.maxImageSelectable > 0 || this.maxVideoSelectable > 0) {
      // Use separate media type limits
      if (this.maxImageSelectable < 1 && this.maxVideoSelectable < 1) {
        throw new Error('max selectable must be greater than or equal to one');
      }
      this.computedMaxSelectable = -1;
      this.computedMaxImageSelectable = Math.max(this.maxImageSelectable, 0);
      this.computedMaxVideoSelectable = Math.max(this.maxVideoSelectable, 0);
    } else {
      // Use global limit
      if (this.maxSelectable < 1) {
        throw new Error('maxSelectable must be greater than or equal to one');
      }
      this.computedMaxSelectable = this.maxSelectable;
      this.computedMaxImageSelectable = 0;
      this.computedMaxVideoSelectable = 0;
    }
  }

  /**
   * Configures MIME type for picker
   */
  private configureMimeType(): void {
    const mimeType = this.mimeType;
    if (mimeType === 'image/*') {
      this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    } else if (mimeType === 'video/*') {
      this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    } else if (mimeType === '*/*') {
      this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    } else if (mimeType === 'image/movingPhoto') {
      this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE;
    } else if (mimeType === 'image/gif') {
      this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    }
  }

  /**
   * Configures picker options
   */
  private configurePickerOptions(): void {
    if (this.computedMaxImageSelectable > 0) {
      this.pickerOptions.maxPhotoSelectNumber = this.computedMaxImageSelectable;
    }
    if (this.computedMaxVideoSelectable > 0) {
      this.pickerOptions.maxVideoSelectNumber = this.computedMaxVideoSelectable;
    }
    this.pickerOptions.maxSelectNumber = this.computedMaxSelectable;
    this.pickerOptions.maxSelectedReminderMode = ReminderMode.TOAST;
    this.pickerOptions.isSearchSupported = false;
    this.pickerOptions.isPhotoTakingSupported = this.capture;
  }

  /**
   * Applies screen orientation restriction if configured
   */
  private applyOrientationRestriction(): void {
    if (this.needOrientationRestriction()) {
      window.getLastWindow(getContext(this) as common.UIAbilityContext)
        .then((win) => {
          win.setPreferredOrientation(this.orientation);
        });
    }
  }

  /**
   * Notifies selected items changed
   */
  private notifySelectedChanged(): void {
    this.setOnSelectedListener?.([...this.selectUris], [...this.selectPaths]);
  }

  /**
   * Notifies original image checked state changed
   */
  private notifyCheckedChanged(): void {
    this.setOnCheckedListener?.(this.originalChecked);
  }

  /**
   * Checks if single selection mode is enabled
   * @returns true if single selection mode is enabled
   */
  private singleSelectionModeEnabled(): boolean {
    return !this.countable &&
      (this.maxSelectable === 1 || (this.maxImageSelectable === 1 && this.maxVideoSelectable === 1));
  }

  /**
   * Checks if orientation restriction is needed
   * @returns true if orientation restriction is needed
   */
  private needOrientationRestriction(): boolean {
    return this.orientation !== 0;
  }

  /**
   * Handles item click event
   * @param itemInfo - The clicked item information
   * @param clickType - The click type (SELECTED or UNSELECTED)
   * @returns true if the click is handled successfully
   */
  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    this.mItemClickedStatus = true;
    setTimeout(() => {
      this.mItemClickedStatus = false;
    }, 300);

    if (!itemInfo) {
      return false;
    }

    this.selectItemInfo = itemInfo;
    const type: ItemType | undefined = itemInfo.itemType;
    if (type === ItemType.CAMERA) {
      this.isFromCamera = true;
      setTimeout(() => {
        this.isFromCamera = false;
      }, 3000);
      return true;
    }

    // Check media type exclusivity
    if (this.mediaTypeExclusive && this.selectedItemInfos.length > 0 && clickType === ClickType.SELECTED) {
      if (!this.isSameMediaType(itemInfo)) {
        promptAction.showToast({
          message: $r('app.string.media_type_exclusive_message'),
          duration: 1500
        });
        return false;
      }
    }

    const uri: string | undefined = itemInfo.uri;
    if (uri) {
      if (clickType === ClickType.SELECTED) {
        if (!this.addSelectedItem(uri, itemInfo)) {
          return false;
        }
      } else {
        this.removeSelectedItem(uri, itemInfo);
      }
      this.updateBottomToolbar();
      this.notifySelectedChanged();
    }

    return true;
  }

  /**
   * Checks if the new item has the same media type as already selected items
   * @param itemInfo - The new item to check
   * @returns true if same media type
   */
  private isSameMediaType(itemInfo: ItemInfo): boolean {
    const firstMime = this.selectedItemInfos[0]?.mimeType?.toLowerCase() ?? '';
    const newMime = itemInfo.mimeType?.toLowerCase() ?? '';
    const firstIsVideo = firstMime.startsWith('video/');
    const newIsVideo = newMime.startsWith('video/');
    const firstIsImage = firstMime.startsWith('image/');
    const newIsImage = newMime.startsWith('image/');
    return (firstIsVideo && newIsVideo) || (firstIsImage && newIsImage);
  }

  /**
   * Checks if the item is in GIF format
   * @param itemInfo - The item to check
   * @returns true if the item is GIF format
   */
  private isGifFormat(itemInfo: ItemInfo): boolean {
    const mime = itemInfo.mimeType?.toLowerCase() ?? '';
    return mime.includes('gif');
  }

  /**
   * Adds an item to selected list
   * @param uri - The item URI
   * @param itemInfo - The item information
   * @returns true if item was added, false if blocked
   */
  private addSelectedItem(uri: string, itemInfo: ItemInfo): boolean {
    if (this.mimeType === 'image/gif' && !this.isGifFormat(itemInfo)) {
      const shouldShowToast = !this.isFromCamera;
      this.isFromCamera = false;
      if (shouldShowToast) {
        promptAction.showToast({
          message: $r('app.string.gif_only_message'),
          duration: 2000
        });
      }
      return false;
    }
    
    this.isFromCamera = false;
    this.selectUris.push(uri);
    this.pickerOptions.preselectedUris = [...this.selectUris];
    const fileUriObj = new fileUri.FileUri(uri);
    const sandboxPath = fileUriObj.path;
    this.selectPaths.push(sandboxPath);
    this.selectedItemInfos.push(itemInfo);
    return true;
  }

  /**
   * Removes an item from selected list
   * @param uri - The item URI
   * @param itemInfo - The item information
   */
  private removeSelectedItem(uri: string, itemInfo: ItemInfo): void {
    this.selectUris = this.selectUris.filter((item: string) => item !== uri);
    this.pickerOptions.preselectedUris = [...this.selectUris];
    this.selectedItemInfos = this.selectedItemInfos.filter((item: ItemInfo) => item.uri !== uri);
    const fileUriObj = new fileUri.FileUri(uri);
    const sandboxPath = fileUriObj.path;
    this.selectPaths = this.selectPaths.filter((path: string) => path !== sandboxPath);
  }

  /**
   * Handles entering photo browser
   * @param photoBrowserInfo - Photo browser information
   * @returns true if handled successfully
   */
  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isBrowserShow = true;
    this.mButtonPreviewStatus = true;
    if (deviceInfo.sdkApiVersion > 12) {
      this.isPreviewText = $r('app.string.back_text');
      this.previewTextVisibility = Visibility.Visible;
    } else {
      this.previewTextVisibility = Visibility.Hidden;
    }
    return true;
  }

  /**
   * Handles exiting photo browser
   * @param photoBrowserInfo - Photo browser information
   * @returns true if handled successfully
   */
  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isBrowserShow = false;
    this.isVisibilityToggleAllowed = false;
    this.mainVisibility = Visibility.Visible;
    this.previewTextVisibility = Visibility.Visible;
    this.isPreviewText = $r('app.string.preview_text');
    this.mButtonPreviewStatus = this.selectUris.length > 0;
    return true;
  }

  /**
   * Handles picker controller ready event
   */
  private onPickerControllerReady(): void {
    if (deviceInfo.sdkApiVersion > 12) {
       const elements: number[] = [PhotoBrowserUIElement.BACK_BUTTON];
       this.pickerController.setPhotoBrowserUIElementVisibility(elements, false);
    }
  }

  /**
   * Handles photo browser changed event
   * @param browserItemInfo - Browser item information
   * @returns true if handled successfully
   */
  private onPhotoBrowserChanged(browserItemInfo: BaseItemInfo): boolean {
    this.currentUri = browserItemInfo.uri ?? '';
    return true;
  }

  /**
   * Updates bottom toolbar state
   */
  private updateBottomToolbar(): void {
    const selectedCount: number = this.selectUris.length;
    this.updateApplyButton(selectedCount);
    this.updatePreviewButton(selectedCount);
    this.updateOriginalVisibility();
  }

  /**
   * Updates apply button state
   * @param selectedCount - Number of selected items
   */
  private updateApplyButton(selectedCount: number): void {
    if (selectedCount === 0) {
      this.mButtonApplyStatus = false;
      this.mButtonApplyText = $r('app.string.button_apply_default');
    } else if (!this.countable) {
      this.mButtonApplyStatus = true;
      this.mButtonApplyText = $r('app.string.button_apply_default');
    } else {
      this.mButtonApplyStatus = true;
      this.mButtonApplyText = $r('app.string.button_apply', selectedCount);
    }
  }

  /**
   * Updates preview button state
   * @param selectedCount - Number of selected items
   */
  private updatePreviewButton(selectedCount: number): void {
    if (this.isBrowserShow) {
      this.mButtonPreviewStatus = true;
    } else {
      this.mButtonPreviewStatus = selectedCount > 0;
    }
  }

  /**
   * Updates original image visibility
   */
  private updateOriginalVisibility(): void {
    const originalEnable = this.originalable;
    this.originalVisibility = originalEnable ? Visibility.Visible : Visibility.Hidden;
    if (originalEnable) {
      this.updateOriginalState();
    }
  }

  /**
   * Updates original image state and checks size limit
   */
  private updateOriginalState(): void {
    if (!this.originalChecked) {
      return;
    }
    const overSizeCount = this.countOverMaxSize();
    if (overSizeCount > 0) {
      if (this.originalable) {
        AlertDialog.show({
          title: '',
          message: $r('app.string.photo_size_exceeded_message', this.originalMaxSize),
          confirm: {
            value: $r('app.string.dialog_confirm'),
            action: () => {
              console.info('User confirmed dialog');
            }
          }
        });
        this.originalChecked = false;
        this.notifyCheckedChanged();
      }
    }
  }

  /**
   * Counts items that exceed maximum size limit
   * @returns Number of items exceeding the limit
   */
  private countOverMaxSize(): number {
    let count: number = 0;
    for (let i: number = 0; i < this.selectedItemInfos.length; i++) {
      const itemInfo = this.selectedItemInfos[i];
      if (itemInfo && itemInfo.mimeType?.startsWith('image/')) {
        const imageSize = itemInfo.size || 0;
        if (this.mPhotoMetadataUtils.getSizeInMB(imageSize) > this.originalMaxSize) {
          count++;
        }
      }
    }
    return count;
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Start
    }) {
      Stack() {
        PhotoPickerComponent({
          pickerOptions: this.pickerOptions,
          onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => {
            return this.onItemClicked(itemInfo, clickType);
          },
          onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => {
            return this.onEnterPhotoBrowser(photoBrowserInfo);
          },
          onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => {
            return this.onExitPhotoBrowser(photoBrowserInfo);
          },
          onPickerControllerReady: (): void => {
            this.onPickerControllerReady();
          },
          onPhotoBrowserChanged: (browserItemInfo: BaseItemInfo): boolean => {
            return this.onPhotoBrowserChanged(browserItemInfo);
          },
          pickerController: this.pickerController,
        })
      }
        .gesture(
          TapGesture({ count: 1 })
            .onAction((event: GestureEvent | undefined) => {
              if (!this.isBrowserShow) {
                return;
              }
              if (this.autoHideToobar && event) {
                if (this.isVisibilityToggleAllowed && !this.mItemClickedStatus &&  deviceInfo.sdkApiVersion > 12) {
                  this.mainVisibility =
                    this.mainVisibility === Visibility.Visible ? Visibility.Hidden : Visibility.Visible;
                  const elements: number[] = [PhotoBrowserUIElement.CHECKBOX];
                  this.pickerController.setPhotoBrowserUIElementVisibility(
                    elements,
                    this.mainVisibility === Visibility.Visible
                  );
                }
              }
              this.isVisibilityToggleAllowed = true;
            })
        );

      Row() {
        Text(this.isPreviewText)
          .layoutWeight(1)
          .textAlign(TextAlign.Start)
          .padding({ left: 10 })
          .fontSize(16)
          .enabled(this.mButtonPreviewStatus)
          .opacity(this.mButtonPreviewStatus ? 1 : 0.4)
          .visibility(this.previewTextVisibility)
          .onClick(() => {
            if (this.isBrowserShow) {
              if (deviceInfo.sdkApiVersion > 12) {
                 this.pickerController.exitPhotoBrowser();
              }
            } else if (this.mButtonPreviewStatus) {
              this.pickerController.setPhotoBrowserItem(
                this.selectUris[0],
                PhotoBrowserRange.SELECTED_ONLY
              );
              this.isVisibilityToggleAllowed = true;
            }
          });

        Row() {
          Radio({ value: 'original', group: 'grp' })
            .width(14)
            .height(14)
            .checked(this.originalChecked)
            .onClick(() => {
              this.originalChecked = !this.originalChecked;
              if (this.originalChecked) {
                const count: number = this.countOverMaxSize();
                if (count > 0) {
                  AlertDialog.show({
                    title: '',
                    message: $r('app.string.photo_size_exceeded_message', this.originalMaxSize),
                    confirm: {
                      value: $r('app.string.dialog_confirm'),
                      action: () => {
                        this.originalChecked = !this.originalChecked;
                        this.notifyCheckedChanged();
                      }
                    }
                  });
                  return;
                }
              }
              this.notifyCheckedChanged();
            });
          Text($r('app.string.original_image_text'))
            .fontSize(16)
            .fontColor('#000')
            .margin({ left: 2 });
        }
        .visibility(this.originalVisibility)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center);

        Text(this.mButtonApplyText)
          .layoutWeight(1)
          .textAlign(TextAlign.End)
          .padding({ right: 10 })
          .fontSize(16)
          .enabled(this.mButtonApplyStatus)
          .opacity(this.mButtonApplyStatus ? 1 : 0.4)
          .onClick(() => {
            if (this.mButtonApplyStatus) {
              this.forResult?.(this.selectUris, this.selectPaths, this.originalChecked);
              router.back();
            }
          });
      }
      .visibility(this.mainVisibility)
      .width('100%')
      .height(56)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween);
    }
  }
}
