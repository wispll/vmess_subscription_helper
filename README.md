### vmess订阅解析脚本

#### 步骤

1. 安装 **sponge**，**jq**

2. 将**config.json**，**v2ray_helper.sh**放在同一目录下

3. 默认端口是1080，可在config.json中修改

4. v2ray_helper.sh中替换为机场的订阅url

5. 执行脚本。脚本会保存最新一次连接，并默认使用。若要重新解析，加上`-n`

#### 注意

1. 浏览器走vmess，可用**SwitchOmega**，终端可用**proxychains4**

2. `-c` 打印上一次连接的缓存

3. [v2ray开启日志](https://toutyrater.github.io/basic/log.html)
