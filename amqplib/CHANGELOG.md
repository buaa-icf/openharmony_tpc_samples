## v1.0.2
- Release official version

## v1.0.2-rc.1
- Export the EventEmitter method
- Fixed the issue where the socket message did not pass in the amqp message channel

## v1.0.2-rc.0
- Modify the document to a GitCode address and add parameter instructions.
- Fix the issue of package compilation errors when generating har on the latest IDE.

## v1.0.1
- 发布1.0.1正式版。

## v1.0.0

- 已实现功能。

- 连接RabbitMQ服务器：使用amqplib可以轻松地连接到RabbitMQ服务器，创建一个AMQP连接对象。

- 创建通道：在AMQP连接上创建一个通道，用于发送和接收消息。

- 声明队列和交换机：使用amqplib可以声明队列和交换机，设置它们的属性和参数。

- 发布消息：使用amqplib可以将消息发布到指定的交换机和队列中。

- 消费消息：使用amqplib可以消费队列中的消息，并对消息进行确认、否定、拒绝等操作。

- 支持消息持久化：amqplib支持将消息持久化到磁盘，以确保消息不会在服务器故障时丢失。