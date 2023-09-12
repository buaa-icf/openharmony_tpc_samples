### 1.0.1
1.修正ohpm包依赖方式：由相对路径改为依赖指定版本。

### 1.0.0
1.基于@ohos/protobufjs@1.0.1版本进行protobuf.Message的格式转换。

2.支持protobuf中基础类型：int32,uint32,bool,double,float,string。

3.protobuf.Message格式转换为json.xml.html时Message类型需要为protobuf.Builder.Message。

4.json,xml转换为protobuf.Message时，需要注意数据类型需要与原始proto文件一致。

