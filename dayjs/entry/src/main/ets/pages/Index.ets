/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import prompt from '@ohos.prompt';
import dayjs from "dayjs";

import customParseFormat from "dayjs/plugin/customParseFormat"
import * as ns from  'dayjs/locale/zh-cn';

dayjs.extend(customParseFormat)

interface ApiItem {
  apiName: string;
  func: () => void;
  des?: Resource;
}

interface ModuleItem {
  moduleName: string;
  examples: Array<ApiItem>
}

@Entry
@Component
struct Index {
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State message: string = 'Hello World'
  @State apisIndex:Array<ModuleItem>=[
  {
    moduleName: "Parse",
    examples: [
      {
        apiName: "dayjs('20130108').valueOf()",
        des:$r('app.string.Parse_get_timestamp'),
        func: () => {
          this.showMessage(dayjs('20130108').valueOf().toString())
        }
      },
      {
        apiName: "dayjs( '2018-04-24').valueOf()",
        des:$r('app.string.Parse_timestamp'),
        func: () => {
          this.showMessage(dayjs( '2018-04-24').valueOf().toString())
        }
      },
      {
        apiName: "dayjs('2018-04-24 11:12').format()",
        des:$r('app.string.Parse_hours_and_minutes'),
        func: () => {
          this.showMessage(dayjs('2018-04-24 11:12').format())
        }
      },

      {
        apiName: "dayjs( '2018-05-02 11:12:13').valueOf()",
        des:$r('app.string.Parse_hours_minutes_and_seconds'),
        func: () => {
          this.showMessage(dayjs( '2018-05-02 11:12:13').valueOf().toString())
        }
      },
      {
        apiName: "dayjs().toJSON()",
        des:$r('app.string.Get_toJSON'),
        func: () => {
          this.showMessage(dayjs().toJSON())
        }
      },
      {
        apiName: "dayjs('2018-05-02 11:12:13.998').valueOf()",
        des:$r('app.string.Parse_hours_minutes_seconds_milliseconds'),
        func: () => {
          this.showMessage(dayjs('2018-05-02 11:12:13.998').valueOf().toString())

        }
      },
      {
        apiName: "dayjs( '2018-4-1').valueOf()",
        des:$r('app.string.Get_timestamp'),
        func: () => {
          this.showMessage(dayjs( '2018-4-1').valueOf().toString())
        }
      },
      {
        apiName: "dayjs().second()",
        des:$r('app.string.Get_current_second'),
        func: () => {
          this.showMessage(dayjs().second() + "")
        }
      },
      {
        apiName: "dayjs().minute()",
        des:$r('app.string.Get_current_points'),
        func: () => {
          this.showMessage(dayjs().minute() + "")
        }
      },
      {
        apiName: "dayjs().hour()",
        des:$r('app.string.Get_current_tense'),
        func: () => {
          this.showMessage(dayjs().hour() + "")
        }
      },
      {
        apiName: "dayjs().date()",
        des:$r('app.string.Get_current_day'),
        func: () => {
          this.showMessage(dayjs().date().toString())
        }
      },
      {
        apiName: "dayjs().day()",
        des:$r('app.string.Get_the_current_week'),
        func: () => {
          this.showMessage(dayjs().day() + "")
        }
      },
      {
        apiName: "dayjs().month()",
        des:$r('app.string.Get_the_current_month'),
        func: () => {
          this.showMessage(dayjs().month() + "")
        }
      },
      {
        apiName: "dayjs().year()",
        des:$r('app.string.Get_the_current_year'),
        func: () => {
          this.showMessage(dayjs().year() + "")
        }
      },
      {
        apiName: 'dayjs("2024-01-10 20:00:00").startOf("day").subtract(1,"hour").format()',
        des:$r('app.string.Set_startOf'),
        func: () => {
          this.showMessage(dayjs("2024-01-10 02:00:00").startOf("day").subtract(1,"hour").format() + "")
        }
      },
      {
        apiName: 'dayjs("2024-01-10 20:00:00").endOf("day").add(1,"hour").format()',
        des:$r('app.string.Set_endOf'),
        func: () => {
          this.showMessage(dayjs("2024-01-10 20:00:00").endOf("day").add(1,"hour").format() + "")
        }
      },
      {
        apiName: 'dayjs("2023-12-31").diff("2024-01-10","days")',
        des:$r('app.string.Get_difference_days'),
        func: () => {
          this.showMessage(dayjs("2023-12-31").diff("2024-01-10","days") + "")
        }
      },
      {
        apiName: 'dayjs().daysInMonth()',
        des:$r('app.string.Get_days_month'),
        func: () => {
          this.showMessage(dayjs().daysInMonth() + "")
        }
      },
      {
        apiName: "dayjs().get('year');",
        des:$r('app.string.Get_year_through_get'),
        func: () => {
          this.showMessage(dayjs().get('year') + "")
        }
      },
      {
        apiName: "dayjs().set('year', 2013);",
        des:$r('app.string.Get_year_through_Set'),
        func: () => {
          this.showMessage(dayjs().set('year', 2013).format())
        }
      },
      {
        apiName: "dayjs().subtract(1, 'day')",
        des:$r('app.string.Current_day_forward'),
        func: () => {
          this.showMessage(dayjs().subtract(1, 'day').format())
        }
      },
      {
        apiName: "dayjs().add(1, 'day')",
        des:$r('app.string.One_day_after_current'),
        func: () => {
          this.showMessage(dayjs().add(1, 'day').format())
        }
      },
    ],
  }]

  showMessage(text: string) {
    this.getUIContext().getPromptAction().showToast({ message: text + "" || "no information..." });
  }

  getResourceString(res:Resource) {
    return this.getUIContext().getHostContext()!.resourceManager.getStringSync(res.id)
  }

  @Builder BuildItemForAPI(param: ModuleItem) {
    Column() {
      Text(param.moduleName).fontSize(30)

      ForEach(param.examples, (item:ApiItem, index) => {
        Flex({ alignItems: ItemAlign.Start ,direction:FlexDirection.Column}) {
          Column(){
            Text(`${item.apiName}`).fontSize(20).margin({ bottom: 8 }).width("100%")
            Text(this.getResourceString($r('app.string.describe')) +`：${this.getResourceString(item.des) || "none"}`).fontSize(16).fontColor(Color.Red).width("100%").margin({top:10,bottom:20})
          }


          Button("run").onClick(() => item.func()).width("100%");
        }.padding(10).margin({ bottom: 10 }).width("100%")
      })
    }

  }

  build() {
    Column() {
      List() {
        ForEach(this.apisIndex, (v: ModuleItem, index) => {
          ListItem() {
            this.BuildItemForAPI({ moduleName: v.moduleName, examples: v.examples })
          }
        })
      }.width("100%")
    }.width("100%").height("100%")

  }
}