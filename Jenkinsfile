node {
    stage('checkout'){
        //必须有，该checkout步骤将检出从源控制代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订。
        echo "checkout from git repo..."
        checkout scm
    }

    //maven 路径设置：jekins插件管理->全局工具配置->Manven安装
    def mvnHome = tool('mvn3')

    //maven工作路径添加到Linux全局环境变量路径下
    env.PATH = "${mvnHome}/bin:${env.PATH}"

    //env.WORKSPACE是jenkins当前的工作路径
    def jarPath="${env.WORKSPACE}/eureka-server/target"

    //镜像构建标签
    def img_output="chp/eureka-server"

    stage('mvn build'){
        sh "mvn  clean package -U -Dmaven.test.skip=true"
    }

    stage('docker build'){

        sh "mv ${jarPath}/eureka-server-*.jar ${jarPath}/app.jar"

        sh "docker build -t $img_output ."
    }
}