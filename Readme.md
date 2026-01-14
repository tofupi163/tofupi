## TofuPi

TofuPi 是一个声明式terraform 框架，其摒弃复杂的代码式脚本编写，仅通过一个yaml格式声明参数配置，就可快速实现terraform 脚本的创建。单一yaml文件的描述，让使用者更容易维护terrfaorm 创建的资源，使用者可更专注目标资源的管理和使用。封装的资源模块，即可最大发挥terraform的强大功能，又可让使用者共享资源厂商的最佳实践。

TofuPi 的核心目标是简化 Terraform 配置的编写、复用及维护，强化声明式范式，不需要编程逻辑，即可快速完成相关infra资源的创建及更新，解决原生 Terraform 在大规模场景下的复用性、模块化、状态管理等痛点。

## 快速开始
* 注意1：目前仅支持aws 环境的 s3 和ssm 导入及配置，更多场景还待测试验证
* 注意2：依赖外网
* 注意3：当前仅提供 windows 版本
* 工具依赖
  * opentofu
    * https://github.com/opentofu/opentofu/releases
  * terraformer
    * https://github.com/GoogleCloudPlatform/terraformer/releases
  * 在windows 环境下，需要将 terraformer.exe 及 tofu.exe 放到 PATH 环境变量中, 也可放在bin目录中

* 创建 aws 认证
```shell
## 配置 aws 配置文件
### 创建 dev 配置 AKIAI44QH8DHBEXAMPLE  及  je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
aws configure --profile dev <<EOF
AKIAI44XXXXXXXX
je7MtGbClwBXXXXXXXXXXXXXXXXXXXXXXXXXXXX
us-east-2
json
EOF 
```
* 开始

```shell
## 初始化目录
tofupi init <project> # or .
cd <project>

## 导入现有资源 导入 aws s3 资源, 会生成 aws_terraform.tfstate 到 project 目录
tofupi import aws -r s3,ssm -p dev -g dev -P 3388

## 创建terraform
tofupi apply aws -P 3388 -g dev
```