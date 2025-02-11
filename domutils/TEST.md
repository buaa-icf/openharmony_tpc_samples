# text-encoding单元测试用例

单元测试用例覆盖情况

|           接口名           |                              参数                              |                           描述                            | 是否通过	  |备注|
|:-----------------------:|:------------------------------------------------------------:|:-------------------------------------------------------:|:------:|:---:|
|      removeSubsets      |                          nodes:节点数组                          |                 删除一个节点数组中包含指定节点数组的所有节点                  |   pass |         |
| compareDocumentPosition |                    nodeA:节点数组  nodeB:节点数组                    |  将一个节点的位置与另一个节点进行比较，返回DocumentPosition中值的位掩码 |   pass |        |
|       uniqueSort        |                          nodes:节点数组                          |                 根据节点在文档中的相对位置对节点数组进行排序                  |   pass |        |
|       getElements       |      options：检查选项 nodes:节点数组 recurse:是否递归 limit:极限值无限大       |                    返回所有与options匹配的节点                    |   pass |        |
|     getElementById      |           id：节点id nodes:节点/节点数组 recurse:是否递归 true            |                      通过id获取Element                      |   pass |        |
|  getElementsByTagName   | tagName：tag节点名称 nodes:节点/节点数组 recurse:是否递归 true limit:极限值无限大 |                   通过tag名称获取Element名称                    |   pass |        |
|  getElementsByTagType   |   type：element节点名称 nodes:节点/节点数组 recurse:是否递归 limit:极限值无限大   |                   通过tag类型获取Element 类型                   |   pass |        |
|      removeElement      |                           elem：子节点                           |  移除指定子节点                                                       |   pass |        |
|     replaceElement      |                 elem：被替换节点 replacement：替换节点                  |  替换指定的子节点                                                    |   pass |        |
|       appendChild       |                     parent:父节点 child:子节点                     |  添加子节点到父节点                                                       |   pass |        |
|         append          |                   elem:子节点 next:插入节点的下一个节点                   |  添加子节点到子节点                                                       |   pass |        |
|      prependChild       |                     parent:父节点 child:子节点                     |  提前添加子节点到父节点                                                       |   pass |        |
|         prepend         |                   elem:子节点 prev:插入节点的上一个节点                   |  提前添加子节点到子节点                                                          |   pass |        |
|         filter          |               test:函数表达式 node:节点/节点数组 recurse:是否递归 true  limit:极限值                                               | 在节点及其子节点中对节点进行过滤，node 不是数组，它将被包装在一个数组中                                                    |   pass |        |
|          find           |               test:函数表达式 node:节点/节点数组 recurse:是否递归 true  limit:极限值                                              |  在节点及其子节点中对节点进行过滤，node                                                       |   pass |        |
|         findOne         |               test:函数表达式 node:节点/节点数组 recurse:是否递归 true                                               |   在Node节点数组中找到一个与指定element匹配的元素。                                                      |   pass |        | 
|        existsOne        |                   test:函数表达式 node:节点/节点数组                                            |    检查节点数组是否至少包含一个指定的Element。                                                     |   pass |        |
|         findAll         |                   test:函数表达式 node:节点/节点数组                    |    在节点数组及其子节点中寻找指定element的所有元素。                                                     |   pass |        |
|       textContent       |                         node:节点/节点数组                         |   获取节点或者节点数组文本内容，忽略注释                                                      |   pass |        |
|        innerText        |                         node:节点/节点数组                         |   获取节点或者节点数组的内部文本，忽略<script>和<style>标签，并忽略注释。                                                      |   pass |        |
|       getChildren       |                           elem:节点                            |    获取节点的子节点                                                     |   pass |        |
|        getParent        |                           elem:节点                            |  获取节点的父节点                                                       |   pass |        |
|       getSiblings       |                           elem:节点                            |    获取节点的同级节点，包括该节点本身                                                     |   pass |        |
|    getAttributeValue    |                           elem:节点    name:属性名称                               |     获取element的属性                                                    |   pass |        |
|        hasAttrib        |                           elem:节点                            |    element 是否含有某一个属性                                                     |   pass |        |
|         getName         |                           elem:节点                            |    获取element的名称                                                     |   pass |        |
|   nextElementSibling    |                           elem:节点                            |     获取element的下一个同级element                                                    |   pass |        |
|   prevElementSibling    |                           elem:节点                            |      获取element的上一个同级elemen                                                   |   pass |        |
