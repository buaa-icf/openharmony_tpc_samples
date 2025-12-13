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
import { RiveAnimationView } from '@ohos/rive';

interface ListCategories {
    title: string,
    url: string
}

@Entry
@Component
struct ViewPagerPage {
    private scrollerForList: Scroller = new Scroller()
    private items: ListCategories[] =
        [
            { title: '01', url: '@rawfile/flux_capacitor.riv' },
            { title: '02', url: '@rawfile/off_road_car_blog.riv' },
            { title: '03', url: '@rawfile/basketball.riv' },
            { title: '04', url: '@rawfile/artboard_animations.riv' },
        ];

    build() {
        Column() {
            Row() {
                Text('ViewPager Rive Simple')
                    .fontSize(20)
                    .fontWeight(FontWeight.Medium)
                    .textAlign(TextAlign.Center)
                    .fontColor('#FFFFFF')
                    .margin({ left: 20 })
            }
            .width('100%')
            .height(56)
            .backgroundColor('#6200EE')
            .alignItems(VerticalAlign.Center)

            Column() {
                Row() {
                    List({ space: 0, initialIndex: 0, scroller: this.scrollerForList }) {
                        Repeat<ListCategories>(this.items).each((ri: RepeatItem<ListCategories>) => {
                            ListItem() {
                                RiveAnimationView({
                                    riveResource: ri.item.url,
                                    riveFit: 'cover'
                                })
                            }
                            .backgroundColor(Color.Transparent)
                            .width('100%')
                            .height('100%')
                        })
                    }
                    .chainAnimation(true)
                    .edgeEffect(EdgeEffect.Spring)
                    .listDirection(Axis.Horizontal)
                    .height('50%')
                    .width('100%')
                    .alignListItem(ListItemAlign.Center)
                    .scrollSnapAlign(ScrollSnapAlign.CENTER)
                    .backgroundColor(0xDCDCDC)
                }
            }
            .position({ y: '25%' })
        }
        .width('100%')
        .height('100%')
    }
}