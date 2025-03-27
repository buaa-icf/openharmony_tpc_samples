# flatbuffers

## 简介
本软件是移植开源软件 [flatbuffers](https://github.com/google/flatbuffers) 源码在OpenHarmony上进行功能适配，在OpenHarmony上已支持原库flatbuffers的序列化和反序列化功能.

## 使用说明
1.定义数据结构：使用.fbs文件定义数据结构。在.fbs文件中，可以使用table、struct、enum等关键字来定义数据模型。  
2.生成代码：使用FlatBuffers提供的代码生成器（[Windows.flatc.binary.zip
](https://github.com/google/flatbuffers/releases/download/v25.2.10/MacIntel.flatc.binary.zip)）根据.fbs文件生成相应的代码。生成的代码包含了序列化和反序列化所需的方法和数据结构。  
3.序列化：在代码中创建数据对象，并使用FlatBuffers提供的方法将其序列化为二进制数据。序列化后的数据可以存储在文件中、通过网络发送或保存在数据库中。  
4.反序列化：在需要读取数据时，可以使用FlatBuffers提供的方法将二进制数据反序列化为数据对象。反序列化后的对象可以直接在代码中使用。  

## flatc工具使用说明
1.你需要有一个FlatBuffers的Schema文件（.fbs），这里我们假设文件名为Example.fbs，内容如下：
 ```
namespace Example;

table Person {
id:int;
name:string;
age:int;
}

root_type Person;
 ```
2.需要使用flatc编译器运行以下命令来生成TypeScript代码：
 ```
flatc --ts monster.fbs
 ```
3.生成Example.ts和example文件夹
4.在entry目录下新建文件夹,例如common,把Example.ts和example文件夹的内容复制进来
5.打开entry/src/main/ets/common/example/person.ts,将引用改为import * as flatbuffers from 'library';