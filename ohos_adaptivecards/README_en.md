# ohos_adaptivecards

## Overview
Adaptive widgets are open widgets that allow developers to generate UI content using JSON.

## How to Install

  ```shell
ohpm install @ohos/adaptivecards
  ```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Quick Start
Use the system component [NodeContainer](https://docs.openharmony.cn/pages/v5.0/en/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-nodecontainer.md) as the placeholder node of the custom node. The **FrameNode** tree generated after AdaptiveCards processing is mounted to the corresponding **NodeContainer** through a series of lifecycle callbacks provided by **NodeController**.

1. Create a Node class.

```
class DynamicsNodeController extends NodeController {
  public rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode == null) {
      this.rootNode = new FrameNode(uiContext);
      this.rootNode.commonAttribute
        .width("100%")
    }
    return this.rootNode;
  }
}
```

2. Render a custom node using **NodeContainer**.

```
@Entry
@Component
struct Index {
  controller: DynamicsNodeController = new DynamicsNodeController(); // Build a node.

  build() {
    Column() {
      Column(){
      Scroll() {
        Column() {
          NodeContainer(this.controller)  // Widget rendering position.
        }.width('100%')
      }
      .scrollable(ScrollDirection.Vertical) // The scrollbar scrolls in the vertical direction.
      .scrollBar(BarState.On) // The scrollbar is always displayed.
      .scrollBarColor(Color.Gray) // The scrollbar color is gray.

      }.height("50%")

      Button('Generate Widget')
        .id('adaptivecards')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .onClick(async () => {
          let node = await this.renderHello(); // Create a widget.
          this.controller.rootNode?.appendChild(node) // Add the widget to the NodeContainer.
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Gray)

  }

  async renderHello(): Promise<FrameNode | undefined> {
    let adaptiveCard = new AdaptiveCards.AdaptiveCard(); // Create an adaptive widget.

    adaptiveCard.onExecuteAction = (action) => {
      console.dir(action)
    } // Used to process relevant information in the click event callback action.
    
    let card = await getContext(this).resourceManager.getRawFileContent('test.json') // Read the JSON file in resources/rawfile.
    
    const json = buffer.from(card).toString(); 
    
    adaptiveCard.parse(JSON.parse(json));
    
    return adaptiveCard.render(this.getUIContext()); // Pass the UIContext to build a node.
    
  }
}
```

### Precautions
1. Components are supported since API version 14.
2. When the text in **TextRun** exceeds one line, the subsequent TextRun content is automatically displayed in a new line.

### ColumnSet

Divides an area into columns, allowing elements to be placed side by side.

| Property                 | Type                  | Mandatory| Description                                           |
|---------------------|----------------------|------|-----------------------------------------------|
| type                | ColumnSet          | Yes   | The value must be **ColumnSet**.                              |
| columns             | Column[]             | No   | Column array.                                     |
| selectAction        | ISelectAction        | No   | Action invoked when **ColumnSet** is tapped or selected.|
| style               | ContainerStyle?      | No   | ColumnSet style settings.                                          |
| bleed               | boolean              | No   | Whether the element should overflow the parent's padding.                                            |
| minHeight           | string               | No   | Minimum height of the column set in pixels, for example, 80px.                                         |
| horizontalAlignment | HorizontalAlignment? | No   | Horizontal alignment mode of **ColumnSet**. The default value is left alignment.                                     |

### Column

Defines a container, which is a part of a column.

| Property                      | Type                       | Mandatory| Description                                                          |
|--------------------------|---------------------------|------|--------------------------------------------------------------|
| items                    | 	Element[]                | No   | Widget element to be displayed in the column.                                                |
| backgroundImage          | BackgroundImage,uri       | No   | Background image. The supported formats are PNG, JPEG, and GIF.                                  |
| bleed                    | boolean                   | No   | Whether the column should overflow the parent column's padding.                                            |
| fallback                 | Column, FallbackOption   | No   | How to handle an unknown item or if this item or any sub-item cannot be met.                              |
| minHeight                | string                    | No   | Minimum height of the column set in pixels, for example, 80px.                                     |
| rtl                      | boolean?                  | No   | Arrangement within the column. The value **true** means the items are arranged from right to left, the value **false** means the items are arranged from left to right, and the value **undefined** means the items are inherited from the parent component.      |
| separator                | boolean                   | No   | If the value is true, a dividing line is drawn between this column and the previous column.                                   |
| spacing                  | Spacing                   | No   | Spacing between this column and the previous column.                                             |
| selectAction             | ISelectAction             | No   | Operation to be called when a column is tapped or selected.                                             |
| style                    | ContainerStyle?           | No   | Column style settings.                                                 |
| verticalContentAlignment | VerticalContentAlignment? | No   | How the content is vertically aligned in the column. If not specified, the value is inherited from the parent container. The default value is **Top**.|
| width                    | string,number             | No   | **auto** or **stretch**, indicating the relative width of a column in a column group, for example, 50px.            |

### AdaptiveCard

An adaptive widget that contains the widget element body in free format and a group of optional operations.

| Property        | Type     | Mandatory| Description|
|--------------------------|---------------------------|------|--------------------------------------------------------------|
| type         | AdaptiveCard | Yes   | Type of an adaptive widget.
| version          | string      | Yes   |Architecture version required by the widget.
| body      | Element[]      | Yes   | Widget element to be displayed in the main widget area.
| backgroundColor    | string   | No   | Background color applied to transparent images. This property follows the image style.
| lang       | string       | No   |Two-letter ISO-639-1 language code for localizing date/time functions.
| backgroundImage        | string  | No   |Background image of a widget.
| rtl    | boolean?     | No   |The value **true** means the content in the adaptive widget should be displayed from right to left, and the value **false** means the content in the adaptive widget should be displayed from left to right. If the value is not specified, the default behavior of the application platform is used.

### Container

Groups items together.

| Property                    | Type        | Mandatory| Description|
|--------------------------|---------------------------|------|--------------------------------------------------------------|
| type                     | Container       | Yes   |Container type.
| verticalContentAlignment | VerticalContentAlignment? | No   |Vertical alignment mode of the content in the container. If it is not specified, the value of **verticalContentAlignment** is inherited from the parent container. If no parent container has **verticalContentAlignment** set, the default value is **Top**.
| spacing                  | Spacing              | No   | Spacing between this element and the previous element.
| separator                | boolean                   | No   |The value **true** means a dividing line is drawn at the top of the element.
| height                   | CardElementHeight         | No   |Element height.
| style                    | ContainerStyle            | No   | Container style.                                                                                            
| isVisible                | boolean                   | No   |The value **false** means the item will be removed from the visualization tree.                                                                        
| id                       | string                    | No   |Unique identifier for association.                                                                                        
| requires                 | Dictionary<string>        | No   |A series of key-value pairs indicating required features, minimum versions. When a functionality is unavailable or the version is insufficient, the rollback mechanism is triggered.                                                
| bleed                    | boolean                   | No   |Whether the element should penetrate the parent's inner margin.                                                                           
| minHeight                | string                    | No   |Minimum height of the container, in pixels, for example, 80px.                                                                       
| rtl                      | boolean?                  | No   |If the value is **true**, the content in the container is displayed from right to left. If the value is **false**, the content in the container is displayed from left to right. If the value is not set, the layout direction is inherited from the parent container or column. If none of the ancestor elements is set, the default behavior of the application platform is used.
| selectAction             | ISelectAction             | No   |Action invoked when the container is tapped or selected. The **Action.ShowCard** operation is not supported.

### Image

Displays images.

| Property                    | Type        | Mandatory| Description|
|--------------------------|---------------------------|------|--------------------------------------------------------------|
| type         | Image            | Yes   |Image type.
| url          | string             | Yes   |Image URL.                                    
| altText      | string            | No   |Alternative text if the image fails to load.                            
| backgroundColor    | string          | No   | Background color applied to transparent images. This property follows the image style.                   
| size       | ImageSize  | No   |Approximate size of the image. The actual dimensions vary depending on the host environment.                   
| style        | ImageStyle     | No   |Image display style.                               
| width    | string            | No   |Image width.                                     
| height           | string          | No   | Image height                                     
| selectAction     | ISelectAction | No   |Action invoked when the image is tapped or selected. The **Action.ShowCard** operation is not supported.

### TextBlock

Displays text with control over font size, weight, and color.

| Property                    | Type     | Mandatory| Description|
|--------------------------|---------|------|--------------------------------------------------------------|
| wrap         | boolean | No   | Whether to wrap text.
| maxLines          | number  | No   | Maximum number of rows to be displayed.
| style          | TextBlockStyle  | No   | Text style.

### TextRun

Defines a single run of formatted text. A **TextRun** without properties can be represented as a JSON string, containing text as an abbreviation for the JSON object.

| Property                    | Type     | Mandatory| Description|
|--------------------------|---------|------|--------------------------------------------------------------|
| italic         | boolean | No   | Whether the text should be italic.
| strikethrough          | boolean  | No   | Whether the text should be deleted.
| highlight          | boolean  | No   | Whether the text should be highlighted.
| underline          | boolean  | No   | Whether the text should be underlined.

### Input.Text

Allows users to enter text.

| Property                    | Type              | Mandatory| Description|
|--------------------------|------------------|------|--------------------------------------------------------------|
| defaultValue         | string           | No   | Default input value.
| maxLength          | boolean          | No   | Maximum length of the input text.
| isMultiline          | boolean          | No   | Whether the input supports multiple lines of text.
| placeholder          | string          | No   | Placeholder text displayed when the user does not enter any value.
| style         | InputTextStyle | Yes   | **Text**, **Tel**, **URL**, **Email**, and **Password** are supported.
| inlineAction          | boolean          | No   | Action that should be displayed as a button next to the input. **Action.ShowCard** is not supported.
| regex          | string          | No   | Regular expression used to verify the input.


### Action.ToggleVisibility

Toggles the visibility of related widget elements. For details about JSON parameters, see **/entry/src/main/resources/rawfile/ToggleVisibility.json**.

| Property            | Type                       | Mandatory| Description                          |
|----------------|---------------------------|------|------------------------------|
| type           | Action.ToggleVisibility | Yes   | The value must be **Action.ToggleVisibility**.|
| targetElements | TargetElement[]           | Yes   | Array of targets whose display or hide status needs to be toggled.   |


### FactSet

Displays elements in a table of name/value pairs. For details, see **/entry/src/main/resources/rawfile/FactSet.json**.

| Property            | Type       | Mandatory| Description          |
|----------------|-----------|------|--------------|
| type           | FactSet | Yes   | The value must be **FactSet**.|
| targetElements | Fact[]    | Yes   | Array of target elements.     |

### Fact

Indicates the key-value pair in **FactSet**.

| Property   | Type    | Mandatory| Description   |
|-------|--------|------|-------|
| title | string | Yes   | Key.    |
| value | string | Yes   | Value of the key.|

### Action.ShowCard

Specifies whether to display the elements in an area.

| Property  | Type              | Mandatory| Description                 |
|------|------------------|------|---------------------|
| type | Action.ShowCard | Yes   | Type.|
| card | AdaptiveCard     | No   | Adaptive widget to be displayed.              |

### Action.Execute

Collects input fields.

| Property  | Type              | Mandatory| Description                 |
|------|------------------|------|---------------------|
| type | Action.Execute | Yes   | Type.|
| verb | string           | No   | Verb defined by the widget author for this action.              |
| data | string           | No   | Initial data to be combined with the input field.              |

### Carousel

Displays carousel images.

| Property         | Type        | Mandatory| Description          |
|-------------|------------|------|--------------|
| type        | Carousel | Yes   | Carousel type.|
| initialPage | number     | No   | Page for which the carousel is initialized.    |
| loop        | boolean    | No   | Whether to play in a loop.      |
| orientation        | string     | No   | Horizontal or vertical display.        |
| heightInPixels        | string     | No   | Height.          |
| timer        | number     | No   | Carousel switch interval.    |

### Table

Displays data in a table.

| Property         | Type        | Mandatory| Description          |
|-------------|------------|------|--------------|
| type        | Table | Yes   | Table type.|
| columns | TableColumnDefinition[]     | No   | Number and size of columns in a table.    |
| rows        | TableRow[]    | No   | Row of a table.      |
| firstRowAsHeader        | boolean     | No   | Whether the first row of the table should be considered as the title row and announced by auxiliary feature software.       |
| showGridLines        | boolean     | No   | Whether to display grid lines.          |
| gridStyle        | ContainerStyle?     | No   | Grid style. This property currently controls only the grid color.    |
| horizontalCellContentAlignment        | HorizontalAlignment?     | No   | Horizontal alignment mode for all cells by default. If not specified, horizontal alignment is defined based on each cell.    |
| verticalCellContentAlignment        | VerticalAlignment?     | No   | Vertical alignment mode for all cells by default. If not specified, vertical alignment is defined based on each cell.    |


### TableRow

Indicates the rows of a table.

| Property       | Type         | Mandatory| Description        |
|-----------|-------------|------|------------|
| type      | TableRow  | Yes   | Row type.|
| cells     | TableCell[] | No   | Cell element.     |
| rowHeight     | string      | No   | Row height.      |


### TableCell

Indicates the cells in a table row.

| Property       | Type         | Mandatory| Description     |
|-----------|-------------|------|---------|
| type      | TableCell | Yes   | Cell type.|
| items     | Element[]   | No   | Cell element.  |


## Available APIs
| Name                   | Type| Supported| Description                                                             |
|-------------------------|----|------|-------------------------------------------------------------------|
| AdaptiveCard            | Component| Supported  | An adaptive widget that contains the widget element body in free format and a group of optional operations.                                  |
| Column                  | Component| Supported  | Defines a container as part of **ColumnSet**.                                           |
| ColumnSet               | Component| Supported  | Divides an area into columns, allowing elements to be placed side by side.                            |
| Container               | Component| Supported  | Groups items together.                                                    |
| TextBlock               | Component| Supported  | Displays text with control over font size, weight, and color.                                            |
| Image	               | Component| Supported  | Displays images. Supported formats include PNG, JPEG, and GIF.                                   |
| RichTextBlock           | Component| Supported  | Defines inline arrays and inline text formats.                                                 |
| Input.Text              | Component| Supported  | Allows users to enter text.                                                       |
| TextRun	                | Component| Supported  | Defines a single run of formatted text. A **TextRun** without properties can be represented as a JSON string, containing text as an abbreviation for the JSON object.|
| ActionSet               | Component| Supported  | Displays a group of actions that can be placed anywhere on a widget.                                            |
| Action.Submit           | Component| Supported  | Collects input values.                                                            |
| Action.OpenUrl          | Component| Supported  | Opens the provided URL.                                                      |
| Action.ToggleVisibility | Component| Supported  | Switches the visibility of a group of elements.                                                      |
| ImageSet                | Component| Supported  | Displays images in a gallery.                                               
| Media                   | Component| Not supported | Indicates a media player.                                                            
| FactSet                 | Component| Supported  | Displays a series of facts (name/value pairs) in a table.                                             
| Input.Date              | Component| Not supported | Allows users to select a date.                                                             
| Input.Time              | Component| Not supported | Allows users to select a time.                                                             
| Input.Number            | Component| Supported  | Allows users to enter a number.                                                             
| Input.ChoiceSet         | Component| Not supported | Indicates a radio button.                                                              
| Input.Toggle            | Component| Not supported | Indicates a check box.                                                              
| Action.ShowCard          | Method| Supported  | Specifies whether to display the elements in an area.                                                      |
| Action.Execute           | Method| Supported  | Collects input fields.                                                           |
| Carousel          | Method| Supported  | Displays carousel images.                                                             |
| Table           | Method| Supported  | Displays data in a table.                                                          |

### About Obfuscation
- For details, see [Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/en/application-dev/arkts-utils/source-obfuscation.md).
- To prevent the adapivecards library from being obfuscated, add exclusion rules to the **obfuscation-rules.txt** configuration file.
```
-keep
./oh_modules/@ohos/adapivecards
```

## Constraints

This project has been verified in the following versions:
- DevEco Studio: DevEco Studio 5.0.2 Release (5.0.7.210), SDK: API 14 (5.0.2.123)

## Directory Structure

````
/adapivecards  # Project root directory
├── entry     # Sample code
├── library    # adaptivecards library                 
├── README.md  # Readme                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_adaptivecards/LICENSE).


## Features Not Yet Supported
* Text displayed on components does not support the Markdown format.
* Media
* Input.Date
* Input.Time
* Input.ChoiceSet
* Input.Toggle
