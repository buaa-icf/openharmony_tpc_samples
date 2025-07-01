/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import { describe, it, expect } from '@ohos/hypium';
import xmldom, { Element } from '@xmldom/xmldom';
import { extractStyle } from '../../../main/ets/kml/extractStyle';

interface KmlStyle {
  "fill"?: string;
  "fill-opacity"?: number;
  "icon"?: string;
  "icon-color"?: string;
  "icon-opacity"?: number;
  "icon-scale"?: number;
  "label-scale"?: number;
  "icon-offset"?: [number, number];
  "icon-offset-units"?: [string, string];
  "stroke"?: string;
  "stroke-opacity"?: number;
  "stroke-width"?: number;
}


function parse(xml: string): Element {
  return new xmldom.DOMParser().parseFromString(xml, "text/xml")
    .firstChild as Element;
}

export default function extractStyleTest() {
  describe('ExtractStyleTests', () => {
    it('passes-through_CSS_colors', 0, () => {
      // 1. 准备测试数据
      const xmlElement = parse(`<Style>
<IconStyle>
<Icon>
<href>https://earth.google.com/earth/rpc/cc/icon?color=1976d2&amp;id=2000&amp;scale=4</href>
</Icon>
<hotSpot x="64" y="128" xunits="pixels" yunits="insetPixels"/>
</IconStyle>
<LabelStyle>
</LabelStyle>
<LineStyle>
<color>ff9f3f30</color>
<width>2.13333</width>
</LineStyle>
<PolyStyle>
<color>4058eeff</color>
</PolyStyle>
<BalloonStyle>
<displayMode>hide</displayMode>
</BalloonStyle>
</Style>`);
      const expectedStyle: KmlStyle = {
        "fill": "#ffee58",
        "fill-opacity": 0.25098039215686274,
        "icon": "https://earth.google.com/earth/rpc/cc/icon?color=1976d2&id=2000&scale=4",
        "icon-offset": [64, 128],
        "icon-offset-units": ["pixels", "insetPixels"],
        "stroke": "#303f9f",
        "stroke-opacity": 1,
        "stroke-width": 2.13333,
      };

      const actualStyle: KmlStyle = extractStyle(xmlElement);
      expect(actualStyle).assertDeepEquals(expectedStyle);
    });
    it("should_pass_through_CSS_colors", 0, () => {
      // 1. 准备 XML 数据
      const xmlElement = parse(`<Style>
        <IconStyle>
          <color>ffd18802</color>
          <scale>1</scale>
          <Icon>
            <href>https://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>
          </Icon>
          <hotSpot x="32" xunits="pixels" y="64" yunits="insetPixels"/>
        </IconStyle>
        <LabelStyle>
          <scale>0</scale>
        </LabelStyle>
        <BalloonStyle>
          <text><![CDATA[<h3>$[name]</h3>]]></text>
        </BalloonStyle>
      </Style>`);

      // 2. 根据快照内容，定义期望的对象，并使用 KmlStyle 接口
      const expectedStyle: KmlStyle = {
        "icon": "https://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png",
        "icon-color": "#0288d1",
        "icon-offset": [32, 64],
        "icon-offset-units": ["pixels", "insetPixels"],
        "icon-opacity": 1,
        "icon-scale": 1,
        "label-scale": 0,
      };

      // 3. 调用函数并为结果指定类型
      const actualStyle: KmlStyle = extractStyle(xmlElement);
      console.log('结果',JSON.stringify(actualStyle))
      // 4. 使用 assertEqual 进行断言
      expect(actualStyle).assertDeepEquals(expectedStyle);
    });
  });
}