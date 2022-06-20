### vmess订阅解析脚本

#### 步骤

1. 安装 **sponge**，**jq**

2. 将**config.json**，**v2ray_helper.sh**放在同一目录下

3. 默认端口是1080，可在config.json中修改

4. v2ray_helper.sh中替换为机场的订阅url

5. 执行脚本。(脚本会保存最新一次连接，并默认使用。若要重新解析，加上`-n`)

#### 演示

```bash

[ethan@eve-20238 vmess]$ ./v2ray_help.sh 
[fq1] https://www.example1.com
[fq2] https://www.example2.com
select a subscription > fq1
0	香港08	107ms
1	香港09	125ms
2	香港10	92ms
3	台湾06	0ms
4	台湾07	0ms
5	日本06	0ms
6	日本07	0ms
7	日本08	0ms
select a connection > 0
V2Ray 4.45.0 (V2Fly, a community-driven edition of V2Ray.) Custom (go1.18.1 linux/amd64)
A unified platform for anti-censorship.
2022/06/20 11:11:04 [Info] main/jsonem: Reading config: ./config.json

```

#### 注意

1. vmess依赖于系统时间，运行前可用`ntpdate ntp.aliyun.com`同步下时间

2. 服务启动后，浏览器要走vmess，可用**SwitchOmega**，终端可用**proxychains4**

3. [v2ray开启日志](https://toutyrater.github.io/basic/log.html)
